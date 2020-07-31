# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin
from django import forms
# from django.contrib.auth.models import User
from .models import User, SubscriptionPlan, Profile, UserSubscriptionOrder,Video, PrivacyPolicy, NewsletterSubscribers, Terms, Education, Email

from import_export.admin import ImportExportModelAdmin ## Source: https://simpleisbetterthancomplex.com/packages/2016/08/11/django-import-export.html

# @admin.register(Profile)
# class ProfileAdmin(admin.ModelAdmin):
#
#     list_display = ('id', 'user', 'twitter', 'bio')


@admin.register(SubscriptionPlan)
class SubscriptionPlanAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'amount', 'status')
    search_fields = ('amount',)


@admin.register(Profile)
class ProfileAdmin(ImportExportModelAdmin): ## Source: https://simpleisbetterthancomplex.com/packages/2016/08/11/django-import-export.html
    list_display = ('user','user_active', 'bio','location', 'subscription_end_date','newsletter_optin', 'auto_renew', 'user_subscription_name')
    search_fields = ('user__username','location','user_subscription_name',)
    ordering = ('-created',)

admin.site.register(UserSubscriptionOrder)
admin.site.register(Video)
admin.site.register(PrivacyPolicy)
admin.site.register(Terms)
admin.site.register(Education)
admin.site.register(NewsletterSubscribers)
admin.site.register(Email)
