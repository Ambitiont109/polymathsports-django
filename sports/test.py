
from datetime import datetime
# from apscheduler.schedulers.background import BackgroundScheduler
from sqlalchemy import create_engine
import pandas as pd
import os

SPORTS_PATH = os.environ.get('SPORTS_PATH')
HOME = os.environ.get('HOME')

def import_nfl():
    engine = create_engine('postgresql://polymath:codebrew-01c0b8f1de7@localhost:5432/polymath')
    df = pd.read_csv(f'{SPORTS_PATH}/nfl/NFL_Final.csv')
    df.columns = map(str.lower, df.columns)
    df_mod = df.round(decimals=2)
    # df['results'] = df.apply(lambda row: '1' if row.homepts > row.visitpts else '2', axis=1)
    # df.to_sql('stat_staging', engine, if_exists='append', index=False)
    df_mod.to_sql('nfl_data', engine, if_exists='replace',chunksize=100, index=False)

def import_nba():
    engine = create_engine('postgresql://polymath:codebrew-01c0b8f1de7@localhost:5432/polymath')
    df = pd.read_csv(f'{SPORTS_PATH}/nba/NBA_Final.csv')
    df.columns = map(str.lower, df.columns)
    df_mod = df.round(decimals=2)
    df_mod.to_sql('nba_data', engine, if_exists='replace',chunksize=100, index=False)

def import_ncaaf():
    engine = create_engine('postgresql://polymath:codebrew-01c0b8f1de7@localhost:5432/polymath')
    df = pd.read_csv(f'{SPORTS_PATH}/ncaaf/NCAAF_Final.csv')
    df.columns = map(str.lower, df.columns)
    df_mod = df.round(decimals=2)
    df_mod.to_sql('ncaaf_data', engine, if_exists='replace',chunksize=100, index=False)

def import_ncaab():
    engine = create_engine('postgresql://polymath:codebrew-01c0b8f1de7@localhost:5432/polymath')
    df = pd.read_csv(f'{SPORTS_PATH}/ncaab/NCAAB_Final.csv')
    df.columns = map(str.lower, df.columns)
    df_mod = df.round(decimals=2)
    df_mod.to_sql('ncaab_data', engine, if_exists='replace',chunksize=100, index=False)


def main():
    errors = []

    try:
        import_nfl()
    except Exception as e:
        errors.append(e)

    # try:
    #     import_nba()
    # except Exception as e:
    #     errors.append(e)
    
    # try:
    #     import_ncaaf()
    # except Exception as e:
    #     errors.append(e)
        
    # try:
    #     import_ncaab()
    # except Exception as e:
    #     errors.append(e)

    return errors

if __name__ == '__main__':
    
    db_load_errors = main()
    
    if len(db_load_errors) == 0:
        os.system(f'echo "Last sports CSV files uploaded on {datetime.today()}." >> {HOME}/daily_CSV_run.log')
    else:
        for e in db_load_errors:    
            os.system(f'echo "Failed loading: {e}  Date: {datetime.today()}." >> {HOME}/daily_CSV_run.log')
