from django.conf.urls import url, include
from django.conf import settings
from . import views
from django.views.generic import TemplateView
from django.contrib.auth import views as auth_views

# Additionally, we include login URLs for the browsable API.

urlpatterns = [
    url(r'^payment$', views.payment, name='payment'),
    url(r'^add-card$', views.add_card, name='add-card'),
    url(r'^remove-card$', views.remove_card, name='remove-card'),
]