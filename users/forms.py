# # users/forms.py
from django import forms
from .models import  NewsletterSubscribers
# from django.contrib.auth.forms import UserCreationForm, UserChangeForm
# from django.contrib.auth.models import User
#
# class UserForm(forms.ModelForm):
#     class Meta:
#         model = User
#         fields = ('first_name', 'last_name', 'email')
#
# class ProfileForm(forms.ModelForm):
#     class Meta:
#         model = Profile
#         fields = ('url', 'location', 'company')
class NewsletterForm(forms.ModelForm):
    class Meta:
        model = NewsletterSubscribers
        fields = ('newsletter_email',)
