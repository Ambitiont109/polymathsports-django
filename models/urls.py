from django.conf.urls import url, include
from django.urls import path
from django.conf import settings
from django.views.generic import TemplateView
from django.contrib.auth import views as auth_views

from . import views
from .views import ChartData, Graph

# Additionally, we include login URLs for the browsable API.

urlpatterns = [
    url('modal-page', views.modal_page, name='modal-page'),
    # url('build-model', views.build_model, name='build-model'),
    url('user-flow', views.user_flow, name='user-flow'),
    path('build-model/<int:predict>', views.build_model, name='make-models-step-1'),
    # url(r'^make-models/step-1$', views.build_model, name='make-models-step-1'),
    url(r'^make-models/step-2$', views.target_variable, name='make-models-step-2'),
    url(r'^make-models/step-3$', views.predictor_variable, name='make-models-step-3'),
    url(r'^make-models/step-4$', views.manipulate_predictor_variable, name='make-models-step-4'),
    # url(r'^make-models/step-4-1$', views.payment, name='make-models-step-4-1'),
    url(r'^make-models/step-5$', views.algorithm, name='make-models-step-5'),
    url(r'^make-models/step-5-1$', views.algorithm, name='make-models-step-5-1'),
    url(r'^make-models/step-6$', views.model_evalution_stats, name='make-models-step-6'),
    
    # url(r'^make-models/step-6-1$', views.payment, name='make-models-step-6-1'),
    url(r'^make-models/step-7$', views.get_model, name='make-models-step-7'),
 
    url('select-ml-model', views.select_ml_model, name='select-ml-model'),
    url('ajax/model-details', views.model_details, name='model_details'),
    url('model-predictions', views.model_predictions, name='model-predictions'),
    url('model-details-modal', views.model_details_modal, name='model-details-modal'),
    url('model-report', views.model_report, name='model-report'),



    path('bet-calculators/', views.bet_calculators, name="bet-calculators"),
    path('add-games/', views.add_games, name='add-games'),
    path('ajax/load-games/', views.ajax_load_games, name='ajax_load_games'),
    path('ajax/load-predictors/', views.ajax_load_predictors, name='ajax_load_predictors'),
    path('ajax/load-predictors-sub/', views.ajax_load_predictors_sub, name='ajax_load_predictors_sub'),
    path('api/chart-data/', ChartData.as_view(), name='api-chart-data'),
    # path('graph/', Graph.as_view(template_name = 'models/graph.html'), name='graph'),
]