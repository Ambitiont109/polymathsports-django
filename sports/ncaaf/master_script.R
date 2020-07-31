## Update TeamRankigns.
print('starting ncaaf script')
message('Updating Teamrankings data...')
source('teamrankings_ncaaf.R', local = TRUE)
print('finished TR script')

## Update Weather History
message('Updating Weather History...')
source('weather.R', local = TRUE)
print('finished weather script')

## Update Weather Forecast
message('Updating Weather Forecast Data...')
source('openweathermap.R', local = TRUE)
print('finished openweathermap')

## Run data joins and update predict database.
message('Running data joins and updating predicting database...')
source('data_joins_ncaaf_AY_polymath.R', local = TRUE)
print('finished joins')
