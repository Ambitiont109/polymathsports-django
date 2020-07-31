"""electric_soul URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Import the include() function: from django.conf.urls import url, include
    3. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf.urls import url, include
from django.contrib import admin
from django.urls import path
from django.conf import settings
from . import views
from django.views.generic import TemplateView
from django.contrib.auth import views as auth_views


# Additionally, we include login URLs for the browsable API.

urlpatterns = [
    path('modelling_package/<str:subscription>', views.modelling_package, name='modelling_package'),
    # url(r'^$', views.home, name='home'),
    path('', views.home, name='home'),
    url('register$',views.register, name='register'),
    url('logout', views.logout_view, name='logout'),
    url('login', views.login, name='login'),
    url('profile$', views.profile, name='profile'),
    url('learning-section', views.learning_section_video, name='learning-section'),
    url('learning-vip', views.learning_section, name='learning-vip'),
    url('privacy-policy', views.privacy_policy, name='privacy-policy'),
    # learning_section
    url('change-password$', views.change_password, name='change-password'),
    path('make-payment/<subscription_id>', views.make_payment, name='make_payment'),
    
    path('manage-stripe/', views.manage_stripe, name='manage_stripe'),
    path('manage-stripe/delete', views.manage_stripe_delete, name='manage_stripe_delete'),
    # url(r'^modelling_package/(?P<value>/s+)$', views.modelling_package, name='modelling_package'),
    url('reset-password$', views.reset_password, name='reset-password'),
    url('remove-payment-card$', views.remove_card, name='remove-payment-card'),
    url(r'^reset/done/$', views.reset_password_done, name='password_reset_complete'),
    url(r'^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
        auth_views.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
    url(r'^activate/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
        views.activate, name='activate'),
    url('forgot-password$', views.forgot_password, name='forgot-password'),
    url('modeling-packages', views.modeling_packages, name='modeling-packages'),
    url('400', TemplateView.as_view(template_name='warning/400.html'), name="400"),
    url('404', TemplateView.as_view(template_name='warning/404.html'), name="404"),
    url('403', TemplateView.as_view(template_name='warning/403.html'), name="403"),
    url('500', TemplateView.as_view(template_name='warning/500.html'), name="500"),
    # url('terms-and-conditions', TemplateView.as_view(template_name='main/terms-and-conditions.html'), name="terms-and-conditions"),
    url('terms-and-conditions', views.terms, name="terms-and-conditions"),
    # url('privacy-policy', TemplateView.as_view(template_name='main/privacy-policy.html'), name="privacy-policy"),
    # url('bet-calculators', TemplateView.as_view(template_name='models/bet-calculators.html'), name="bet-calculators"),
    # url('learning-section-video', TemplateView.as_view(template_name='learning/learning-section-video.html'), name="learning-section-video"),
    # url('learning-section', TemplateView.as_view(template_name='learning/learning-section.html'), name="learning-section"),
    path('admin/', admin.site.urls),

    # url(r'^logout/', include('users.urls')),
    # url(r'^dashboard$', views.dashboard, name='dashboard'),
    # url(r'^admin_dashboard$', views.admin_dashboard, name='admin_dashboard'),
]


