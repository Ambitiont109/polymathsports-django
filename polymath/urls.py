"""polymath URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url, include, re_path
from django.contrib import admin
from django.conf.urls.static import static
from django.conf import settings

admin.site.site_header = "POLYMATH SPORTS Admin"
admin.site.site_title = "POLYMATH SPORTS Admin Portal"
admin.site.index_title = "Welcome to POLYMATH SPORTS Portal"
urlpatterns = [
    url(r'^manager-secret-login/', admin.site.urls),
    re_path('', include('users.urls')),
    re_path('orders/', include('orders.urls')),
    re_path('models/', include('models.urls')),
    re_path('customer-support/', include('customer_support.urls')),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
