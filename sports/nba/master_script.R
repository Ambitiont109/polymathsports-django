print('starting nba master script')

source("config.R")
print('finished nba config script')

source("scraper_for_schedule.R")
print('finished nba scraper script')

source("scraper_for_game_data.R")
print('finished nba scraper game data script')

source("master_script_injuries_salaries.R")
print('finished nba injuries script')

source("data_joins_ay.R")
#source("data_joins_ay_NBA_new.R")

print('finished nba data joins script')

