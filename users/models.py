# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import uuid
# import timedelta
from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from polymath.base.utils.models import TimeStampedUUIDModel, UUIDModel
from django.utils.translation import ugettext_lazy as _

from ckeditor.fields import RichTextField

class SubscriptionPlan(TimeStampedUUIDModel):
    plan_id = models.CharField(max_length=200, blank=True)
    name = models.CharField(max_length=30, blank=True, default='Free')
    amount = models.IntegerField(default=0, blank=True)
    status = models.BooleanField(_('Plan status'), default=False,
                                 help_text='Plan is active of not active')
    duration = models.DurationField()

    class Meta:
        verbose_name = _('Subscription Plan')

    def __str__(self):
        return self.name

class NewsletterSubscribers(TimeStampedUUIDModel):
    newsletter_email = models.EmailField()

    class Meta:
        verbose_name = _('Newsletter Subscriber')
        verbose_name_plural = 'Newsletter Subscribers'
    
    def __str__(self):
        return self.newsletter_email

class Profile(TimeStampedUUIDModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.TextField(max_length=500, blank=True)
    location = models.CharField(max_length=30, blank=True)
    twitter = models.CharField(max_length=100, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    profile_pic = models.ImageField(null=True, blank=True, upload_to="profile_pics")
    stripe_customer_key = models.CharField(max_length=100, blank=True)
    customer_subscription_id = models.CharField(max_length=100, blank=True)
    customer_payment_method = models.CharField(max_length=100, blank=True)
    subscription_id = models.CharField(max_length=100, blank=True)
    subscription_end_date = models.DateField(null=True, blank=True)
    auto_renew = models.BooleanField(default=True)
    newsletter_optin = models.BooleanField(default=True)
    email = models.CharField(max_length=100, blank=True)
    user_active = models.BooleanField(default=False)
    user_subscription_name = models.CharField(max_length=100, blank=True)

    class Meta:
        verbose_name = _('Profile')

    def __str__(self):
        return self.user.username

    def subscription(self):
        subscription_order = UserSubscriptionOrder.objects.filter(user=self.user, active=True).first()
        if subscription_order:
            return subscription_order.subscription_plan
        return None

    def expiry_date(self):
        if self.subscription():
            return (self.subscription().duration + self.created).date()
        return None


class UserSubscriptionOrder(TimeStampedUUIDModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    subscription_plan = models.ForeignKey(SubscriptionPlan, null=True, blank=True, on_delete=models.CASCADE)
    active = models.BooleanField(_('Order status'), default=True,
                                 help_text='Order is active of not active')

    def __str__(self):
        return "{} ({})".format(self.user.username, self.subscription_plan and self.subscription_plan.name or "")

    # def expiry_date(self):
    #     return self.subscription_plan.duration + self.created

class Video(models.Model):
    # video = models.TextField(default = 'sample.mp4', max_length = 200)
    video_homepage = models.CharField(null=True, max_length = 200, help_text='Name of the video file. All videos are to be uploaded to the static/videos folder.')
    video_education = models.CharField(null=True, max_length = 200, help_text='Name of the video file. All videos are to be uploaded to the static/videos folder.')
    
    def __str__(self):
        return f'homepage:{self.video_homepage} | educaiton: {self.video_education}'


class PrivacyPolicy(models.Model):
    policy = models.TextField(null = True, max_length = 50000)
    
    def __str__(self):
        return self.policy

class Terms(models.Model):
    terms = models.TextField(null = True, max_length = 50000)

    class Meta:
        verbose_name = _('Terms')
        verbose_name_plural = 'Terms'

    def __str__(self):
        return self.terms


class Education(models.Model):
    title = models.CharField(max_length=100, null=True)
    body = models.TextField(null=True, max_length = 50000)
    video = models.CharField(max_length=100, null=True, help_text='Name of the video file. All videos are to be uploaded to the staticfiles/videos folder.')
    
    class Meta:
        verbose_name = _('Education')
        verbose_name_plural = 'Education'

    def __str__(self):
        return self.title

class Email(models.Model):
    name = models.CharField(max_length=100)
    mail_subject = models.CharField(max_length=100)
    mail_title = models.CharField(max_length=100)
    mail_body = models.TextField(max_length=5000)

    class Meta:
        verbose_name = _('Email Format')
        verbose_name_plural = 'Email Formats'

   
    def __str__(self):
        return self.name



# class AdminVideo(models.Model):
#     video = models.CharField(default = 'sample-video.mp4', max_length = 200)
    
#     def __str__(self):
#         return self.video


