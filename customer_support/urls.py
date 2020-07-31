from django.conf.urls import url
from . import views

urlpatterns = [
    url('contact-us', views.contact_us, name='contact-us'),
]