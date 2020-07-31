# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json

from django.contrib import admin
from import_export.admin import ImportExportModelAdmin ## Source: https://simpleisbetterthancomplex.com/packages/2016/08/11/django-import-export.html
from django.contrib.admin.views.main import ChangeList
from django.utils.html import format_html
from django.conf.urls import url
from django.shortcuts import redirect
from django.http import HttpResponse
from django.db import models
from .models import Sports, Game, TargetVarriables, PredictorVarriables, MLAlgorithms, UserModels, PredictorsVariablesCategories, PredictorsVariablesSubCategories


@admin.register(UserModels)
class UserModels(admin.ModelAdmin):
    list_display = (
        'created',
        'id',
        'user', 
        'model_name', 
        'model_sport', 
        'model_game',
        'model_target_variables', 
        'model_predictor_variables', 
        'model_variables_manipulation', 
        'model_algorithm',
        'model_score')
    search_fields = ('name',)
    ordering = ('-created',)

@admin.register(Sports)
class Sports(admin.ModelAdmin):
    list_display = ('id','name', 'status')
    search_fields = ('name',)
    ordering = ('-created',)

@admin.register(Game)
class Game(admin.ModelAdmin):
    list_display = ('teams','sport','date','active')
    search_fields = ('sport__name','date', 'teams')
    ordering = ('-created',)

@admin.register(TargetVarriables)
class TargetVarriables(admin.ModelAdmin):
    list_display = ('name', 'status','sport')
    search_fields = ('name',)
    ordering = ('-created',)

@admin.register(PredictorVarriables)
class PredictorVarriables(ImportExportModelAdmin): ## Source: https://simpleisbetterthancomplex.com/packages/2016/08/11/django-import-export.html
    # field_sets = [
    #     'Category', {'fields': 'predictorssubcategories'}
    # ]
    list_display = ('name','description', 'status','sport', 'category','sub_category', 'access')
    search_fields = ('name',)
    ordering = ('-created',)

admin.site.register(PredictorsVariablesCategories)
admin.site.register(PredictorsVariablesSubCategories)
# @admin.register(PredictorsVariablesCategories)
# class PredictorsVariablesCategories(admin.ModelAdmin):
#     list_display = ('sub_category_name', 'category_status')
#     search_fields = ('name',)
#     ordering = ('-created',)

# @admin.register(PredictorsVariablesSubCategories)
# class PredictorsVariablesSubCategories(admin.ModelAdmin):
#     list_display = ('category_name','parent_category', 'category_status')
#     search_fields = ('name',)
#     ordering = ('-created',)


@admin.register(MLAlgorithms)
class MLAlgorithms(admin.ModelAdmin):
    list_display = ('name','access','algo_type', 'status')
    search_fields = ('name',)
    ordering = ('-created',)
