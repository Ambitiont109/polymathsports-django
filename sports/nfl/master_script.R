## Update TeamRankings Stats.
print('starting nfl master')
message('Updating NFL TeamRankings stats...')
source('teamrankings_nfl.R', local = TRUE)
print('finished TR nfl')

## Update Weather History
message('Updating Weather History...')
source('weather.R', local = TRUE)
print('finished weather')

## Update Weather Forecast
message('Updating Weather Forecast Data...')
source('openweathermap.R', local = TRUE)
print('finished openweather')

## Join Data.
message('Joining data and updating predicting data base...')
source('data_joins_nfl_AY.R', local = TRUE)
print('finished joins')
