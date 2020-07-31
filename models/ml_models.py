from __future__ import absolute_import, unicode_literals

import pandas as pd
import numpy as np 
import datetime
import pickle
import math
import os,sys
import pickle
import time
# from matplotlib import pyplot as plt

from sklearn.model_selection import train_test_split

# Regression Models
from sklearn import preprocessing, svm
from sklearn.linear_model import LinearRegression, Ridge, SGDRegressor, Lasso  
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.neural_network import MLPRegressor

# Classification Models
from sklearn.neighbors import KNeighborsClassifier
#from xgboost import XGBClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF

from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.linear_model import LogisticRegression
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score, r2_score, classification_report, plot_confusion_matrix

# Implement predictors manipulations
def predictors_manipulations(df, manipulations):

    for manip in manipulations:
        if manip.manipulation == 'Multiply':
            print(f'Multiplying predictor type {manip.predictors} with {float(manip.manipulator_value)}')
            df[f'{str(manip.predictors)}'] = df[f'{manip.predictors}']*float(manip.manipulator_value)
        elif manip.manipulation == 'Power of':
            print(f'Powering predictor {manip.predictors}')
            df[f'{str(manip.predictors)}'] = df[f'{manip.predictors}'].pow(float(manip.manipulator_value))
        elif manip.manipulation == 'Square Root':
            print(f'Square Root predictor {manip.predictors}')
            df[f'{str(manip.predictors)}'] = df[f'{manip.predictors}'].pow(0.5)
        elif manip.manipulation == 'Cube':
            print(f'Cube predictor {manip.predictors}')
            df[f'{str(manip.predictors)}'] = df[f'{manip.predictors}'].pow(3)
        else:
            print('No Manipulation Done!')
    
    return df

def run_regression(model_name, target_variable, csv_path,sports_path, sport, predictors, manipulations, algorithm):
    
    print(f'*************** \nRegression Run \n****************')
    graph_data = {}
        
    df = pd.read_csv(csv_path)
    reg_df = df.copy()
    reg_df['time'] = pd.to_datetime(reg_df['Date'])
    
    today = datetime.datetime.today()

    # Selecting only the historical data for the training set
    reg_df = reg_df[reg_df['time'] < today]

    if target_variable == 'TotalScore':
        keep_cols = predictors
        reg_df = reg_df.filter(keep_cols)
        reg_df['Total'] = df.fillna(0)['HomePts'] + df.fillna(0)['VisitPts']
        target_score = 'Total'

    elif target_variable == 'HomeScore':
        target_score = 'HomePts'
        keep_cols = predictors + [target_score]
        reg_df = reg_df.filter(keep_cols)

    elif target_variable == 'AwayScore':
        target_score = 'VisitPts'
        keep_cols = predictors + [target_score]
        reg_df = reg_df.filter(keep_cols)

    else:
        return 0, ''

    # Filling the NaNs with column average
    reg_df = reg_df.apply(lambda x: x.fillna(x.mean()),axis=0)

    # Implementing the manipulations from the user
    reg_df = predictors_manipulations(df=reg_df,manipulations=manipulations)
    X = reg_df.drop([target_score], 1)

    string_collist = list(X.select_dtypes(include=object).columns.values)
    X = X.drop(string_collist, axis=1)
#    X = pd.get_dummies(X, drop_first=True)
    X = np.array(X)
    X = preprocessing.scale(X)

    y = np.array(reg_df[target_score])

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)
    
    if algorithm == 'Linear Regression':
        print('LinearRegression')
        reg_run = LinearRegression()
    elif algorithm == 'Ridge Regression':
        print('RidgeRegression')
        reg_run = Ridge()
    elif algorithm == 'Lasso Regression':
        print('LassoRegression')
        reg_run = Lasso(alpha=0.1)
    elif algorithm == 'Random Forest Regression':
        print('RandomForest')
        reg_run = RandomForestRegressor(max_depth=2, random_state=0)
        # col_len = len(X_test.columns)
        # importances = list(zip(reg_run.feature_importances_, X_test.columns))
        # importances.sort(reverse=False)
        # rfr_df = pd.DataFrame(importances, index=[x for (_,x) in importances]).iloc[(col_len-20):col_len, :]
        # graph_data['importances'] = reg_df
    elif algorithm == 'Gradient Boosting Regression':
        print('GradientBoosting')
        reg_run = GradientBoostingRegressor()
    elif algorithm == 'SGD Regressor':
        print('SGDRegressor')
        reg_run = SGDRegressor(max_iter=10000)
    elif algorithm == 'Support Vector Machine Regression':
        print('SVR')
        reg_run = svm.SVR(kernel='linear')
    elif algorithm == 'Neural Network Regression':
        print('nnet')
        reg_run = MLPRegressor(hidden_layer_sizes=(50,100,50), max_iter=50, alpha=0.001,
                     solver='adam', verbose=10,  random_state=21,tol=0.000000001)
    else:
        print('Running default model: Linear Regression')
        reg_run = LinearRegression()

    reg_run.fit(X_train, y_train)

    y_predictions = reg_run.predict(X_test)
    
    score = r2_score(y_test, y_predictions)

    model_file_path = f"{sports_path}/user_models/{model_name}-{sport}-regression-{algorithm.replace(' ','')}-{int(time.time())}.pickle"  # a unique name for the model

    with open(model_file_path, 'wb') as f:
        pickle.dump(reg_run, f)

    # Regression report information
    score = []
    y_pred_train = reg_run.predict(X_train)
    y_pred = reg_run.predict(X_test)
    
    train_score = str(100* round(r2_score(y_train, y_pred_train),3))
    test_score = str(100 * round(r2_score(y_test, y_pred), 3))

    train_mae = str(round(mean_absolute_error(y_train, y_pred_train), 3))
    test_mae = str(round(mean_absolute_error(y_test, y_pred), 3))
    
    # Writing report to DB
    score.append(train_score)
    score.append(test_score)
    score.append(train_mae) 
    score.append(test_mae) 


    return(graph_data, score, model_file_path)



def run_classification(model_name,target_variable,csv_path,sports_path, sport, predictors, manipulations, algorithm):
    
    print(f'*************** \nClassification Run \n****************')
    
    # predict_vars = []
    # for var in manipulations:
    #     predict_vars.append(manipulations.predictors)
    
    df = pd.read_csv(csv_path)
    clf_df = df.copy()
    
    clf_df['time'] = pd.to_datetime(clf_df['Date'])

    today = datetime.datetime.today()
    clf_df = clf_df[clf_df['time'] < today]
    clf_df_filtered = clf_df.filter(predictors)
    clf_df_filtered['results'] = clf_df.apply(lambda row: 1 if row['HomePts'] > row['VisitPts'] else 2, axis=1)

    target_results = 'results'
    clf_df_filtered.dropna(inplace=True)

    clf_df_manipulated = predictors_manipulations(df=clf_df_filtered,manipulations=manipulations)


    # Implementing the manipulations from the user
    X = clf_df_manipulated.drop(['results'], 1)
    
    string_collist = list(X.select_dtypes(include=object).columns.values)
    X = X.drop(string_collist, axis=1)
    #X = pd.get_dummies(X, drop_first=True)
    X = np.array(X)
    X = preprocessing.scale(X)

    y = np.array(clf_df_manipulated['results'])

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

    if algorithm == 'Support Vector Machine Classifier':
        print('SVC')
        clf_run = svm.SVC(kernel="linear", C=0.025)
    elif algorithm == 'K-Neighbors Classifier':
        print('KNeighborsClassifier')
        clf_run = KNeighborsClassifier(n_neighbors=1000)
    elif algorithm == 'Decision Tree Classifier':
        print('DecisionTreeClassifier')
        clf_run = DecisionTreeClassifier()
    elif algorithm == 'Random Forest Classifier':
        print('RandomForestClassifier')
        clf_run = RandomForestClassifier(max_depth=20, random_state=0)
    elif algorithm == 'Ada Boost Classifier':
        print('AdaBoostClassifier')
        clf_run = AdaBoostClassifier(n_estimators=200, random_state=0)
    elif algorithm == 'Logistic Regression':
        print('LogisticRegression')
        clf_run = LogisticRegression(random_state=0, max_iter=100)
    elif algorithm == 'Gradient Boosting Classifier':
        print('Gradient Boosting')
        clf_run = GradientBoostingClassifier()
    elif algorithm == 'Neural Network Classifier':
        print('MLPClassifier (NN Model)')
        clf_run = MLPClassifier(hidden_layer_sizes=(50,100,50), max_iter=50, alpha=0.001,
                     solver='sgd', verbose=10,  random_state=21,tol=0.000000001)
    else:
        print('Default Algorithm: KNeighborsClassifier')
        clf_run = KNeighborsClassifier(n_neighbors=1000)
    
    clf_run.fit(X_train, y_train)

    score = clf_run.score(X_test, y_test)

    model_file_path = f"{sports_path}/user_models/{model_name}-{sport}-classification-{algorithm.replace(' ','')}-{int(time.time())}.pickle"  # a unique name for the model

    with open(model_file_path, 'wb') as f:
        pickle.dump(clf_run, f)

    # Classificaiton report information
    score = []
    y_pred_train = clf_run.predict(X_train)
    y_pred = clf_run.predict(X_test)
    
    train_score = str(100 * round(accuracy_score(y_train, y_pred_train), 3))
    test_score = str(100 * round(accuracy_score(y_test, y_pred), 3))

    if target_variable == 'HomeWin':
        target_names = ['Home Loss', 'Home Win']

    if target_variable == 'AwayWin':
        target_names = ['Away Loss', 'Away Win']

    # Writing report to DB
    score.append(train_score)
    score.append(test_score)
    score.append(classification_report(y_test, y_pred, target_names=target_names, output_dict=True)) 

    graph_data = {}
    graph_data['y_pred'] = y_pred.tolist()
    graph_data['y_test'] = y_test.tolist()

    return(graph_data, score, model_file_path)
