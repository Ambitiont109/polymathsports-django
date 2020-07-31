time_start <- Sys.time()
date_start <- Sys.Date()

library(tidyverse)
library(lubridate)
#library(janitor)
#library(tidylog)
library(assertr)
library(pbapply)
source("functions.R")


df_schedule <- read.csv("NCAAF_Schedule.csv", stringsAsFactors = FALSE,
                        fileEncoding = "UTF-8-BOM") %>%
  as_tibble() %>%
  mutate(Date = as.Date(Date, format = "%m/%d/%y", origin = "1970-01-01"),
         Winner = gsub("\\([0-9]+\\)\\s(.+)", "\\1", Winner),
         Loser = gsub("\\([0-9]+\\)\\s(.+)", "\\1", Loser),
         HomeTeam = ifelse(At == "", Winner, Loser),
         VisitTeam = ifelse(At == "@", Winner, Loser),
         HomePts = ifelse(At == "", Pts, Pts.1),
         VisitPts = ifelse(At == "@", Pts, Pts.1)) %>%
  select(-Winner, -Pts, -At, -Loser, -Pts.1) %>%
  assert(not_na, Date)

# Add season to schedule
df_schedule %>%
  count(month(Date))

df_schedule <- df_schedule %>%
  mutate(season_year = if_else(month(Date) >= 8, year(Date), year(Date) - 1),
         season = paste0(season_year, "-", season_year + 1))

# There seem to be some duplicated records
#df_schedule %>%
#  select(-Rk) %>%
#  janitor::get_dupes()

df_schedule <- df_schedule %>%
  #tidylog::filter(!duplicated(select(., -Rk))) %>%
  filter(!duplicated(select(., -Rk)))

# One more duplicate
df_schedule %>%
  filter(Date == "2011-11-12",
         HomeTeam %in% c("Maryland", "Notre Dame"))
# I looked this up and Maryland was the Home Team so remove the other game

df_schedule <- df_schedule %>%
  #tidylog::filter(!(Date == "2011-11-12" & HomeTeam == "Notre Dame")) %>%
  filter(!(Date == "2011-11-12" & HomeTeam == "Notre Dame"))

# For testing
# df_schedule <- df_schedule %>%
#   filter(season_year >= 2017)



# Transform home and visitor team stats into long form --------------------

z_home <- df_schedule %>%
  select(Date, season,
         team = HomeTeam,
         team_opponent = VisitTeam,
         score = HomePts,
         score_opponent = VisitPts)

z_visitor <- df_schedule %>%
  select(Date, season,
         team = VisitTeam,
         team_opponent = HomeTeam,
         score = VisitPts,
         score_opponent = HomePts) %>%
  verify(nrow(.) == nrow(z_home))

schedule_long <- bind_rows(z_home, z_visitor) %>%
  verify(nrow(.) == nrow(df_schedule) * 2L) %>%
  rename(game_date = Date) %>%
  filter(!is.na(score)) %>%
  verify(nrow(.) == nrow(distinct(., game_date, season, team, team_opponent)))
# The verify() statement above checks that matches are unique


# Add in variables required to calculate weighted stats
# Add running average percentage
schedule_long <- schedule_long %>%
  mutate(score_total = score + score_opponent,
         score_perc = score / score_total) %>%
  arrange(team, game_date) %>%
  group_by(season, team) %>%
  mutate(running_avg_perc = cummean(score_perc),
         running_avg_score = cummean(score),
         running_avg_score_opponent = cummean(score_opponent)) %>%
  ungroup()

# Add expected share
schedule_long <- schedule_long %>%
  group_by(game_date, season, team, team_opponent) %>%
  mutate(exp_share = 1 - most_recent_value(schedule_long, game_date, team_opponent, running_avg_perc, season),
         avg_pts = most_recent_value(schedule_long, game_date, team, running_avg_score, season),
         avg_pts_opponent = most_recent_value(schedule_long, game_date, team_opponent, running_avg_score, season),
         avg_pts_allowed = most_recent_value(schedule_long, game_date, team, running_avg_score_opponent, season),
         avg_pts_allowed_opponent = most_recent_value(schedule_long, game_date, team_opponent, running_avg_score_opponent, season)) %>%
  ungroup() %>%
  mutate(diff_exp_share = score_perc - exp_share,
         diff_off = score - avg_pts_allowed_opponent,
         diff_def = avg_pts_opponent - score_opponent)



# Add Weighted Stats to Schedule ------------------------------------------

df_schedule <- df_schedule %>%
  group_by(Date, season, HomeTeam, VisitTeam) %>%
  mutate(
    last3_weighted_home = last_n_weighted(schedule_long, Date, HomeTeam, 3, diff_exp_share, season),
    last5_weighted_home = last_n_weighted(schedule_long, Date, HomeTeam, 5, diff_exp_share, season),
    last7_weighted_home = last_n_weighted(schedule_long, Date, HomeTeam, 7, diff_exp_share, season),
    last3_weighted_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 3, diff_exp_share, season),
    last5_weighted_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 5, diff_exp_share, season),
    last7_weighted_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 7, diff_exp_share, season),
    last3_off_home = last_n_weighted(schedule_long, Date, HomeTeam, 3, diff_off, season),
    last5_off_home = last_n_weighted(schedule_long, Date, HomeTeam, 5, diff_off, season),
    last7_off_home = last_n_weighted(schedule_long, Date, HomeTeam, 7, diff_off, season),
    last3_off_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 3, diff_off, season),
    last5_off_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 5, diff_off, season),
    last7_off_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 7, diff_off, season),
    last3_def_home = last_n_weighted(schedule_long, Date, HomeTeam, 3, diff_def, season),
    last5_def_home = last_n_weighted(schedule_long, Date, HomeTeam, 5, diff_def, season),
    last7_def_home = last_n_weighted(schedule_long, Date, HomeTeam, 7, diff_def, season),
    last3_def_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 3, diff_def, season),
    last5_def_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 5, diff_def, season),
    last7_def_visitor = last_n_weighted(schedule_long, Date, VisitTeam, 7, diff_def, season)
  ) %>%
  ungroup() %>%
  arrange(Date)



# TeamRankings Data -------------------------------------------------------

if (any(is.na(df_schedule$Date))) {
  stop("schedule date format is inconsistent. Check date column in NCAAF_Schedule.csv, it must be '%m/%d/%y'")
} else {
  df_tr <- read.csv("teamrankings_db.csv", stringsAsFactors = FALSE,
                    fileEncoding = "UTF-8-BOM") %>%
    as_tibble() %>%
    mutate(Date = as.Date(Date, format = "%Y-%m-%d", origin = "1970-01-01")) %>%
    left_join(read.csv("team_codes.csv", stringsAsFactors = FALSE,
                       fileEncoding = "UTF-8-BOM"),
              by = c("Team" = "TeamRankings")) %>%
    select(-Team) %>%
    mutate(Team = Schedule) %>%
    select(-Schedule)

  # add teamrankings data for next match
  get_teams_next_match_date <- function(df_schedule, current_date) {
    df <- df_schedule %>%
      select(Date, HomeTeam, VisitTeam) %>%
      gather("key", "Team", -Date) %>%
      select(-key) %>%
      filter(Date > current_date) %>%
      group_by(Team) %>%
      summarise(Date = min(Date))

    return(df)
  }

  latest_teamrankings_date <- max(df_tr$Date)
  if (latest_teamrankings_date != date_start) {
    warning(paste("Latest Teamrankings Available is on", latest_teamrankings_date), immediate. = TRUE)
  }

  next_match_dates <- get_teams_next_match_date(df_schedule, date_start)

  df_tr_most_recent <- df_tr %>%
    filter(Date == latest_teamrankings_date) %>%
    select(-Date) %>%
    inner_join(next_match_dates, by = "Team")

  df_tr <- df_tr %>%
    dplyr::union(df_tr_most_recent)

  colnames(df_tr) <- paste0("Home_", colnames(df_tr))
  df_vf <- df_schedule %>%
    left_join(df_tr, by = c("Date" = "Home_Date", "HomeTeam" = "Home_Team"))

  colnames(df_tr) <- gsub("Home_(.+)", "\\1", colnames(df_tr))
  colnames(df_tr) <- paste0("Visit_", colnames(df_tr))
  df_vf <- df_vf %>%
    left_join(df_tr, by = c("Date" = "Visit_Date", "VisitTeam" = "Visit_Team"))

  rm(df_tr)



  # Join Time Zones ---------------------------------------------------------

  df_tz <- read.csv("team_timezones.csv", stringsAsFactors = FALSE,
                    fileEncoding = "UTF-8-BOM", colClasses = c("ZIPCODE" = "character") ) %>%
    as_tibble() 

  colnames(df_tz) <- paste0("Home_", colnames(df_tz))
  df_vf <- df_vf %>%
    left_join(df_tz, by = c("HomeTeam" = "Home_Team"))

  colnames(df_tz) <- gsub("Home_(.+)", "\\1", colnames(df_tz))
  colnames(df_tz) <- paste0("Visit_", colnames(df_tz))
  df_vf <- df_vf %>%
    left_join(df_tz, by = c("VisitTeam" = "Visit_Team"))



  # Add Days Off ------------------------------------------------------------

  calculate_days_off <- function(df, team) {
    df_doff <- df %>%
      select(Date, HomeTeam, VisitTeam) %>%
      filter(HomeTeam == team | VisitTeam == team) %>%
      arrange(Date) %>%
      mutate(Days_Off = Date - lag(Date),
             Team = team) %>%
      select(Date, Team, Days_Off)

    return(df_doff)
  }

  team_un <- c(df_vf$HomeTeam, df_vf$VisitTeam) %>%
    unique() %>%
    sort()

  df_days_off <- team_un %>%
    pblapply(calculate_days_off, df = df_vf) %>%
    bind_rows() %>%
    drop_na() %>%
    distinct(Date, Team, .keep_all = TRUE)

  colnames(df_days_off) <- paste0("Home_", colnames(df_days_off))

  df_vf <- df_vf %>%
    left_join(df_days_off,
              by = c("Date" = "Home_Date", "HomeTeam" = "Home_Team"))

  colnames(df_days_off) <- gsub("Home_", "Visit_", colnames(df_days_off))
  df_vf <- df_vf %>%
    left_join(df_days_off,
              by = c("Date" = "Visit_Date", "VisitTeam" = "Visit_Team"))



  # Add Days on Road --------------------------------------------------------

  calculate_days_on_road <- function(df, team) {
    df_aux <- df %>%
      select(Date, HomeTeam, VisitTeam) %>%
      filter(HomeTeam == team | VisitTeam == team) %>%
      mutate(TeamTag = ifelse(VisitTeam == team, "A", "H"),
             Team = team) %>%
      select(Date, Team, TeamTag) %>%
      arrange(Date)

    for (i in 1:nrow(df_aux)) {
      date_end <- df_aux$Date[i]
      df_aux2 <- df_aux %>% filter(Date < date_end & TeamTag == "H")
      date_start <- ifelse(nrow(df_aux2) == 0,
                           min(df_aux$Date),
                           max(df_aux2$Date)) %>%
        as.Date(format = "%Y-%m-%d", origin = "1970-01-01")

      df_aux$Days_on_Road[i] <- ifelse(df_aux$TeamTag[i] == "H", 0,
                                       df_aux %>%
                                         filter(Date > date_start, Date <= date_end) %>%
                                         .$TeamTag %>%
                                         (function(x) {x == "A"}) %>% sum())
    }
    return(df_aux %>% select(Date, Team, Days_on_Road))
  }

  df_days_on_road <- team_un %>%
    pblapply(calculate_days_on_road, df = df_vf) %>%
    bind_rows() %>%
    drop_na() %>%
    distinct(Date, Team, .keep_all = TRUE)

  colnames(df_days_on_road) <- paste0("Home_", colnames(df_days_on_road))
  df_vf <- df_vf %>%
    left_join(df_days_on_road,
              by = c("Date" = "Home_Date", "HomeTeam" = "Home_Team"))

  colnames(df_days_on_road) <- gsub("Home_", "Visit_", colnames(df_days_on_road))
  df_vf <- df_vf %>%
    left_join(df_days_on_road,
              by = c("Date" = "Visit_Date", "VisitTeam" = "Visit_Team"))


  # Join Weather Data -------------------------------------------------------

  df_weather_sources_dict <- read.csv("weather_sources_dict.csv",
                                      stringsAsFactors = FALSE) %>%
    as_tibble()

  KNOT_TO_MILES_PER_HOUR <- 1.15078 # for wind speed
  INCH_TO_MILLIMETER <- 25.4 # for precipitation in inches to rain_3h in mm

  df_weather_history <- read.csv("weather_db.csv", stringsAsFactors = FALSE,
                                 colClasses = c("zip" = "character"),
                                 fileEncoding = "UTF-8-BOM") %>%
    as_tibble() %>%
    filter(name != "observations") %>%
    mutate(value = as.numeric(value)) %>%
    spread(name, value) %>%
    select_if(~ sum(!is.na(.)) > 0) %>%
    select(date, zip, as.character(df_weather_sources_dict$farmersalmanac)) %>%
    mutate(wind_speed = wind_speed * KNOT_TO_MILES_PER_HOUR) %>%
    mutate(precipitation_amount = precipitation_amount * INCH_TO_MILLIMETER) %>%
    mutate(weather_data = "history")

  df_weather_forecast <- read.csv("weather_forecast_openweathermap.csv",
                                  stringsAsFactors = FALSE,
                                  colClasses = c("zip" = "character"),
                                  fileEncoding = "UTF-8-BOM") %>%
    as_tibble() %>%
    filter(as.POSIXlt(dt_txt, "%Y-%m-%d %H:%M:%S", tz = "")$hour == 15) %>%
    mutate(dt_txt = as.character(as.Date(dt_txt, format = "%Y-%m-%d %H:%M:%S"))) %>%
    select(dt_txt, zip, as.character(df_weather_sources_dict$openweathermap)) %>%
    rename_at(vars(df_weather_sources_dict$openweathermap),
              ~df_weather_sources_dict$farmersalmanac) %>%
    mutate(weather_data = "forecast") %>% 
    anti_join(df_weather_history, by = c("date","zip"))
  
  df_weather_master <- rbind(df_weather_history, df_weather_forecast)

  # join master
  df_vf <- df_vf %>%
    mutate(Date = as.character(Date),
           Home_ZIPCODE = as.character(Home_ZIPCODE),
           Home_ZIPCODE = ifelse(Home_ZIPCODE == "7073", "07073", Home_ZIPCODE),
           Home_ZIPCODE = ifelse(Home_ZIPCODE == "2035", "02035", Home_ZIPCODE)) %>%
    left_join(df_weather_master, by = c("Date" = "date", "Home_ZIPCODE" = "zip"))

  # Convert Percentages -----------------------------------------------------

  df_vf$Home_rushing_play_pct_PreviuosSeason <- as.numeric(sub("%", "",df_vf$Home_rushing_play_pct_PreviuosSeason,fixed=TRUE))/100
  df_vf$Home_rushing_play_pct_CurrentSeason <- as.numeric(sub("%", "",df_vf$Home_rushing_play_pct_CurrentSeason,fixed=TRUE))/100
  df_vf$Home_rushing_play_pct_Last3 <- as.numeric(sub("%", "",df_vf$Home_rushing_play_pct_Last3,fixed=TRUE))/100
  df_vf$Home_rushing_play_pct_Last1 <- as.numeric(sub("%", "",df_vf$Home_rushing_play_pct_Last1,fixed=TRUE))/100
  df_vf$Home_rushing_play_pct_Home <- as.numeric(sub("%", "",df_vf$Home_rushing_play_pct_Home,fixed=TRUE))/100
  df_vf$Home_rushing_play_pct_Away <- as.numeric(sub("%", "",df_vf$Home_rushing_play_pct_Away,fixed=TRUE))/100
  df_vf$Home_sack_pct_PreviuosSeason <- as.numeric(sub("%", "",df_vf$Home_sack_pct_PreviuosSeason,fixed=TRUE))/100
  df_vf$Home_sack_pct_CurrentSeason <- as.numeric(sub("%", "",df_vf$Home_sack_pct_CurrentSeason,fixed=TRUE))/100
  df_vf$Home_sack_pct_Last3 <- as.numeric(sub("%", "",df_vf$Home_sack_pct_Last3,fixed=TRUE))/100
  df_vf$Home_sack_pct_Last1 <- as.numeric(sub("%", "",df_vf$Home_sack_pct_Last1,fixed=TRUE))/100
  df_vf$Home_sack_pct_Home <- as.numeric(sub("%", "",df_vf$Home_sack_pct_Home,fixed=TRUE))/100
  df_vf$Home_sack_pct_Away <- as.numeric(sub("%", "",df_vf$Home_sack_pct_Away,fixed=TRUE))/100
  df_vf$Visit_rushing_play_pct_PreviuosSeason <- as.numeric(sub("%", "",df_vf$Visit_rushing_play_pct_PreviuosSeason,fixed=TRUE))/100
  df_vf$Visit_rushing_play_pct_CurrentSeason <- as.numeric(sub("%", "",df_vf$Visit_rushing_play_pct_CurrentSeason,fixed=TRUE))/100
  df_vf$Visit_rushing_play_pct_Last3 <- as.numeric(sub("%", "",df_vf$Visit_rushing_play_pct_Last3,fixed=TRUE))/100
  df_vf$Visit_rushing_play_pct_Last1 <- as.numeric(sub("%", "",df_vf$Visit_rushing_play_pct_Last1,fixed=TRUE))/100
  df_vf$Visit_rushing_play_pct_Home <- as.numeric(sub("%", "",df_vf$Visit_rushing_play_pct_Home,fixed=TRUE))/100
  df_vf$Visit_rushing_play_pct_Away <- as.numeric(sub("%", "",df_vf$Visit_rushing_play_pct_Away,fixed=TRUE))/100
  df_vf$Visit_sack_pct_PreviuosSeason <- as.numeric(sub("%", "",df_vf$Visit_sack_pct_PreviuosSeason,fixed=TRUE))/100
  df_vf$Visit_sack_pct_CurrentSeason <- as.numeric(sub("%", "",df_vf$Visit_sack_pct_CurrentSeason,fixed=TRUE))/100
  df_vf$Visit_sack_pct_Last3 <- as.numeric(sub("%", "",df_vf$Visit_sack_pct_Last3,fixed=TRUE))/100
  df_vf$Visit_sack_pct_Last1 <- as.numeric(sub("%", "",df_vf$Visit_sack_pct_Last1,fixed=TRUE))/100
  df_vf$Visit_sack_pct_Home <- as.numeric(sub("%", "",df_vf$Visit_sack_pct_Home,fixed=TRUE))/100
  df_vf$Visit_sack_pct_Away <- as.numeric(sub("%", "",df_vf$Visit_sack_pct_Away,fixed=TRUE))/100

  df_vf <- select(df_vf,-Rk,
                  -season_year,
                  -Home_points_per_game_PreviuosSeason,
                  -Home_points_per_play_PreviuosSeason,
                  -Home_red_zone_scoring_attempts_per_game_PreviuosSeason,
                  -Home_red_zone_scores_per_game_PreviuosSeason,
                  -Home_yards_per_game_PreviuosSeason,
                  -Home_plays_per_game_PreviuosSeason,
                  -Home_yards_per_play_PreviuosSeason,
                  -Home_third_downs_per_game_PreviuosSeason,
                  -Home_third_down_conversions_per_game_PreviuosSeason,
                  -Home_average_time_of_possession_net_of_ot_PreviuosSeason,
                  -Home_punts_per_offensive_score_PreviuosSeason,
                  -Home_rushing_attempts_per_game_PreviuosSeason,
                  -Home_rushing_yards_per_game_PreviuosSeason,
                  -Home_rushing_play_pct_PreviuosSeason,
                  -Home_pass_attempts_per_game_PreviuosSeason,
                  -Home_passing_yards_per_game_PreviuosSeason,
                  -Home_qb_sacked_per_game_PreviuosSeason,
                  -Home_average_team_passer_rating_PreviuosSeason,
                  -Home_yards_per_pass_attempt_PreviuosSeason,
                  -Home_opponent_points_per_game_PreviuosSeason,
                  -Home_opponent_offensive_touchdowns_per_game_PreviuosSeason,
                  -Home_opponent_rushing_yards_per_game_PreviuosSeason,
                  -Home_opponent_rushing_first_downs_per_game_PreviuosSeason,
                  -Home_opponent_yards_per_rush_attempt_PreviuosSeason,
                  -Home_opponent_average_team_passer_rating_PreviuosSeason,
                  -Home_sack_pct_PreviuosSeason,
                  -Home_opponent_passing_yards_per_game_PreviuosSeason,
                  -Home_opponent_yards_per_pass_attempt_PreviuosSeason,
                  -Home_giveaways_per_game_PreviuosSeason,
                  -Home_takeaways_per_game_PreviuosSeason,
                  -Home_penalty_yards_per_game_PreviuosSeason,
                  -Home_opponent_penalty_yards_per_game_PreviuosSeason,
                  -Visit_points_per_game_PreviuosSeason,
                  -Visit_points_per_play_PreviuosSeason,
                  -Visit_red_zone_scoring_attempts_per_game_PreviuosSeason,
                  -Visit_red_zone_scores_per_game_PreviuosSeason,
                  -Visit_yards_per_game_PreviuosSeason,
                  -Visit_plays_per_game_PreviuosSeason,
                  -Visit_yards_per_play_PreviuosSeason,
                  -Visit_third_downs_per_game_PreviuosSeason,
                  -Visit_third_down_conversions_per_game_PreviuosSeason,
                  -Visit_average_time_of_possession_net_of_ot_PreviuosSeason,
                  -Visit_punts_per_offensive_score_PreviuosSeason,
                  -Visit_rushing_attempts_per_game_PreviuosSeason,
                  -Visit_rushing_yards_per_game_PreviuosSeason,
                  -Visit_rushing_play_pct_PreviuosSeason,
                  -Visit_pass_attempts_per_game_PreviuosSeason,
                  -Visit_passing_yards_per_game_PreviuosSeason,
                  -Visit_qb_sacked_per_game_PreviuosSeason,
                  -Visit_average_team_passer_rating_PreviuosSeason,
                  -Visit_yards_per_pass_attempt_PreviuosSeason,
                  -Visit_opponent_points_per_game_PreviuosSeason,
                  -Visit_opponent_offensive_touchdowns_per_game_PreviuosSeason,
                  -Visit_opponent_rushing_yards_per_game_PreviuosSeason,
                  -Visit_opponent_rushing_first_downs_per_game_PreviuosSeason,
                  -Visit_opponent_yards_per_rush_attempt_PreviuosSeason,
                  -Visit_opponent_average_team_passer_rating_PreviuosSeason,
                  -Visit_sack_pct_PreviuosSeason,
                  -Visit_opponent_passing_yards_per_game_PreviuosSeason,
                  -Visit_opponent_yards_per_pass_attempt_PreviuosSeason,
                  -Visit_giveaways_per_game_PreviuosSeason,
                  -Visit_takeaways_per_game_PreviuosSeason,
                  -Visit_penalty_yards_per_game_PreviuosSeason,
                  -Visit_opponent_penalty_yards_per_game_PreviuosSeason,
                  -Visit_points_per_game_Home,
                  -Visit_points_per_play_Home,
                  -Visit_red_zone_scoring_attempts_per_game_Home,
                  -Visit_red_zone_scores_per_game_Home,
                  -Visit_yards_per_game_Home,
                  -Visit_plays_per_game_Home,
                  -Visit_yards_per_play_Home,
                  -Visit_third_downs_per_game_Home,
                  -Visit_third_down_conversions_per_game_Home,
                  -Visit_average_time_of_possession_net_of_ot_Home,
                  -Visit_punts_per_offensive_score_Home,
                  -Visit_rushing_attempts_per_game_Home,
                  -Visit_rushing_yards_per_game_Home,
                  -Visit_rushing_play_pct_Home,
                  -Visit_pass_attempts_per_game_Home,
                  -Visit_passing_yards_per_game_Home,
                  -Visit_qb_sacked_per_game_Home,
                  -Visit_average_team_passer_rating_Home,
                  -Visit_yards_per_pass_attempt_Home,
                  -Visit_opponent_points_per_game_Home,
                  -Visit_opponent_offensive_touchdowns_per_game_Home,
                  -Visit_opponent_rushing_yards_per_game_Home,
                  -Visit_opponent_rushing_first_downs_per_game_Home,
                  -Visit_opponent_yards_per_rush_attempt_Home,
                  -Visit_opponent_average_team_passer_rating_Home,
                  -Visit_sack_pct_Home,
                  -Visit_opponent_passing_yards_per_game_Home,
                  -Visit_opponent_yards_per_pass_attempt_Home,
                  -Visit_giveaways_per_game_Home,
                  -Visit_takeaways_per_game_Home,
                  -Visit_penalty_yards_per_game_Home,
                  -Visit_opponent_penalty_yards_per_game_Home,
                  -Home_points_per_game_Away,
                  -Home_points_per_play_Away,
                  -Home_red_zone_scoring_attempts_per_game_Away,
                  -Home_red_zone_scores_per_game_Away,
                  -Home_yards_per_game_Away,
                  -Home_plays_per_game_Away,
                  -Home_yards_per_play_Away,
                  -Home_third_downs_per_game_Away,
                  -Home_third_down_conversions_per_game_Away,
                  -Home_average_time_of_possession_net_of_ot_Away,
                  -Home_punts_per_offensive_score_Away,
                  -Home_rushing_attempts_per_game_Away,
                  -Home_rushing_yards_per_game_Away,
                  -Home_rushing_play_pct_Away,
                  -Home_pass_attempts_per_game_Away,
                  -Home_passing_yards_per_game_Away,
                  -Home_qb_sacked_per_game_Away,
                  -Home_average_team_passer_rating_Away,
                  -Home_yards_per_pass_attempt_Away,
                  -Home_opponent_points_per_game_Away,
                  -Home_opponent_offensive_touchdowns_per_game_Away,
                  -Home_opponent_rushing_yards_per_game_Away,
                  -Home_opponent_rushing_first_downs_per_game_Away,
                  -Home_opponent_yards_per_rush_attempt_Away,
                  -Home_opponent_average_team_passer_rating_Away,
                  -Home_sack_pct_Away,
                  -Home_opponent_passing_yards_per_game_Away,
                  -Home_opponent_yards_per_pass_attempt_Away,
                  -Home_giveaways_per_game_Away,
                  -Home_takeaways_per_game_Away,
                  -Home_penalty_yards_per_game_Away,
                  -Home_opponent_penalty_yards_per_game_Away,
                  -Home_Days_on_Road,
                  -sea_level_pressure,
                  -station_pressure,
                  -Home_points_per_game_Rank,
                  -Home_points_per_play_Rank,
                  -Home_red_zone_scoring_attempts_per_game_Rank,
                  -Home_red_zone_scores_per_game_Rank,
                  -Home_yards_per_game_Rank,
                  -Home_plays_per_game_Rank,
                  -Home_yards_per_play_Rank,
                  -Home_third_downs_per_game_Rank,
                  -Home_third_down_conversions_per_game_Rank,
                  -Home_average_time_of_possession_net_of_ot_Rank,
                  -Home_punts_per_offensive_score_Rank,
                  -Home_rushing_attempts_per_game_Rank,
                  -Home_rushing_yards_per_game_Rank,
                  -Home_rushing_play_pct_Rank,
                  -Home_pass_attempts_per_game_Rank,
                  -Home_passing_yards_per_game_Rank,
                  -Home_qb_sacked_per_game_Rank,
                  -Home_average_team_passer_rating_Rank,
                  -Home_yards_per_pass_attempt_Rank,
                  -Home_opponent_points_per_game_Rank,
                  -Home_opponent_offensive_touchdowns_per_game_Rank,
                  -Home_opponent_rushing_yards_per_game_Rank,
                  -Home_opponent_rushing_first_downs_per_game_Rank,
                  -Home_opponent_yards_per_rush_attempt_Rank,
                  -Home_opponent_average_team_passer_rating_Rank,
                  -Home_sack_pct_Rank,
                  -Home_opponent_passing_yards_per_game_Rank,
                  -Home_opponent_yards_per_pass_attempt_Rank,
                  -Home_giveaways_per_game_Rank,
                  -Home_takeaways_per_game_Rank,
                  -Home_penalty_yards_per_game_Rank,
                  -Home_opponent_penalty_yards_per_game_Rank,
                  -Visit_points_per_game_Rank,
                  -Visit_points_per_play_Rank,
                  -Visit_red_zone_scoring_attempts_per_game_Rank,
                  -Visit_red_zone_scores_per_game_Rank,
                  -Visit_yards_per_game_Rank,
                  -Visit_plays_per_game_Rank,
                  -Visit_yards_per_play_Rank,
                  -Visit_third_downs_per_game_Rank,
                  -Visit_third_down_conversions_per_game_Rank,
                  -Visit_average_time_of_possession_net_of_ot_Rank,
                  -Visit_punts_per_offensive_score_Rank,
                  -Visit_rushing_attempts_per_game_Rank,
                  -Visit_rushing_yards_per_game_Rank,
                  -Visit_rushing_play_pct_Rank,
                  -Visit_pass_attempts_per_game_Rank,
                  -Visit_passing_yards_per_game_Rank,
                  -Visit_qb_sacked_per_game_Rank,
                  -Visit_average_team_passer_rating_Rank,
                  -Visit_yards_per_pass_attempt_Rank,
                  -Visit_opponent_points_per_game_Rank,
                  -Visit_opponent_offensive_touchdowns_per_game_Rank,
                  -Visit_opponent_rushing_yards_per_game_Rank,
                  -Visit_opponent_rushing_first_downs_per_game_Rank,
                  -Visit_opponent_yards_per_rush_attempt_Rank,
                  -Visit_opponent_average_team_passer_rating_Rank,
                  -Visit_sack_pct_Rank,
                  -Visit_opponent_passing_yards_per_game_Rank,
                  -Visit_opponent_yards_per_pass_attempt_Rank,
                  -Visit_giveaways_per_game_Rank,
                  -Visit_takeaways_per_game_Rank,
                  -Visit_penalty_yards_per_game_Rank,
                  -Visit_opponent_penalty_yards_per_game_Rank,
                  -weather_data)
    
  # Export ------------------------------------------------------------------
  write.csv(df_vf, file = "NCAAF_Final.csv", row.names = FALSE, na = "")

  time_end <- Sys.time()
  print(time_end - time_start)
}
