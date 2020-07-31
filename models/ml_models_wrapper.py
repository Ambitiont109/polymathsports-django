# Import dependencies


from .ml_models import *

# Import dataframe from CSV
# Import only the games past games

''' 
Pre-process the dataframe:
--------------------------
1) Copy main DF for each sub-DF, e.g. for the Total points
2) Split the data to training-test and leave data for predictions
3) Remove NaNs
4) Scale the data
5) Train model
6) Run predictions
7) Plot
'''

def ml_wrapper(action,model_name, sports_path, sport, target, predictors, manipulations, algorithm):

    # csv_path = sports_path + sport.lower()
    if action == 'build':
        
        csv_file = sports_path + f'/{sport}_Final.csv'

        if target == 'TotalScore' or target == 'HomeScore' or target == 'AwayScore':
            graph_data, score, model_path = run_regression(
                model_name=model_name,
                target_variable=target,
                sports_path=sports_path,
                sport=sport,
                csv_path=csv_file,
                predictors=predictors,
                manipulations=manipulations,
                algorithm=algorithm
            )
            model_type = 'regressor'
        else:
            csv_file = sports_path + f'/{sport}_Final.csv'
        
            graph_data, score, model_path = run_classification(
                model_name=model_name,
                target_variable=target,
                sports_path=sports_path,
                sport=sport,
                csv_path=csv_file,
                predictors=predictors,
                manipulations=manipulations,
                algorithm=algorithm
            )
            model_type = 'classifier'

        return graph_data, score, model_path, model_type
    
    