import datetime
import random
import json
import pickle
import numpy as np
import pandas as pd
import plotly.offline as opy
import plotly.express as px
import plotly.graph_objs as go

from plotly.offline import plot
from plotly.graph_objs import Scatter, Heatmap, Layout, Figure, Data
from matplotlib import  pyplot as plt

from datetime import timedelta
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponseNotFound, HttpResponseBadRequest, HttpResponse, HttpResponseRedirect, Http404
from django.contrib.auth.models import User
from django.conf import settings
from django.urls import reverse_lazy, reverse
from django.contrib import messages
from django.views.generic import TemplateView
from django.core import serializers

from rest_framework.views import APIView
from rest_framework.response import Response

from django.db import connection

from sklearn import preprocessing, tree
from sklearn.metrics import confusion_matrix

from users.models import Profile, SubscriptionPlan, UserSubscriptionOrder
from .models import Sports, Game, TargetVarriables, PredictorVarriables, MLAlgorithms, UserModels, PredictorManipulations, PredictorsVariablesCategories, PredictorsVariablesSubCategories
from .forms import UserSportGameSelection, UserModelDataForm, PredictorManipulationFrom

from users import tasks
from .ml_models_wrapper import ml_wrapper


def clear_session(request):
    session_keys = ['user_flow', 'modelName', 'sport_id', 'game_ids', 'target_variable', 'predictor_variables', 'model_algorithm', 'model_saved_path', 'model_score']
    
    try:
        for key in session_keys:
            del request.session[key]
    except KeyError:
        return

    return


def access_db(sport):
    with connection.cursor() as cursor:
        # cursor.execute("UPDATE bar SET foo = 1 WHERE baz = %s", [self.baz])
        # cursor.execute("SELECT foo FROM bar WHERE baz = %s", [self.baz])

        # cursor.execute("select date from nfl_data where results='2'")
        cursor.execute(f"select Date,HomeTeam, VisitTeam from {sport.lower()}_data")
        
        # row = cursor.fetchone()
        rows = cursor.fetchall()

    return rows

def game_date_conversion(date):
    
    game_time_arr = date.split('-')
    game_month = game_time_arr[1] if len(game_time_arr[1]) > 1 else '0' + game_time_arr[1]
    game_day = game_time_arr[2] if len(game_time_arr[2]) > 1 else '0' + game_time_arr[2]
    game_year = game_time_arr[0]
    game_time = f'{game_month}/{game_day}/{game_year}'
    
    date_time_obj = datetime.datetime.strptime(game_time, '%m/%d/%Y')

    return date_time_obj


# add_sports for testing purposes.
def add_games(request):
    '''
    Collect all future games and load to the admin. Will be called when loading 'add-games' page.
    :returns: none
    :param: 
    :return: 
    '''

    # Removing previous games data
    with connection.cursor() as cursor:
        cursor.execute(f"truncate table models_game")
        
    sports_list = ['nfl', 'nba']

    for sport in sports_list:
        sport_id = Sports.objects.get(name=sport.upper())
        try:
            db_games_data = access_db(sport.lower())
            future_games = []

            for d_game in db_games_data:
                game_date = game_date_conversion(d_game[0])

                if settings.DEBUG:
                    if game_date >= datetime.datetime.today() - timedelta(0):
                        future_games.append(d_game[1:])
                else:
                    if game_date >= datetime.datetime.today():
                        future_games.append(d_game[1:])

            for f_game in future_games:
                game = Game()
                game.teams = f'{f_game[0]} vs. {f_game[1]}'
                game.date = game_date
                game.sport = sport_id
                game.save()

        except Exception as e :
            print(f'Failed loading games for {sport}. Reason: {e}')

    return render(request, 'main/load-games.html', {})

def delete_session(request):
    try:
        del request.session['user']
        del request.session['password']
    except KeyError:
        pass
    
    return render(request, 'home')

# For the games dropdown menu in the first model creation page.
def ajax_load_games(request):
    sport_id = request.GET.get('sport')
    sport_name = str(Sports.objects.get(id=sport_id))

    # Retreiving ACTIVE (!!!) future games data
    games = Game.objects.filter(active=True, sport=sport_id)

    subscription_id = Profile.objects.get(user=request.user).subscription_id
    if subscription_id == settings.BASIC_WEEKLY_SUBSCRIPTION_ID or subscription_id == settings.VIP_SUBSCRIPTION_ID or subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID:
        plan = 'OK'
    else:
        plan = 'FREE'
    
    context = {
        'games': games,
        'plan': plan
    }
    # print(f'context: {context}')

    return render(request, 'partials/load_games.html', context)

def ajax_load_predictors(request):
    context = {}
    category = request.GET.get('cateogry')

    predictors = PredictorVarriables.objects.filter(category=category)

    context['predictors'] = predictors
    
    print(f'PREDICTORS: {predictors}')

    return render(request, 'partials/load_predictors.html', context)

def ajax_load_predictors_sub(request):
    context = {}    
    sport = request.GET.get('sport')
    category = request.GET.get('category')
    sub_category = request.GET.get('sub_category')
    
    #predictors_sub = PredictorVarriables.objects.filter(sport_id=sport,category_id=category,sub_category_id=sub_category)

    #context['predictors_sub'] = predictors_sub
    
    #print(f'PREDICTORS_SUB: {predictors_sub}')


    predictors_sub = PredictorVarriables.objects.filter(sport_id=sport,category_id=category,sub_category_id=sub_category).values('pk', 'name', 'description')
    return JsonResponse({'status': 200, 'payload': list(predictors_sub), "sport": sport, "category": category, "sub_category": sub_category})
    
    #return render(request, 'partials/load_predictors_sub.html', context)


def user_flow(request):
    context = {}
    context['user_flow'] = None

    if request.method == 'POST':
        user_flow = request.POST.get('flow_selector')
        if user_flow == 'Build a New Model':
            context['user_flow'] = 'build_model'
            request.session['user_flow'] = 'build_model'
            return redirect('make-models-step-1', predict=0)
        elif user_flow == 'Predict with a Saved Model':
            context['user_flow'] = 'predict_games'
            request.session['user_flow'] = 'predict_games'
            return redirect('make-models-step-1', predict=1)
        else:
            context['user_flow'] = 'build_model'
            request.session['user_flow'] = 'build_model'
            return redirect('make-models-step-1', predict=0)
    else:    
        return render(request, 'models/build-your-own-model-step-one.html', context)

    return render(request, 'models/build-your-own-model-step-one.html', context)

@login_required
def build_model(request, predict=0):
    context = {}
    if predict == 1:
        user_flow = 'predict_games'
    else:
        user_flow = request.session['user_flow']

    context['user_flow'] = user_flow

    subscription_id = Profile.objects.get(user=request.user).subscription_id

    # Setting up a default expiration date to a free account to today+1
    if subscription_id == settings.FREE_SUBSCRIPTION_ID:
        subscription_end_date = datetime.date.today() + timedelta(days=1)
    else:
        subscription_end_date = Profile.objects.get(user = request.user).subscription_end_date
    # print('plan_name',UserSubscriptionOrder.objects.filter(user = request.user).first())
    present_date = datetime.date.today()
    
    print(f'User: {request.user}')
    print(f'Subscription: {subscription_id}')
    print(f'Subscription end date: {subscription_end_date}')


    # Cheking any subscription
    if subscription_end_date > present_date:
        sports = Sports.objects.filter(status=True)
        games = Game.objects.filter(active=True)
        
        context['sports'] = sports
        context['games'] = games
    
        if request.method == 'POST':
            if 'goto_predict_flow' in request.POST:
                context['user_flow'] = 'predict_games'
                return render(request, 'models/build-your-own-model-step-one.html', context)
            else:
                model_name   = request.POST.get('modelName')
                user_sport  = request.POST.get('sport_id')
                user_games   = request.POST.getlist('game_id')
                select_all_games = request.POST.get('select_all')
                print(f'select all: {select_all_games}')
                user_game_selection_form =  UserSportGameSelection()
                user_game_selection_form.model_name = model_name
                user_game_selection_form.sport = user_sport
                
                print(f'model_name: {model_name}, sport: {user_sport}, games: {user_games}')
                
                if select_all_games == None:
                    user_game_selection_form.games = user_games
                else:
                    sport = Sports.objects.get(id=user_sport)
                    db_data = access_db(str(sport).lower())

                    future_games = []
                    for game in db_data:
                        game_date = game_date_conversion(game[0])
                        if game_date > datetime.datetime.today():
                            future_games.append(game[1:])

                    games = []
                    for game in future_games:
                        games.append(f'{game[0]} vs. {game[1]}')

                    user_game_selection_form.games = games

                if user_game_selection_form.validate(user_flow) == False:
                    messages.error(request, 'Please make your selection')
                    return render(request, 'models/build-your-own-model-step-one.html', context)
                elif user_flow == 'predict_games':
                    request.session['sport_id'] = user_game_selection_form.sport
                    request.session['game_ids'] = user_game_selection_form.games
                    return HttpResponseRedirect(reverse('select-ml-model'))
                else:
                    request.session['modelName'] = user_game_selection_form.model_name
                    request.session['sport_id'] = user_game_selection_form.sport
                    request.session['game_ids'] = user_game_selection_form.games
                    return HttpResponseRedirect(reverse('make-models-step-2'))
    else:
        messages.info(request,'Please registed to access this page fuctionality')

    return render(request, 'models/build-your-own-model-step-one.html', context)

@login_required
def select_ml_model(request):
    context = {}
    request.session['user_flow'] = 'predict_games'
    user = request.user

    if 'sport_id' not in request.session.keys():
        messages.error(request, 'Please select sport first.')
        return HttpResponseRedirect(reverse('make-models-step-1'))


    else:
        user_sport_id = request.session['sport_id']
        user_sport = Sports.objects.get(id=user_sport_id).name
        models = UserModels.objects.filter(user=user, model_sport=user_sport)
        context['models'] = models

        if request.method ==  'POST':
            user_model_id = request.POST.get('model_selector')
            request.session['model_id'] = user_model_id
            return HttpResponseRedirect(reverse('model-predictions'))

        
        return render(request, 'models/select-your-model.html', context)



    

def model_details(request):
    context = {}
    model_id = request.GET.get('model')
    user = request.user
    user_sport_id = request.session['sport_id']
    user_sport = Sports.objects.get(id=user_sport_id).name
    user_model = UserModels.objects.filter(user=user, id=model_id)
        
    context['model'] = user_model        

    return render(request, 'models/model_details.html', context)

@login_required
def model_details_modal(request):
    context = {}
    return render(request, 'models/model_details_modal.html', context)

@login_required
def modal_page(request):
    context = {}
    user = request.user
    user_models = UserModels.objects.filter(user=user)
    print(f'user_models: {user_models}')
    context['user_models'] = user_models

    if request.method == 'POST':
        model_id = request.POST.get('model_id')
        request.session['model_id'] = model_id
        return HttpResponseRedirect(reverse('model-report'))

    return render(request, 'models/my-modal-page.html', context)


@login_required
def target_variable(request):
    context = {}

    user_flow = request.session.get('user_flow')
    context['user_flow'] = user_flow

    if not request.session.get('sport_id'):
        messages.warning(request, 'No model created. Please start from "Select Your Game/s" page.')
    else:
        print(f'current session sport: {request.session["sport_id"]}')
        targetvariables = TargetVarriables.objects.filter(sport=request.session['sport_id'])
        context = {'targetvariables':targetvariables}

    if request.method == 'POST':
        if 'goto_predict_flow' in request.POST:
            # context['user_flow'] = 'predict_games'
            # return render(request, 'models/build-your-own-model-step-one.html', context)
            return HttpResponseRedirect(reverse('make-models-step-1-a'))
        else:
            target_variable = request.POST.get('target_variable')
            request.session['target_variable'] = target_variable
            if request.session['target_variable'] == '':
                messages.error(request, 'Please choose a target variable before proceeding')
                return HttpResponseRedirect(reverse('make-models-step-2'))
            else:
                return HttpResponseRedirect(reverse('make-models-step-3'))

    return render(request, 'models/build-your-own-model-step-two.html', context)


@login_required
def predictor_variable(request):
    context = {}
    
    categories = PredictorsVariablesCategories.objects.all()
    sub_categories = PredictorsVariablesSubCategories.objects.all()
    context['categories'] = categories
    context['sub_categories'] = sub_categories

    user_flow = request.session.get('user_flow')
    context['user_flow'] = user_flow

    subscription_id = Profile.objects.get(user=request.user).subscription_id
    if subscription_id == settings.VIP_SUBSCRIPTION_ID or subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID or subscription_id == settings.BASIC_WEEKLY_SUBSCRIPTION_ID:
        subscription = 'premium'
    else:
        subscription = 'free'
    
    if not request.session.get('sport_id'):
        messages.warning(request, 'No model created. Please start from "Select Your Game/s" page.')
    else:
        print(f'current session sport: {request.session["sport_id"]}')
        # predictors_query = PredictorVarriables.objects.filter(sport=request.session['sport_id']).values( 'category_id', 'sub_category_id').query
        selector_sub_categories = PredictorVarriables.objects.select_related('category','sub_category').filter(sport=request.session['sport_id'], status=True, category_id__isnull=False).values('category_id', 'category__category_name', 'sub_category_id','sub_category__sub_category_name').distinct()
        selector_categories = PredictorVarriables.objects.select_related('category').filter(sport=request.session['sport_id'], status=True, category_id__isnull=False).values('category_id', 'category__category_name').order_by('category__category_name').distinct()
        # add subscription filter
        context['sport_id'] = request.session["sport_id"]
        context['selector_categories'] = selector_categories
        context['selector_sub_categories'] = selector_sub_categories
        context['subscription_id'] = subscription

        if 'predictors' in request.session:
            context['predictors']  = PredictorVarriables.objects.filter(pk__in=request.session['predictors'])     
        
    if request.method == 'POST':
        if 'goto_predict_flow' in request.POST:
            context['user_flow'] = 'predict_games'
            return render(request, 'models/build-your-own-model-step-one.html', context)
        else:
            #user_predictors = request.POST.getlist('predictor_variable')
            #print(f'Predictor variable: {user_predictors}')
            #request.session['predictor_variables'] = user_predictors

            request.session['predictors'] = request.POST.getlist('predictors')    
            request.session['predictor_variables'] = list(set(list(PredictorVarriables.objects.filter(pk__in=request.session['predictors']).values_list('name', flat=True))))

        if request.session['predictor_variables'] == '' or request.session['predictor_variables'] == None or request.session['predictor_variables'] == []:
            messages.error(request, 'Please choose a predictor before proceeding')
            return HttpResponseRedirect(reverse('make-models-step-3'))
        else:
            return HttpResponseRedirect(reverse('make-models-step-4'))

    return render(request, 'models/build-your-own-model-step-three.html', context)


@login_required
def manipulate_predictor_variable(request):
    context = {}

    user_flow = request.session.get('user_flow')
    context['user_flow'] = user_flow

    manipulation = {}
    manipulation_list = []
    subscription_id = Profile.objects.get(user=request.user).subscription_id
    if subscription_id == settings.VIP_SUBSCRIPTION_ID or subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID:
        # context['predictor_variables'] = PredictorVarriables.objects.filter(id=request.session['predictor_variables'])

        if not request.session.get('sport_id'):
            messages.warning(request, 'No model created. Please start from "Select Your Game/s" page.')
        else:
            context['predictor_variables'] = request.session['predictor_variables']
            context['user_manipulations'] = PredictorManipulations.objects.filter(user=request.user)
            print(f'context: {context}')

        
        if request.method == 'POST':
            manipluation_form = PredictorManipulationFrom()
            if 'add_manipulator' in request.POST:

                print(f'''
                user: {request.user}\n
                manipulation: {request.POST.get('manipulate')}\n
                predictors: {request.POST.get('predictor_variable')}\n
                manipulator value: {request.POST.get('multiplier')} 
                ''')

                if request.POST.get('predictor_variable') != "Select Variable to Manipulate":
                    user_manipulation = PredictorManipulations.objects.create(
                        user=request.user,
                        manipulation=request.POST.get('manipulate'),
                        predictors = request.POST.get('predictor_variable'),
                        manipulator_value = request.POST.get('multiplier')
                    )

                    user_manipulation.save()

                    user_manipulations = PredictorManipulations.objects.filter(user=request.user)
                    for p in user_manipulations:
                        print(f'user manipulation: {p.predictors}')

                    context['user_manipulations'] = user_manipulations

                else:
                    messages.error(request, "Variable to manipulate was not selected.")

                return render(request, 'models/build-your-own-model-step-four-one.html', context)
            
            elif 'delete_manipulator' in request.POST:
                print(f"Delete manipulator ID: {request.POST['delete_manipulator']}")
                
                # Deleting the manipulator
                PredictorManipulations.objects.filter(id=request.POST['delete_manipulator']).delete()
                
                user_manipulations = PredictorManipulations.objects.filter(user=request.user)
                context['user_manipulations'] = user_manipulations
                return render(request, 'models/build-your-own-model-step-four-one.html', context)
            
            # The the "Next" button was clicked
            else:
                manipulators =  PredictorManipulations.objects.filter(user=request.user)
                manipulators_array = []
                for i in range(len(manipulators)):
                    manipulators_array.append(str(manipulators[i].id))

                request.session['manipulators_ids'] = manipulators_array
                 
                target = str(TargetVarriables.objects.get(id=request.session['target_variable']))

                if target == 'TotalScore' or target == 'HomeScore' or target == 'AwayScore':
                    algorithms = MLAlgorithms.objects.filter(status=True, algo_type='regressor')
                else:
                    algorithms = MLAlgorithms.objects.filter(status=True, algo_type='classifier')

                context = {'algorithms':algorithms}

                return HttpResponseRedirect(reverse('make-models-step-5-1'))

        else:
            return render(request, 'models/build-your-own-model-step-four-one.html', context)

    else:
        return render(request, 'models/build-your-own-model-step-four.html', {'predictor_vars' : request.session.get('predictors')})


@login_required
def algorithm(request):
    # algorithms = MLAlgorithms.objects.filter(status=True, access='free')
    context = {}
    user_flow = request.session.get('user_flow')
    context['user_flow'] = user_flow    

    target = str(TargetVarriables.objects.get(id=request.session['target_variable']))

    if target == 'TotalScore' or target == 'HomeScore' or target == 'AwayScore':
        algorithms = MLAlgorithms.objects.filter(status=True, algo_type='regressor')
    else:
        algorithms = MLAlgorithms.objects.filter(status=True, algo_type='classifier')

    context = {'algorithms':algorithms}

    subscription_id = Profile.objects.get(user=request.user).subscription_id

    if 'predictor_variables' in request.session.keys():
        pass
    else:
        messages.error(request, 'Please choose a predictor before proceeding')
        return HttpResponseRedirect(reverse('make-models-step-3'))


    if request.method == 'POST':
        # user_model_data = UserModelDataForm(request.POST)
        user_model_data = UserModels()
        manipulations = []

        algorithm = request.POST.get('model_algorithm')
        
        request.session['model_algorithm'] = algorithm
        if request.session['model_algorithm'] == '':
            messages.error(request, 'Please choose algorithm')
            return HttpResponseRedirect(reverse('make-models-step-5'))
            

        request.session['model_algorithm'] = algorithm

        target = TargetVarriables.objects.get(id=request.session['target_variable'])

        user_model_data.user = request.user
        user_model_data.model_name =  request.session['modelName']
        user_model_data.model_sport =  Sports.objects.get(id=request.session.get('sport_id')).name
        user_model_data.model_game = request.session['game_ids']
        user_model_data.model_target_variables = target
        user_model_data.model_predictor_variables = request.session['predictor_variables']
        user_model_data.model_algorithm = MLAlgorithms.objects.get(id=request.session['model_algorithm'])

        if subscription_id == settings.VIP_SUBSCRIPTION_ID or subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID:
            manipulations_ids = request.session['manipulators_ids']
            
            for manip in manipulations_ids:
                manipulations.append(PredictorManipulations.objects.get(id=manip))
            
            user_model_data.model_variables_manipulation = manipulations
            user_model_data.model_cross_validation_folds = int(request.POST.get('folds'))

            print(f'''
                Session data: 
                user:                           {request.user}
                model_name:                     {request.session.get('modelName')}
                model_sport:                    {request.session.get('sport_id')}
                model_games:                     {request.session['game_ids']}
                model_target_variables:         {request.session['target_variable']}
                model_predictor_variables:      {request.session['predictor_variables']}
                model_variables_manipulation:   {request.session['manipulators_ids']}
                model_cross_validation_folds:   {request.POST.get('folds')}
                model_algorithm:                {request.session['model_algorithm']}
            ''')
        else:
            print(f'''
                Session data: 
                user:                           {request.user}
                model_name:                     {request.session.get('modelName')}
                model_sport:                    {request.session.get('sport_id')}
                model_games:                     {request.session['game_ids']}
                model_target_variables:         {request.session['target_variable']}
                model_predictor_variables:      {request.session['predictor_variables']}
                model_algorithm:                {request.session['model_algorithm']}
            ''')


        sport = Sports.objects.get(id=request.session.get('sport_id')).name
        # target = TargetVarriables.objects.get(id=request.session['target_variable'])
        algorithm_name = MLAlgorithms.objects.get(id=request.POST.get('model_algorithm')).name
        print(f'TARGET: {target}')
        print(f'ALGO: {algorithm_name}')
        print(f'SPORT: {sport}')
        print(f'MANIPULATIONS: {manipulations}')
        print(f'PREDICTORS: {request.session["predictor_variables"]}')
        
        # ML models wrapper
        graph_data, model_score, model_path, model_type = ml_wrapper(
            action='build',
            model_name=request.session['modelName'],
            sports_path=settings.SPORTS_PATH + sport.lower(),
            sport=sport,
            target=str(target),
            predictors=request.session['predictor_variables'],
            manipulations=manipulations,
            algorithm=algorithm_name
        )

        user_model_data.model_saved_path = model_path
        user_model_data.model_score = model_score[0] # Assigning the train score
        if model_type == 'classifier':
            user_model_data.model_train_score = model_score[0] 
            user_model_data.model_test_score = model_score[1] 
            user_model_data.model_classification_report = model_score[2]
            user_model_data.model_graph_data = graph_data
        else:
            user_model_data.model_train_score = model_score[0] 
            user_model_data.model_test_score = model_score[1] 
            user_model_data.model_train_mae = model_score[2]
            user_model_data.model_test_mae = model_score[3]
            user_model_data.model_graph_data = graph_data
        
        user_model_data.model_type = model_type

        request.session['model_saved_path'] = model_path
        request.session['model_score'] = model_score[0]

        user_model_data.save()
        messages.success(request, 'Your model was saved into the database.')

        # Delete all manipulators data from DB
        PredictorManipulations.objects.filter(user=request.user).delete()
        
        return HttpResponseRedirect(reverse('make-models-step-6'))
    
    if subscription_id == settings.VIP_SUBSCRIPTION_ID or subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID:
        return render(request, 'models/build-your-own-model-step-five-one.html', context)
    else:
        return render(request, 'models/build-your-own-model-step-five.html', context)



@login_required
def model_predictions(request):
    context = {}
    subscription_id = Profile.objects.get(user=request.user).subscription_id
    user_flow = request.session.get('user_flow')
    context['user_flow'] = user_flow


    # if subscription_id == settings.VIP_SUBSCRIPTION_ID:

    if 'model_id' not in request.session.keys():
        messages.error(request, 'No model selected.')
        return HttpResponseRedirect(reverse('select-ml-model'))

    elif 'sport_id' not in request.session.keys():
        messages.error(request, 'No sport selected.')
        return HttpResponseRedirect(reverse('make-models-step-1'))

    else:
        user_model_id = request.session.get('model_id')
        user_selected_model = UserModels.objects.get(id=user_model_id)

        # Extracting model information
        path_to_model = user_selected_model.model_saved_path
        
        predictor_variables = UserModels.objects.get(model_saved_path=path_to_model).model_predictor_variables
        score_tmp = 100 * user_selected_model.model_score
        model_score = float("%.2f"%score_tmp)

        sport_name = user_selected_model.model_sport
        sports_csv_path = settings.SPORTS_PATH + sport_name.lower() + f"/{sport_name.upper()}_Final.csv"
        games = request.session.get('game_ids')

        target_var =  str(user_selected_model.model_target_variables)
        
        if target_var == 'TotalScore' or target_var == 'HomeScore' or target_var == 'AwayScore':
            target = target_var
        else:
            target = 'classification'
        
        games_predictions = model_prediction(target=target_var ,sport_csv_path=sports_csv_path,path_to_model=path_to_model,games=games, predictor_variables=predictor_variables)

        if user_flow == 'build_model':
            context = {
                'user_flow': user_flow,
                'model_name': request.session.get('modelName'),
                'sport': Sports.objects.get(id=request.session.get('sport_id')).name,
                'games': request.session.get('game_ids'),
                'target': target,
                'target_variable': target_var,
                'predictor_variables': request.session['predictor_variables'],
                'algorithm': request.session['model_algorithm'],
                'model_score': model_score,
                'model_saved_path': request.session.get('model_saved_path'),
                'games_predictions': games_predictions
            }
        else:
            context = {
                'user_flow': user_flow,
                'model_name': request.session.get('modelName'),
                'sport': Sports.objects.get(id=request.session.get('sport_id')).name,
                'target': target,
                'target_variable': target_var,
                'model_score': model_score,
                'games': request.session.get('game_ids'),
                'games_predictions': games_predictions
            }
            

    
    if request.method == 'POST':
        pass


    else:
        return render(request, 'models/model_predictions.html', context)

@login_required
def model_evalution_stats(request):
    context = {}
    user_flow = request.session.get('user_flow')
    context['user_flow'] = user_flow    


    subscription_id = Profile.objects.get(user=request.user).subscription_id
    
# if subscription_id == settings.VIP_SUBSCRIPTION_ID:

    user_latest_model = UserModels.objects.filter(user=request.user).last()
    current_session_model = request.session.get('modelName')
    current_session_model_score = request.session.get('model_score')
    
    if not current_session_model or not current_session_model_score:
        messages.warning(request, 'No model created. Please start from "Select Your Game/s" page.')
        return redirect('/models/build-model/0')
    else:
        # Extracting model information
        path_to_model = request.session.get('model_saved_path')
        model_score = float(request.session.get('model_score'))
        sport_name = Sports.objects.get(id=request.session.get('sport_id')).name
        sports_csv_path = settings.SPORTS_PATH + sport_name.lower() + f"/{sport_name.upper()}_Final.csv"
        games = request.session.get('game_ids')

        predictor_variables = UserModels.objects.get(model_saved_path=path_to_model).model_predictor_variables

        target_var =  str(TargetVarriables.objects.get(id=request.session['target_variable']))
        
        if target_var == 'TotalScore' or target_var == 'HomeScore' or target_var == 'AwayScore':
            target = target_var
        else:
            target = 'classification'

        games_predictions = model_prediction(target=target_var ,sport_csv_path=sports_csv_path,path_to_model=path_to_model,games=games, predictor_variables=predictor_variables)

        context = {
            'model_name': request.session.get('modelName'),
            'sport': Sports.objects.get(id=request.session.get('sport_id')).name,
            'games': request.session.get('game_ids'),
            'target': target,
            'target_variable': target_var,
            'predictor_variables': request.session['predictor_variables'],
            'algorithm': request.session['model_algorithm'],
            'model_score': model_score,
            'model_saved_path': request.session.get('model_saved_path'),
            'games_predictions': games_predictions
        }

    
    return render(request, 'models/build-your-own-model-step-six-one.html', context)

# else:
    # return render(request, 'models/build-your-own-model-step-six-one.html', context)
    

def model_prediction(target, path_to_model, sport_csv_path, games, predictor_variables):
    today = datetime.datetime.today()

    predictor_vars = predictor_variables.replace('[',"").replace(']','').replace('\'','').replace(' ','').strip().split(',')
    predictor_vars += ['HomeTeam','VisitTeam']
    
    #print(f"predictor_vars***************{predictor_vars}****************")
    
    # Loading saved ML model
    saved_user_model = open(path_to_model, 'rb')
    user_model = pickle.load(saved_user_model)

    # Loading CSV file
    df = pd.read_csv(sport_csv_path)
    df_future = df.copy()
    # print(f"df: ***************{df}****************")
    
    df_future = df_future.filter(predictor_vars)
    # print(f"df_future:***************{df_future}****************")
    
    df_future['time'] = pd.to_datetime(df['Date'])
    
    # Selecting future games 
    if settings.DEBUG:
        df_future = df_future[df_future['time'] >= today - timedelta(120)]
    else:
        df_future = df_future[df_future['time'] >= today]

    # Evaluating the index of the games inside the result arrays
    future_games_raw_array = np.array(df_future)
    
    index_user_games = []
    for i in range(len(future_games_raw_array)):
        for game in games:
            if game.split('vs.')[0].strip() in future_games_raw_array[i]:
                index_user_games.append(i)

    # Cleaning the DF
    df_future_clean = df_future.drop(['time','HomeTeam','VisitTeam'], 1)
    string_collist = list(df_future_clean.select_dtypes(include=object).columns.values)
    df_future_clean = df_future_clean.drop(string_collist, axis=1)

    # df_future_clean = df_future_clean.apply(lambda x: x.fillna(x.mean()),axis=0)
    df_future_clean.fillna(value=0, inplace=True)

    future_games_clean_array = np.array(df_future_clean)
    # print(f"df_future_clean***************{df_future_clean}****************")
    
    future_games_clean_array = preprocessing.scale(future_games_clean_array)
    
    # print(f"future_games_clean_array***************{future_games_clean_array}****************")
    all_games_predictions = user_model.predict(future_games_clean_array)

    predicted_games = []
    
    for g in index_user_games:
        predicted_games.append(int(all_games_predictions[g]))

    print(f'*********************************')
    print(f'*********  SUMMARY  *************')
    print(f'*********************************')
    print(f'>>  TARGET: {target}')
    print(f'>>  INDEX GAMES: {index_user_games}')
    print(f'>>  PATH: {path_to_model}')
    print(f'>>  CSV PATH: {sport_csv_path}')
    print(f">>  GAMES: {games}")
    print(f">>  USER PREDICTED GAMES: {predicted_games}")

    return dict(zip(games, predicted_games))

@login_required
def get_model(request):
    context = {}

    subscription_id = Profile.objects.get(user=request.user).subscription_id
    if subscription_id == settings.VIP_SUBSCRIPTION_ID or subscription_id == settings.VIP_ANNUAL_SUBSCRIPTION_ID or subscription_id == settings.BASIC_WEEKLY_SUBSCRIPTION_ID:
        plan = 'OK'
    else:
        plan = 'FREE'
    
    context = {
        'plan': plan
    }

    return render(request, 'models/build-your-own-model-step-seven.html', context)


'''
Bet Calculator
##############
'''

def valid_pct(value):
    if value.endswith("%"):
       return float(value[:-1])/100
    else:
        messages.error('Entered number is not a valid percentage.')
        return False

def bet_calculators(request):
    context = {}
    if request.method == 'POST':
        calculator = request.POST.get('calculator')
        player_type = 1 if request.POST.get('player_type') == 'Favorite' else 0
        bankroll = float(request.POST.get('bankroll'))
        moneylines = int(request.POST.get('moneylines'))
        confidence = float(request.POST.get('confidence'))

        decimal_odds = moneylines/100 + 1 if player_type == 0 else 100/moneylines + 1
        B = decimal_odds - 1
        P = confidence
        Q = 1 - P

        K = (B*P - Q)/B

        if calculator == "Kelly Criterion":
            bet_size = int(K * bankroll)
        elif calculator  == "Half Kelly Criterion":
            bet_size = int((K * bankroll) / 2)
        elif calculator == "Quarter Kelly Criterion":
            bet_size = int((K * bankroll) / 2)

        context = {
            'calculator':calculator,
            'player_type':request.POST.get('player_type'),
            'bankroll':bankroll,
            'moneylines': moneylines,
            'confidence':confidence,
            'kelly': str(int(K*100))+'%',
            'bet_size':bet_size
        }

        print(context)
        return render(request, 'models/bet-calculators.html', context)
    else:
        return render(request, 'models/bet-calculators.html')

## Charts
# def chart_data(request, *args, **kwargs):
#     data = {
#         'sales': 100,
#         'customers': 10,
#     }
#     return JsonResponse(data) # HTTP Response
@login_required
def model_report(request):
    import numpy as np
    def make_rf_feat_plot(forest):
        importances = forest.feature_importances_
        std = np.std([tree.feature_importances_ for tree in forest.estimators_],
             axis=0)
        indices = np.argsort(importances)[::-1]

        # Print the feature ranking

        # Plot the impurity-based feature importances of the forest
        plt.figure()
        plt.title("Feature importances")
        plt.bar(range(X.shape[1]), importances[indices], color="r", yerr=std[indices], align="center")
        plt.xticks(range(X.shape[1]), indices)
        plt.xlim([-1, X.shape[1]])
        
        return plt

    context = {}

    model_id = request.session['model_id']
    model = UserModels.objects.get(id=model_id)
    context['model'] = model
    context['model_type'] = model.model_type
    
    if model.model_type == 'classifier':
        # Loading saved ML model
        path_to_model = model.model_saved_path
        saved_user_model = open(path_to_model, 'rb')
        classifier = pickle.load(saved_user_model)

        classification_report = model.model_classification_report
        keys = list(classification_report)
        context['k1'] = keys[0] 
        context['k2'] = keys[1]
        context['accuracy'] = keys[2]
        context['macro_avg'] = keys[3]
        context['weighted_avg'] = keys[4]

        context['val1'] = classification_report[keys[0]]
        context['val2'] = classification_report[keys[1]]
        context['val_accuracy'] = classification_report[keys[2]]
        context['val_macro_avg'] = classification_report[keys[3]]
        context['val_weighted_avg'] = classification_report[keys[4]]

        # Plotting
        if model.model_algorithm == 'DecisionTreeClassifier':
            context['decision_tree'] = True
            #decision_tree = tree.plot_tree(classifier)
            #decision_tree = tree.export_text(classifier)
            decision_tree = 'hiiiiiii'
            context['plot_tree'] = decision_tree
       
        if model.model_algorithm == 'RandomForestClassifier':
            context['random_forest_class'] = True
            rf_featimp = make_rf_feat_plot(classifier) #get feature imp from pickled class
            context['plot_rf_featimp'] = rf_featimp

        else:
            pass

        np.set_printoptions(precision=2)
        y_pred = model.model_graph_data['y_pred']
        y_test = model.model_graph_data['y_test']
        target_name = [keys[0],keys[1]]
        cm = confusion_matrix(y_test, y_pred).tolist()
        request.session['y_pred'] = y_pred
        request.session['y_test'] = y_test
        request.session['cm'] = cm

        fig = go.Figure(data=go.Heatmap(
                    z=cm,
                    x=[target_name[0], target_name[1]],
                    y=[target_name[1], target_name[0]],
                    hoverongaps = False))

        # fig = px.imshow(cm)
        div = opy.plot(fig, auto_open=False, output_type='div')
        plot_div = div

        context['plot_div'] = plot_div
    
    else:
        pass

    model_predictor_variables = model.model_predictor_variables.replace('[','').replace(']','').replace('\'','').replace(' ','').split(',')
    context['model_predictor_variables'] = model_predictor_variables

    return render(request,'models/model_report.html', context)

# Not Used
class Graph(TemplateView): 

    def get_context_data(self,*args, **kwargs):
        context = super(Graph, self).get_context_data(**kwargs)

        # x = [-2,0,4,6,7]
        # y = [q**2-q+3 for q in x]
        cm = self.request.session.get('cm')
        x = cm[0]
        y = cm[1]

        trace1 = Heatmap(x=x, y=y)

        data=Data([trace1])
        layout=Layout(title="My Daten", xaxis={'title':'x1'}, yaxis={'title':'x2'})
        figure=Figure(data=data,layout=layout)
        div = opy.plot(figure, auto_open=False, output_type='div')

        context['graph'] = div

        return context

# Using Chart.js: https://www.chartjs.org/docs/latest/
# and Django REST framework: https://www.django-rest-framework.org/api-guide/views/
class ChartData(APIView):
    authentication_classes = []
    permission_classes = []

    def get(self, request, format=None):
        users_count = User.objects.all().count()
        labels = ['Users', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange']
        chart_data =[users_count, 22,2,32,11, 16]
        chart_type = 'bar'
        data = {
            'labels': labels,
            'chart_type': chart_type,
            'chart_data': chart_data,
            'title': 'Predictors'
        }
        return Response(data)
