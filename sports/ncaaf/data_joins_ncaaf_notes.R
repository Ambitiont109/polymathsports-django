time_start <- Sys.time()

library(tidyverse)
library(pbapply)

df_schedule <- read.csv('NCAAF_Schedule.csv', stringsAsFactors = FALSE) %>%
  mutate(Date = as.Date(Date, format = '%d-%m-%y', origin = '1970-01-01'),
         Winner = gsub('\\([0-9]+\\)\\s(.+)', '\\1', Winner),
         Loser = gsub('\\([0-9]+\\)\\s(.+)', '\\1', Loser),
         HomeTeam = ifelse(At == "", Winner, Loser),
         VisitTeam = ifelse(At == "@", Winner, Loser),
         HomePts = ifelse(At == "", Pts, Pts.1),
         VisitPts = ifelse(At == "@", Pts, Pts.1)) %>%
  select(-Winner, -Pts, -At, -Loser, -Pts.1, -Notes, -Notes2)

## TeamRankings Data.
df_tr <- read.csv('teamrankings_db.csv', stringsAsFactors = FALSE) %>%
  mutate(Date = as.Date(Date, format = '%Y-%m-%d', origin = '1970-01-01')) %>%
  left_join(read.csv('team_codes.csv', stringsAsFactors = FALSE),
            by = c('Team' = 'TeamRankings')) %>%
  select(-Team) %>% mutate(Team = Schedule) %>% select(-Schedule)

## Join home.
colnames(df_tr) <- paste0('Home_', colnames(df_tr))
df_vf <- df_schedule %>%
  left_join(df_tr, by = c('Date' = 'Home_Date', 'HomeTeam' = 'Home_Team'))

colnames(df_tr) <- gsub('Home_(.+)', '\\1', colnames(df_tr))
colnames(df_tr) <- paste0('Visit_', colnames(df_tr))
df_vf <- df_vf %>%
  left_join(df_tr, by = c('Date' = 'Visit_Date', 'VisitTeam' = 'Visit_Team'))

rm(df_tr)

## Join Time Zones.

## Join home.
df_tz <- read.csv('team_timezones.csv', stringsAsFactors = FALSE)
colnames(df_tz) <- paste0('Home_', colnames(df_tz))
df_vf <- df_vf %>%
  left_join(df_tz, by = c('HomeTeam' = 'Home_Team'))

colnames(df_tz) <- gsub('Home_(.+)', '\\1', colnames(df_tz))
colnames(df_tz) <- paste0('Visit_', colnames(df_tz))
df_vf <- df_vf %>%
  left_join(df_tz, by = c('VisitTeam' = 'Visit_Team'))

## ADD DAYS OFF.
calculate_days_off <- function(df, team){
  df_doff <- df %>% select(Date, HomeTeam, VisitTeam) %>%
    filter(HomeTeam == team | VisitTeam == team) %>% arrange(Date) %>%
    mutate(Days_Off = Date - lag(Date), Team = team) %>%
    select(Date, Team, Days_Off)
  return(df_doff)
}
team_un <- c(df_vf$HomeTeam, df_vf$VisitTeam) %>% unique() %>% sort()
df_days_off <- team_un %>% 
  pblapply(calculate_days_off, df = df_vf) %>%
  bind_rows()

colnames(df_days_off) <- paste0('Home_', colnames(df_days_off))
df_vf <- df_vf %>%
  left_join(df_days_off, by = c('Date' = 'Home_Date',
                                'HomeTeam' = 'Home_Team'))
colnames(df_days_off) <- gsub('Home_', 'Visit_', colnames(df_days_off))
df_vf <- df_vf %>%
  left_join(df_days_off, by = c('Date' = 'Visit_Date',
                                'VisitTeam' = 'Visit_Team'))

## ADD DAYS ON ROAD.
calculate_days_on_road <- function(df, team){
  df_aux <- df %>% select(Date, HomeTeam, VisitTeam) %>%
    filter(HomeTeam == team | VisitTeam == team) %>%
    mutate(TeamTag = ifelse(VisitTeam == team,
                            'A', 'H'),
           Team = team) %>%
    select(Date, Team, TeamTag) %>%
    arrange(Date)
  for(i in 1:nrow(df_aux)){
    date_end <- df_aux$Date[i]
    df_aux2 <- df_aux %>% filter(Date < date_end & TeamTag == 'H')
    date_start <- ifelse(nrow(df_aux2) == 0,
                         min(df_aux$Date),
                         max(df_aux2$Date)) %>%
      as.Date(format = '%Y-%m-%d', origin = '1970-01-01')
    df_aux$Days_on_Road[i] <- ifelse(df_aux$TeamTag[i] == 'H', 0,
                                     df_aux %>% 
                                       filter(Date > date_start, Date <= date_end) %>%
                                       .$TeamTag %>% 
                                       (function(x){x == 'A'}) %>% sum())
  }
  return(df_aux %>% select(Date, Team, Days_on_Road))
}

df_days_on_road <- team_un %>% 
  pblapply(calculate_days_on_road, df = df_vf) %>%
  bind_rows()

colnames(df_days_on_road) <- paste0('Home_', colnames(df_days_on_road))
df_vf <- df_vf %>%
  left_join(df_days_on_road, by = c('Date' = 'Home_Date',
                                    'HomeTeam' = 'Home_Team'))

colnames(df_days_on_road) <- gsub('Home_', 'Visit_', colnames(df_days_on_road))
df_vf <- df_vf %>%
  left_join(df_days_on_road, by = c('Date' = 'Visit_Date',
                                    'VisitTeam' = 'Visit_Team'))

write.csv(df_vf, file = 'schedule_vf.csv', row.names = FALSE)

time_end <- Sys.time()
print(time_end-time_start)