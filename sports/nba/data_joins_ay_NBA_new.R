library(tidyverse)
library(lubridate)
library(janitor)
library(assertr)
library(pbapply)
library(writexl)
library(dplyr)
library(cumstats)
# library(dtplyr)
source("functions_ay.R")
#source('config.R')

options(max.print = 1500)


# Load Data ---------------------------------------------------------------

game_logs <- read_csv(FILENAME_GAMELOGS, col_types = cols())
game_urls <- read_csv(FILENAME_GAMEURLS, col_types = cols())
game_urls <- game_urls %>% filter(!(date < "2020-07-01" & is.na(url)))
#game_urls <- game_urls[-c(7537:7651), ]


# Add team names to game logs
z1 <- game_logs %>% 
  filter(homeOrAway == "home") %>% 
  select(game.id, team_id) %>% 
  left_join(select(game_urls, game.id, home_team), "game.id") %>% 
  rename(team = home_team)

z2 <- game_logs %>% 
  filter(homeOrAway == "away") %>% 
  select(game.id, team_id) %>% 
  left_join(select(game_urls, game.id, away_team), "game.id") %>% 
  rename(team = away_team)

z3 <- bind_rows(z1, z2) %>% 
  distinct(team_id, team)

game_logs2 <- game_logs %>% 
  left_join(z3, "team_id")


game_urls2 <- game_urls %>% 
  rename_all(~str_replace(., "\\.", "_")) %>%
  select(-url) %>% 
  filter(!is.na(date)) %>% 
  left_join(z3, by = c("home_team" = "team"))


# Need to calculate 2P and 2PA stats first
# 2P = FG - 3P
# 2PA = FGA - 3PA
z_2p <- as_tibble(
  select(game_logs, ends_with("FG")) - select(game_logs, ends_with("3P"))
) %>% 
  rename_all(~str_replace(., "_FG", "_2P"))

z_2pa <- as_tibble(
  select(game_logs, ends_with("FGA")) - select(game_logs, ends_with("3PA"))
) %>% 
  rename_all(~str_replace(., "_FGA", "_2PA"))

# Convert date-times
game_logs2$Date <- gsub(month.name[1], 1, game_logs2$Date)
game_logs2$Date <- gsub(month.name[2], 2, game_logs2$Date)
game_logs2$Date <- gsub(month.name[3], 3, game_logs2$Date)
game_logs2$Date <- gsub(month.name[4], 4, game_logs2$Date)
game_logs2$Date <- gsub(month.name[5], 5, game_logs2$Date)
game_logs2$Date <- gsub(month.name[6], 6, game_logs2$Date)
game_logs2$Date <- gsub(month.name[7], 7, game_logs2$Date)
game_logs2$Date <- gsub(month.name[8], 8, game_logs2$Date)
game_logs2$Date <- gsub(month.name[9], 9, game_logs2$Date)
game_logs2$Date <- gsub(month.name[10], 10, game_logs2$Date)
game_logs2$Date <- gsub(month.name[11], 11, game_logs2$Date)
game_logs2$Date <- gsub(month.name[12], 12, game_logs2$Date)
game_logs2$datetime <- ymd_hms(strptime(game_logs2$Date, "%I:%M %p, %m %d, %Y"))

#game_logs2$datetime <- ymd_hms(strptime(game_logs2$Date, "%I:%M %p, %B %d, %Y"))
game_logs2$Date <- as.Date(floor_date(game_logs2$datetime))

game_logs2 <- bind_cols(game_logs2, z_2p, z_2pa) %>% 
  select(key:Starters_FGA, Starters_2P, Starters_2PA, Starters_3P:Reserves_FGA, 
         Reserves_2P, Reserves_2PA, Reserves_3P:Team_Total_FGA, Team_Total_2P, 
         Team_Total_2PA, everything()) %>% 
  rename_all(~str_replace(., "%", "_pct")) %>% 
  rename_all(~str_replace(., "\\.", "_")) %>%
  rename_all(~str_replace(., "Starter", "starter")) %>% 
  rename_all(~str_replace(., "Reserve", "reserve")) %>% 
  rename_all(~str_replace(., "School", "team")) %>% 
  rename_all(~str_replace(., "Team", "team")) %>% 
  mutate_at(vars(ORB_pct:TOV_pct), ~ . / 100) %>% 
  rename(date = Date) %>% 
  select(-team_id)


# Check %s are all between 0-1
game_logs2 %>% 
  select(contains("pct")) %>% 
  summarise_all(list(
    range = ~paste0(min(., na.rm = TRUE), "-", max(., na.rm = TRUE))
  )) %>% 
  print(width = Inf)
  
# Add season to game logs
game_logs2 <- game_logs2 %>% 
  left_join(select(game_urls2, game_id, season), by = "game_id") %>% 
  verify(nrow(.) == nrow(game_logs2)) %>% 
  select(key, game_id, date, datetime, season, team, Location, everything())

# Check missing values
map_int(game_logs2, ~sum(is.na(.x)))



# Add data for next match -------------------------------------------------

game_urls2 <- game_urls2 %>% 
  mutate(game_id = if_else(is.na(game_id), paste0(format(date, "%Y%m%d"), 0, team_id), game_id))

z1 <- game_urls2 %>%
  select(key:date, team = home_team) %>% 
  mutate(homeOrAway = "home",
         key = paste(game_id, homeOrAway, sep = "-"))

z2 <- game_urls2 %>%
  select(key:date, team = away_team) %>% 
  mutate(homeOrAway = "away",
         key = paste(game_id, homeOrAway, sep = "-"))

game_urls_long <- bind_rows(z1, z2)

check_schedule_for_future_games <- function(df_schedule, current_date) {
  return(sum(df_schedule$date > current_date) > 0)
}

get_teams_next_match_date <- function(df_schedule, current_date) {
  df <- df_schedule %>%
    select(date, home_team, away_team) %>%
    gather("key","team", -date) %>%
    select(-key) %>%
    filter(date > current_date) %>%
    group_by(team) %>%
    summarise(date = min(date)) %>%
    as_tibble()
  return(df)
}

any_future_games_in_schedule <- check_schedule_for_future_games(game_urls2, Sys.Date())

if (any_future_games_in_schedule) {
  date_start <- max(game_logs2$date)
  latest_teamrankings_date <- max(game_urls2$date)
  
  if (latest_teamrankings_date != date_start) {
    warning(paste("Latest data available is on", latest_teamrankings_date), immediate. = TRUE)
  }
  
  #date_start <- max(game_logs2$date) # for testing
  next_match_dates  <- get_teams_next_match_date(game_urls2, date_start)
  
  next_match_id <- game_urls_long %>% 
    semi_join(next_match_dates, by = c("team", "date")) %>% 
    distinct(game_id)
  
  df_tr_most_recent <- game_urls_long %>%
    inner_join(next_match_id, "game_id")
  
  game_logs2 <- bind_rows(game_logs2, df_tr_most_recent)
}



# Add Opponent Stats ------------------------------------------------------

z_home <- game_logs2 %>% 
  filter(homeOrAway == "home") %>% 
  rename_at(vars(First_Quarter_Score:DRtg), ~str_c("home_", .))

z_away <- game_logs2 %>% 
  filter(homeOrAway == "away") %>% 
  rename_at(vars(First_Quarter_Score:DRtg), ~str_c("away_", .))


z_home2 <- z_home %>% 
  left_join(select(z_away, game_id, team_opp = team, 
                   starts_with("away_")), 
            by = "game_id") %>% 
  verify(nrow(.) == nrow(z_home)) %>% 
  rename_all(~str_remove(., "home_")) %>% 
  rename_all(~str_replace(., "away_", "opp_")) %>% 
  mutate(at_home = 1L,
         on_the_road= 0L) %>% 
  select(-(opp_First_Quarter_Score:opp_reserves_PTS))
  
z_away2 <- z_away %>% 
  left_join(select(z_home, game_id, team_opp = team, 
                   starts_with("home_")), 
            by = "game_id") %>% 
  verify(nrow(.) == nrow(z_away)) %>%
  rename_all(~str_remove(., "away_")) %>% 
  rename_all(~str_replace(., "home_", "opp_")) %>% 
  mutate(at_home = 0L,
         on_the_road= 1L) %>% 
  select(-(opp_First_Quarter_Score:opp_reserves_PTS))

z_long <- bind_rows(z_home2, z_away2) %>% 
  select(-opp_reserves_Played, everything())



# Top Group of Stats ------------------------------------------------------

# Work with a smaller subset for testing
# z_long <- z_long %>%
#   filter(season == 2020)

# Variables needed for calculations
z_vars <- z_long %>% 
  select(starters_MP:starters_PTS, 
         reserves_MP:reserves_PTS,
         team_Total_MP:team_Total_PTS,
         opp_team_Total_MP:opp_team_Total_PTS,
         reserves_Played, opp_reserves_Played, Pace) %>% 
  names()

z_vars2 <- z_vars[!str_detect(z_vars, "starter|reserve|opp")]
z_vars2 <- c(z_vars2, "reserves_Played")


## This takes a while to run so save object as rds and reload while in development ###
z_long2 <- z_long %>%
  arrange(season, team, date) %>%
  group_by(season, team) %>%
  mutate_at(vars(z_vars),
            list(avg = cummean_lagged,
                 trend_last1 = ~last_n_avg(., n = 1),
                 trend_last3 = ~last_n_avg(., n = 3),
                 trend_last5 = ~last_n_avg(., n = 5))) %>%
  mutate_at(vars(z_vars2),
            list(avg_at_home = ~cummean_lagged_homeaway(., at_home),
                 avg_on_the_road = ~cummean_lagged_homeaway(., on_the_road))) %>%
  mutate_at(vars(First_Quarter_Score:OT_score),
            list(avg = cummean_lagged)) %>%
  mutate(OT_last_game = lag(OT_score)) %>% 
  ungroup()

# saveRDS(z_long2, file.path("data", "top_group.rds"))
# 
# z_long2 <- readRDS(file.path("data", "top_group.rds"))

glimpse(z_long2)
names(z_long2)
map_int(z_long2, ~sum(is.na(.x)))


# Experimental work using dplyr's data.table interface - may be quicker - revisit later
# z_dt <- lazy_dt(z_long)
# 
# z_dt2 <- z_dt %>%
#   arrange(team, date) %>%
#   group_by(season, team) %>%
#   mutate_at(vars(z_vars), 
#             list(avg = cummean_lagged,
#                  trend_last1 = ~last_n_avg(., n = 1),
#                  trend_last3 = ~last_n_avg(., n = 3),
#                  trend_last5 = ~last_n_avg(., n = 5))) %>%
#   mutate_at(vars(z_vars2),
#             list(avg_at_home = ~cummean_lagged_homeaway(., at_home),
#                  avg_on_the_road = ~cummean_lagged_homeaway(., on_the_road))) %>% 
#   ungroup() %>% #show_query()
#   as_tibble()



# Join time zones ---------------------------------------------------------

 df_tz <- read.csv("Team_Codes.csv", stringsAsFactors = FALSE,
                   fileEncoding = "UTF-8-BOM") %>%
   as_tibble()
 
 df_tz <- df_tz %>% 
   mutate(Pacific = if_else(Eastern == 0 & Central == 0 & Mountain == 0 & Western == 0, 1L, 0L)) %>% 
   rename(team = Schedule)
 
 df_tz2 <- df_tz %>% 
   select(team) %>% 
   mutate(tz = apply(df_tz[, 1:6], 1, function(x) names(which(x == 1))[1]))

z_long2 <- z_long2 %>% 
  left_join(df_tz, "team") %>% 
  left_join(df_tz2, "team") %>% 
  rename(tz_team = tz) %>% 
  left_join(df_tz2, by = c("team_opp" = "team")) %>% 
  rename(tz_opp = tz) %>% 
  mutate(tz_where_played = if_else(homeOrAway == "home", tz_team, tz_opp)) %>% 
  arrange(season, team, date) %>% 
  group_by(season, team) %>% 
  mutate(tz_where_played_last = lag(tz_where_played)) %>% 
  ungroup() %>% 
  select(-tz_team, -tz_opp)



# Middle and Bottom Groups ------------------------------------------------

# Function to help with selecting out variables required for calculating these stats
var_select <- function(x, option = "all") {
  if (option == "all") {
    # Default is to select variables for all levels: 
    # starters, reserves, team, opposition team, trend last 1, 3, 5, home, on the road
    # Total: 9 variables
    out <- c(paste0(c("starters_", "reserves_", "team_Total_", "opp_team_Total_"), x),
             paste0("team_Total_", x, "_trend_last", c(1, 3, 5)),
             paste0("team_Total_", x, c("_avg_at_home", "_avg_on_the_road")))
    
  } else if (option == "opp_only") {
    # Select variables available at opposition level only
    # opposition team, trend last 1, 3, 5
    # Total: 4 variables
    out <- c(paste0("opp_team_Total_", x),
             paste0("opp_team_Total_", x, "_trend_last", c(1, 3, 5)))
    
  } else if (option == "team_only") {
    # Select variables at team level which match up to those at those only available at opposition level
    # team, trend last 1, 3, 5
    # Total: 4 variables
    out <- c(paste0("team_Total_", x),
             paste0("team_Total_", x, "_trend_last", c(1, 3, 5)))
    
  } else if(option == "total_stat_pg") {
    # Select variables needed when 'Total Stat PG' is involved
    # Here starters and reserves both match up to team totals
    # Total: 9 variables (team total repeated 3 times, opposition, trend last 1, 3, 5, home, on the road)
    out <- c(paste0(c("team_Total_", "team_Total_", "team_Total_", "opp_team_Total_"), x),
             paste0("team_Total_", x, "_trend_last", c(1, 3, 5)),
             paste0("team_Total_", x, c("_avg_at_home", "_avg_on_the_road")))
  } else if (option == "reserves_only") {
    # Select variables available at opposition level only
    # opposition team, trend last 1, 3, 5
    # Total: 4 variables
    out <- c(paste0("reserves_", x),
             paste0("reserves_", x, "_trend_last", c(1, 3, 5)))
  } else if (option == "starters_only") {
    # Select variables available at opposition level only
    # opposition team, trend last 1, 3, 5
    # Total: 4 variables
    out <- c(paste0("starters_", x),
             paste0("starters_", x, "_trend_last", c(1, 3, 5)))
  }
  
  # Tidy to match with variable names in the dataset
  out <- out %>% 
    str_replace_all("_avg_avg", "_avg") %>% 
    str_replace_all("_avg_trend", "_trend")
  
  return(out)
}

# Function to select required columns from a dataset according to variables in var_select()
var_select_df <- function(df, x, option = "all") {
  if (option != "total_stat_pg") {
    dplyr::select(df, var_select(x, option = option))
  } else {
    # When 'Total Stat PG' is involved, need to repeat team total 3 times (starters, reserves, team)
    var1 <- var_select(x, option = option)[1]
    bind_cols(dplyr::select(df, var1),
              dplyr::select(df, var1),
              dplyr::select(df, var_select(x, option = option)))
  }
}


# Basic ideas:
# FG or Total FG or FG PG: use x = 'FG_avg'
# Total FG PG: use x = 'FG_avg' and option 'total_stat_pg'
# OppFG: use x = 'FG_avg' and option 'opp_only' (if stat calculation also involves team stats, use option 'team_only' for them)


# The code below takes the 9 columns for FG and divides them by the corresponding 9 FGA columns
# e.g. starters_FG / starters_FGA, reserves_FG / reserves_FGA, etc

# FG%
# Total FG / Total FGA
z_fg <- as_tibble(var_select_df(z_long2, "FG_avg") / var_select_df(z_long2, "FGA_avg")) %>% 
  rename_all(~str_replace_all(., "_FG_avg", "_FG_pct")) %>% 
  rename_all(~str_replace_all(., "_FG_trend", "_FG_pct_trend"))

# bind_cols(select(z_long2, 1:7, team_opp), z_fg) %>% 
#   filter(team == "Michigan State") %>% 
#   View()

# 2P%
# Total 2P / Total 2PA
z_2p <- as_tibble(var_select_df(z_long2, "2P_avg") / var_select_df(z_long2, "2PA_avg")) %>% 
  rename_all(~str_replace_all(., "_2P_avg", "_2P_pct")) %>% 
  rename_all(~str_replace_all(., "_2P_trend", "_2P_pct_trend"))

# 3P%
# Total 3P / Total 3PA
z_3p <- as_tibble(var_select_df(z_long2, "3P_avg") / var_select_df(z_long2, "3PA_avg")) %>% 
  rename_all(~str_replace_all(., "_3P_avg", "_3P_pct")) %>%
  rename_all(~str_replace_all(., "_3P_trend", "_3P_pct_trend")) 

# FT%
# Total FT / Total FTA
z_ft <- as_tibble(var_select_df(z_long2, "FT_avg") / var_select_df(z_long2, "FTA_avg")) %>% 
  rename_all(~str_replace_all(., "_FT_avg", "FT_pct")) %>%
  rename_all(~str_replace_all(., "_FT_trend", "FT_pct_trend"))

# These 4 stats above look straightforward and pretty sure are correct but then
# gets more complicated after these

map_depth(list(z_fg, z_2p, z_3p, z_ft), .depth = 2, range, na.rm = TRUE)


# TmPoss
z_tmposs <- as_tibble(
  0.5 * (var_select_df(z_long2, "FGA_avg", "team_only") + 0.475 * var_select_df(z_long2, "FTA_avg", "team_only") - var_select_df(z_long2, "ORB_avg", "team_only") + var_select_df(z_long2, "TOV_avg", "team_only")) + 
    0.5 * (var_select_df(z_long2, "FGA_avg", "opp_only") + 0.475 * var_select_df(z_long2, "FTA_avg", "opp_only") - var_select_df(z_long2, "ORB_avg", "opp_only") + var_select_df(z_long2, "TOV_avg", "opp_only"))
) %>% 
  rename_all(~str_replace_all(., "_FGA_avg", "_TmPoss")) %>% 
  rename_all(~str_replace_all(., "_FGA_trend", "_TmPoss_trend")) 

map(z_tmposs, range, na.rm = TRUE)

# OppTmPoss
# 0.5 * (Opp FGA + 0.475 * Opp FTA - Opp ORB + Opp TOV) + 0.5 * (FGA + 0.475 * FTA - ORB + TOV)
z_opptmposs <- as_tibble(
  0.5 * (var_select_df(z_long2, "FGA_avg", "opp_only") + 0.475 * var_select_df(z_long2, "FTA_avg", "opp_only") - var_select_df(z_long2, "ORB_avg", "opp_only") + var_select_df(z_long2, "TOV_avg", "opp_only")) +
  0.5 * (var_select_df(z_long2, "FGA_avg", "team_only") + 0.475 * var_select_df(z_long2, "FTA_avg", "team_only") - var_select_df(z_long2, "ORB_avg", "team_only") + var_select_df(z_long2, "TOV_avg", "team_only"))
) %>% 
  rename_all(~str_replace_all(., "_FGA_avg", "_TmPoss")) %>% 
  rename_all(~str_replace_all(., "_FGA_trend", "_TmPoss_trend")) 

map(z_opptmposs, range, na.rm = TRUE)


# ORATING
# 100/(TmPoss PG + OppPoss PG) * PTS PG
z_orating <- as_tibble(
  100 / 
    (z_tmposs + z_opptmposs) *
    var_select_df(z_long2, "PTS_avg", "team_only")
) %>% 
  rename_all(~str_replace_all(., "TmPoss", "ORATING"))

map(z_orating, range, na.rm = TRUE)

# DRATING
# 100/(TmPoss PG + OppPoss PG) * OppPTS PG
z_drating <- as_tibble(
  100 / 
    (z_tmposs + z_opptmposs) *
    var_select_df(z_long2, "PTS_avg", "opp_only")
) %>% 
  rename_all(~str_replace_all(., "_TmPoss", "_DRATING"))

map(z_drating, range, na.rm = TRUE)


# EFG%
# (FG PG + .5*3P PG)/FGA PG
z_efg <- as_tibble(
  (var_select_df(z_long2, "FG_avg") + 0.5 * var_select_df(z_long2, "3P_avg")) / var_select_df(z_long2, "FGA_avg")
) %>% 
  rename_all(~str_replace_all(., "_FG_avg", "_EFG_pct")) %>% 
  rename_all(~str_replace_all(., "_FG_trend", "_EFG_pct_trend"))

map(z_efg, range, na.rm = TRUE)

# TS%
# PTS / (2 * (FGA + .475 * FTA))
z_ts <- as_tibble(
  var_select_df(z_long2, "PTS_avg") / 
    (2 * (var_select_df(z_long2, "FGA_avg") + 0.475 * var_select_df(z_long2, "FTA_avg")))
) %>% 
  rename_all(~str_replace_all(., "_PTS_avg", "_TS_pct")) %>% 
  rename_all(~str_replace_all(., "_PTS_trend", "_TS_pct_trend"))

map(z_ts, range, na.rm = TRUE) # Some %s above 1 - is this ok?


# ORB%
# ORB / (ORB + OppDRB)
z_orb <- as_tibble(
  var_select_df(z_long2, "ORB_avg", "team_only") / 
    (var_select_df(z_long2, "ORB_avg", "team_only") + var_select_df(z_long2, "DRB_avg", "opp_only"))
) %>% 
  rename_all(~str_replace_all(., "_ORB_avg", "_ORB_pct")) %>% 
  rename_all(~str_replace_all(., "_ORB_trend", "_ORB_pct_trend"))

map(z_orb, range, na.rm = TRUE)

# DRB%
# DRB / (DRB + OppORB)
z_drb <- as_tibble(
  var_select_df(z_long2, "DRB_avg", "team_only") / 
    (var_select_df(z_long2, "DRB_avg", "team_only") + var_select_df(z_long2, "ORB_avg", "opp_only"))
) %>% 
  rename_all(~str_replace_all(., "_DRB_avg", "_DRB_pct")) %>% 
  rename_all(~str_replace_all(., "_DRB_trend", "_DRB_pct_trend"))

map(z_drb, range, na.rm = TRUE)

# TRB%
# TRB / (TRB + OppTRB)
z_trb <- as_tibble(
  var_select_df(z_long2, "TRB_avg", "team_only") / 
    (var_select_df(z_long2, "TRB_avg", "team_only") + var_select_df(z_long2, "TRB_avg", "opp_only"))
) %>% 
  rename_all(~str_replace_all(., "_TRB_avg", "_TRB_pct")) %>% 
  rename_all(~str_replace_all(., "_TRB_trend", "_TRB_pct_trend"))

map(z_trb, range, na.rm = TRUE)

# HAST% - changed to match closely to updated TOV% formula
# AST / (FGA + 0.44 * FTA + TOV)
z_hast <- as_tibble(
  var_select_df(z_long2, "AST_avg") / 
    (var_select_df(z_long2, "FGA_avg") + 0.44 * var_select_df(z_long2, "FTA_avg") + var_select_df(z_long2, "TOV_avg"))
) %>% 
  rename_all(~str_replace_all(., "_AST", "_HAST_pct")) %>% 
  rename_all(~str_replace_all(., "_AST_trend", "_HAST_pct_trend"))

map(z_hast, range, na.rm = TRUE)


# PAST%
# AST PG / (((MP PG /  (Total MP PG  / 5)) * FG PG) - FG PG)
z_past <- as_tibble(
  var_select_df(z_long2, "AST_avg") / 
    (((var_select_df(z_long2, "MP_avg") /  (var_select_df(z_long2, "MP_avg", "total_stat_pg")  / 5)) * var_select_df(z_long2, "FG_avg", "total_stat_pg")) - var_select_df(z_long2, "FG_avg"))
) %>% 
  rename_all(~str_replace_all(., "_AST_avg", "_PAST_pct")) %>% 
  rename_all(~str_replace_all(., "_AST_trend", "_PAST_pct_trend"))

map(z_past, range, na.rm = TRUE)

# AST%
# AST / FG
z_ast <- as_tibble(
  var_select_df(z_long2, "AST_avg", "team_only") / var_select_df(z_long2, "FG_avg", "team_only")
) %>% 
  rename_all(~str_replace_all(., "_AST_avg", "_AST_pct")) %>% 
  rename_all(~str_replace_all(., "_AST_trend", "_AST_pct_trend"))

map(z_past, range, na.rm = TRUE)

# STL%
# STL PG / (MP PG / (TOTAL MP PG / 5)) * OppTmPOSS PG
# STL / ((MP / (TmMP / 5)) * OppPoss)
# STL / TmPoss
z_stl <- as_tibble(
  var_select_df(z_long2, "STL_avg", "team_only") / z_tmposs
) %>% 
  rename_all(~str_replace_all(., "_STL_avg", "_STL_pct")) %>% 
  rename_all(~str_replace_all(., "_STL_trend", "_STL_pct_trend"))

map(z_stl, range, na.rm = TRUE)

# BLK%
# BLK PG / (OppFGA PG - Opp3PA PG)
z_blk <- as_tibble(
  var_select_df(z_long2, "BLK_avg", "team_only") / 
    (var_select_df(z_long2, "FGA_avg", "opp_only") - var_select_df(z_long2, "3PA_avg", "opp_only"))
) %>% 
  rename_all(~str_replace_all(., "_BLK_avg", "_BLK_pct")) %>% 
  rename_all(~str_replace_all(., "_BLK_trend", "_BLK_pct_trend")) 

map(z_blk, range, na.rm = TRUE)


# TOV%
# TOV / (FGA + 0.44 * FTA + TOV)
z_tov <- as_tibble(
  var_select_df(z_long2, "TOV_avg") / 
    (var_select_df(z_long2, "FGA_avg") + 0.44 * var_select_df(z_long2, "FTA_avg") + var_select_df(z_long2, "TOV_avg"))
) %>% 
  rename_all(~str_replace_all(., "_TOV_avg", "_TOV_pct")) %>% 
  rename_all(~str_replace_all(., "_TOV_trend", "_TOV_pct_trend"))

map(z_tov, range, na.rm = TRUE)

# AST/TO
# AST PG / TOV PG
z_ast_to <- as_tibble(
  var_select_df(z_long2, "AST_avg") / var_select_df(z_long2, "TOV_avg")
) %>% 
  rename_all(~str_replace_all(., "_AST_avg", "_AST_TO")) %>% 
  rename_all(~str_replace_all(., "_AST_trend", "_AST_TO_trend"))

map(z_ast_to, range, na.rm = TRUE) # starters/reservers goes to Inf so TOV must be 0 sometimes

# FTr
# FTA / FGA
z_ftr <- as_tibble(
  var_select_df(z_long2, "FTA_avg") / var_select_df(z_long2, "FGA_avg")
) %>% 
  rename_all(~str_replace_all(., "_FTA_avg", "_FTr")) %>% 
  rename_all(~str_replace_all(., "_FTA_trend", "_FTr_trend"))

map(z_ftr, range, na.rm = TRUE)


# Bench Depth Rating
# (Bench PTS PG + Bench STL PG + Bench BLK PG - Bench TOV PG) / Bench MP PG
z_bdr <- as_tibble(
  (var_select_df(z_long2, "PTS_avg", "reserves_only") + var_select_df(z_long2, "STL_avg", "reserves_only") + 
     var_select_df(z_long2, "BLK_avg", "reserves_only") - var_select_df(z_long2, "TOV_avg", "reserves_only")) / 
    var_select_df(z_long2, "MP_avg", "reserves_only")
) %>% 
  rename_all(~str_replace_all(., "_PTS_avg", "_BDR")) %>% 
  rename_all(~str_replace_all(., "_PTS_trend", "_BDR_trend"))

map(z_bdr, range, na.rm = TRUE) # Not sure why there are negative values

# Starting Lineup Rating
# (Starters PTS PG + Starters STL PG + Starters BLK PG - Starters TOV PG) / Starters MP PG
z_slr <- as_tibble(
  (var_select_df(z_long2, "PTS_avg", "starters_only") + var_select_df(z_long2, "STL_avg", "starters_only") + 
     var_select_df(z_long2, "BLK_avg", "starters_only") - var_select_df(z_long2, "TOV_avg", "starters_only")) / 
    var_select_df(z_long2, "MP_avg", "starters_only")
) %>% 
  rename_all(~str_replace_all(., "_PTS_avg", "_SLR")) %>% 
  rename_all(~str_replace_all(., "_PTS_trend", "_SLR_trend"))

map(z_slr, range, na.rm = TRUE)


# Combine
z_long3 <- bind_cols(z_long2,
                     z_fg, z_2p, z_3p, z_ft, z_tmposs, z_opptmposs, z_orating, 
                     z_drating, z_efg, z_ts, z_orb, z_drb, z_trb, z_hast, z_past, 
                     z_ast, z_stl, z_blk, z_tov, z_ast_to, z_ftr, z_bdr, z_slr)



# Home team stats and away team stats on one line -------------------------

z_home3 <- z_long3 %>% 
  filter(homeOrAway == "home") %>% 
  rename_at(vars(team, First_Quarter_Score:starters_SLR_trend_last5), ~str_c("home_", .x)) %>% 
  select(-homeOrAway, -key)

z_away3 <- z_long3 %>% 
  filter(homeOrAway == "away") %>% 
  rename_at(vars(team, First_Quarter_Score:starters_SLR_trend_last5), ~str_c("away_", .x)) %>% 
  select(-homeOrAway, -key, -Location, -datetime)

df_vf <- z_home3 %>% 
  left_join(z_away3, by = c("game_id", "season", "date"))



# Weighted Stats ----------------------------------------------------------

z <- df_vf %>%
  arrange(season, date) %>% 
  select(season, date, home_team, away_team, home_Total_Score, away_Total_Score) %>% 
  rowid_to_column("id") # Add id variable as weighted function currently uses this

z_home <- z %>%
  select(id, date, season,
         team = home_team,
         team_opponent = away_team,
         points = home_Total_Score,
         points_opponent = away_Total_Score) %>%
  rename_all(str_remove, pattern = "^_home")

z_away <- z %>%
  select(id, date, season,
         team = away_team,
         team_opponent = home_team,
         points = away_Total_Score,
         points_opponent = home_Total_Score) %>%
  rename_all(str_remove, pattern = "^home_") %>%
  verify(nrow(.) == nrow(z_home))

schedule_long <- bind_rows(z_home, z_away) %>%
  verify(nrow(.) == nrow(df_vf) * 2L) %>%
  rename(game_date = date) %>%
  verify(nrow(.) == nrow(distinct(., game_date, season, team, team_opponent)))
# The verify() statement above checks that matches are unique


# Add in variables required to calculate weighted stats
# Add running average percentage
schedule_long <- schedule_long %>%
  mutate(points_total = points + points_opponent,
         points_perc = if_else(points_total > 0, points / points_total, 0)) %>%
  arrange(team, game_date) %>%
  group_by(season, team) %>%
  mutate_at(vars(points, points_opponent, points_perc), 
            list(avg = cummean_lagged)) %>% 
  ungroup() %>% 
  select(-points_total)


# Add expected share
join_vars <- c("id", "game_date", "team", "season")

schedule_long <- schedule_long %>% 
  mutate(exp_share = 1 - points_perc_avg) %>% 
  select(-points_perc_avg) %>% 
  left_join(select(schedule_long, join_vars, avg_pts = points_avg), 
            by = c("id", "game_date", "season", "team" = "team")) %>% 
  left_join(select(schedule_long, join_vars, avg_pts_opponent = points_avg), 
            by = c("id", "game_date", "season", "team_opponent" = "team")) %>% 
  left_join(select(schedule_long, join_vars, avg_pts_allowed = points_opponent_avg), 
            by = c("id", "game_date", "season", "team" = "team")) %>% 
  left_join(select(schedule_long, join_vars, avg_pts_allowed_opponent = points_opponent_avg), 
            by = c("id", "game_date", "season", "team_opponent" = "team")) %>% 
  mutate(diff_exp_share = points_perc - exp_share,
         diff_off = points - avg_pts_allowed_opponent,
         diff_def = avg_pts_opponent - points_opponent)

# Add Weighted Stats
n <- 3
z_param1 <- rep(c("diff_exp_share", "diff_off", "diff_def"), each = n) %>% 
  syms()
z_param2 <- rep(c(3, 5, 7), n)
z_param3 <- rep(c("weighted", "off", "def"), each = n)
z_param3 <- paste0("last", z_param2, "_", z_param3)

z_weighted_df <- pmap(list(z_param1, z_param2, z_param3), 
                      ~last_n_weighted(schedule_long, !!..1, ..2, !!..3)) %>% 
  reduce(left_join, by = join_vars)

schedule_long <- schedule_long %>% 
  left_join(z_weighted_df, by = join_vars) %>% 
  select(-(points_perc:diff_def))



# Add Weighted Stats to Schedule ------------------------------------------

# Add in stats for home teams
z_join_df <- schedule_long %>% 
  select(game_date, season, team, last3_weighted:last7_def) %>% 
  rename_at(vars(last3_weighted:last7_def), ~str_c("home_", .))

df_vf <- df_vf %>% 
  left_join(z_join_df, 
            by = c("date" = "game_date", 
                   "season", 
                   "home_team" = "team"))

# Add in stats for away teams
z_join_df <- schedule_long %>% 
  select(game_date, season, team, last3_weighted:last7_def) %>% 
  rename_at(vars(last3_weighted:last7_def), ~str_c("away_", .))

df_vf <- df_vf %>% 
  left_join(z_join_df, 
            by = c("date" = "game_date", 
                   "season", 
                   "away_team" = "team")) %>% 
  arrange(date)



# Add days off ------------------------------------------------------------

calculate_days_off <- function(df, team) {
  df_doff <- df %>%
    select(date, home_team, away_team) %>%
    filter(home_team == team | away_team == team) %>%
    arrange(date) %>%
    mutate(Days_Off = as.integer(date - lag(date)),
           Team = team) %>%
    select(date, Team, Days_Off)
  return(df_doff)
}

team_un <- c(df_vf$home_team, df_vf$away_team) %>%
  unique() %>%
  sort()

df_days_off <- team_un %>%
  pblapply(calculate_days_off, df = df_vf) %>%
  bind_rows() %>%
  arrange(date, Team, desc(Days_Off)) %>%
  group_by(date, Team) %>% slice(1) %>% ungroup()

colnames(df_days_off) <- paste0("Home_", colnames(df_days_off))
df_vf <- df_vf %>%
  left_join(df_days_off,
            by = c("date" = "Home_date", "home_team" = "Home_Team")) %>%
  verify(nrow(.) == nrow(df_vf))
colnames(df_days_off) <- gsub("Home_", "Away_", colnames(df_days_off))

df_vf <- df_vf %>%
  left_join(df_days_off,
            by = c("date" = "Away_date", "away_team" = "Away_Team")) %>%
  verify(nrow(.) == nrow(df_vf))



# Add days on the road ----------------------------------------------------

calculate_days_on_road <- function(df, team) {
  df_aux <- df %>%
    select(date, home_team, away_team) %>%
    filter(home_team == team | away_team == team) %>%
    mutate(TeamTag = ifelse(away_team == team, "A", "H"),
           Team = team) %>%
    select(date, Team, TeamTag) %>%
    arrange(date)
  for (i in 1:nrow(df_aux)) {
    date_end <- df_aux$date[i]
    df_aux2 <- df_aux %>% filter(date < date_end & TeamTag == "H")
    date_start <- ifelse(nrow(df_aux2) == 0,
                         min(df_aux$date),
                         max(df_aux2$date)) %>%
      as.Date(format = "%Y-%m-%d", origin = "1970-01-01")
    df_aux$Days_on_Road[i] <- ifelse(df_aux$TeamTag[i] == "H", 0,
                                     df_aux %>%
                                       filter(date > date_start, date <= date_end) %>%
                                       .$TeamTag %>%
                                       (function(x) {
                                         x == "A"
                                       }) %>% sum())
  }
  return(df_aux %>% select(date, Team, Days_on_Road))
}

df_days_on_road <- team_un %>%
  pblapply(calculate_days_on_road, df = df_vf) %>%
  bind_rows() %>%
  arrange(date, Team, desc(Days_on_Road)) %>%
  group_by(date, Team) %>% slice(1) %>% ungroup()

colnames(df_days_on_road) <- paste0("home_", colnames(df_days_on_road))
df_vf <- df_vf %>%
  left_join(df_days_on_road,
            by = c("date" = "home_date", "home_team" = "home_Team")) %>%
  verify(nrow(.) == nrow(df_vf))

colnames(df_days_on_road) <- gsub("home_", "away_", colnames(df_days_on_road))
df_vf <- df_vf %>%
  left_join(df_days_on_road,
            by = c("date" = "away_date", "away_team" = "away_Team")) %>%
  verify(nrow(.) == nrow(df_vf))

  salaries_by_game <- read_csv(FILENAME_SALARIES_BY_GAMES, col_types = cols()) %>%
    mutate(game.id_calc = paste0(gsub('-', '', date), 0,home_team_id)) %>%
    select(game.id_calc, salary_on_court_hometeam, salary_on_injury_hometeam, salary_on_court_awayteam, salary_on_injury_awayteam) 
  df_vf <- df_vf %>% left_join(salaries_by_game, by = c("game_id" = "game.id_calc"))

# Check stats have been added in for upcoming matches
# df_vf %>%
#   filter(is.na(home_First_Quarter_Score)) %>%
#   View()

df_vf <- select(df_vf, -home_Pace,	-home_starters_MP,-home_starters_FG,	-home_starters_FGA,	-home_starters_2P,	-home_starters_2PA,	-home_starters_3P, -home_starters_3PA,	-home_starters_FT,	
                -home_starters_FTA,	-home_starters_ORB,	-home_starters_DRB,	-home_starters_TRB,	-home_starters_AST,	-home_starters_STL,	-home_starters_BLK,	-home_starters_TOV,	-home_starters_PF,	-home_starters_PTS,	
                -home_reserves_MP,	-home_reserves_FG,	-home_reserves_FGA,	-home_reserves_2P,	-home_reserves_2PA,	-home_reserves_3P,	-home_reserves_3PA,	-home_reserves_FT,	-home_reserves_FTA,	-home_reserves_ORB,	
                -home_reserves_DRB,	-home_reserves_TRB,	-home_reserves_AST,	-home_reserves_STL,	-home_reserves_BLK,	-home_reserves_TOV,	-home_reserves_PF,	-home_reserves_PTS,	-home_reserves_Played,	-home_team_Total_MP,	
                -home_team_Total_FG,	-home_team_Total_FGA,	-home_team_Total_2P,	-home_team_Total_2PA,	-home_team_Total_3P,	-home_team_Total_3PA,	-home_team_Total_FT,	-home_team_Total_FTA,	-home_team_Total_ORB,	
                -home_team_Total_DRB,	-home_team_Total_TRB,	-home_team_Total_AST,	-home_team_Total_STL,	-home_team_Total_BLK,	-home_team_Total_TOV,	-home_team_Total_PF,	-home_team_Total_PTS,	-home_TS_pct,	-home_eFG_pct,	
                -home_3PAr,	-home_FTr,	-home_ORB_pct,	-home_DRB_pct,	-home_TRB_pct,	-home_AST_pct,	-home_STL_pct,	-home_BLK_pct,	-home_TOV_pct,	-home_ORtg,	-home_DRtg, -home_opp_team_Total_MP,	-home_opp_team_Total_FG,	
                -home_opp_team_Total_FGA,	-home_opp_team_Total_2P,	-home_opp_team_Total_2PA,	-home_opp_team_Total_3P,	-home_opp_team_Total_3PA,	-home_opp_team_Total_FT,	-home_opp_team_Total_FTA,	-home_opp_team_Total_ORB,	
                -home_opp_team_Total_DRB,	-home_opp_team_Total_TRB,	-home_opp_team_Total_AST,	-home_opp_team_Total_STL,	-home_opp_team_Total_BLK,	-home_opp_team_Total_TOV,	-home_opp_team_Total_PF,	-home_opp_team_Total_PTS,	
                -home_opp_TS_pct,	-home_opp_eFG_pct,	-home_opp_3PAr,	-home_opp_FTr,	-home_opp_ORB_pct,	-home_opp_DRB_pct,	-home_opp_TRB_pct,	-home_opp_AST_pct,	-home_opp_STL_pct,	-home_opp_BLK_pct,	-home_opp_TOV_pct,	
                -home_opp_ORtg,	-home_opp_DRtg,	-home_at_home,	-home_on_the_road,	-home_opp_reserves_Played, -home_team_opp, -home_Pacific)
#commented by Javad: removed home_Pacific

df_vf <- select(df_vf, -away_Pace,	-away_starters_MP,-away_starters_FG,	-away_starters_FGA,	-away_starters_2P,	-away_starters_2PA,	-away_starters_3P, -away_starters_3PA,	-away_starters_FT,	
                -away_starters_FTA,	-away_starters_ORB,	-away_starters_DRB,	-away_starters_TRB,	-away_starters_AST,	-away_starters_STL,	-away_starters_BLK,	-away_starters_TOV,	-away_starters_PF,	-away_starters_PTS,	
                -away_reserves_MP,	-away_reserves_FG,	-away_reserves_FGA,	-away_reserves_2P,	-away_reserves_2PA,	-away_reserves_3P,	-away_reserves_3PA,	-away_reserves_FT,	-away_reserves_FTA,	-away_reserves_ORB,	
                -away_reserves_DRB,	-away_reserves_TRB,	-away_reserves_AST,	-away_reserves_STL,	-away_reserves_BLK,	-away_reserves_TOV,	-away_reserves_PF,	-away_reserves_PTS,	-away_reserves_Played,	-away_team_Total_MP,	
                -away_team_Total_FG,	-away_team_Total_FGA,	-away_team_Total_2P,	-away_team_Total_2PA,	-away_team_Total_3P,	-away_team_Total_3PA,	-away_team_Total_FT,	-away_team_Total_FTA,	-away_team_Total_ORB,	
                -away_team_Total_DRB,	-away_team_Total_TRB,	-away_team_Total_AST,	-away_team_Total_STL,	-away_team_Total_BLK,	-away_team_Total_TOV,	-away_team_Total_PF,	-away_team_Total_PTS,	-away_TS_pct,	-away_eFG_pct,	
                -away_3PAr,	-away_FTr,	-away_ORB_pct,	-away_DRB_pct,	-away_TRB_pct,	-away_AST_pct,	-away_STL_pct,	-away_BLK_pct,	-away_TOV_pct,	-away_ORtg,	-away_DRtg, -away_opp_team_Total_MP,	-away_opp_team_Total_FG,	
                -away_opp_team_Total_FGA,	-away_opp_team_Total_2P,	-away_opp_team_Total_2PA,	-away_opp_team_Total_3P,	-away_opp_team_Total_3PA,	-away_opp_team_Total_FT,	-away_opp_team_Total_FTA,	-away_opp_team_Total_ORB,	
                -away_opp_team_Total_DRB,	-away_opp_team_Total_TRB,	-away_opp_team_Total_AST,	-away_opp_team_Total_STL,	-away_opp_team_Total_BLK,	-away_opp_team_Total_TOV,	-away_opp_team_Total_PF,	-away_opp_team_Total_PTS,	
                -away_opp_TS_pct,	-away_opp_eFG_pct,	-away_opp_3PAr,	-away_opp_FTr,	-away_opp_ORB_pct,	-away_opp_DRB_pct,	-away_opp_TRB_pct,	-away_opp_AST_pct,	-away_opp_STL_pct,	-away_opp_BLK_pct,	-away_opp_TOV_pct,	
                -away_opp_ORtg,	-away_opp_DRtg,	-away_at_home,	-away_on_the_road,	-away_opp_reserves_Played, -away_team_opp, -home_Days_on_Road, -away_Pacific)
#commented by Javad: removed away_Pacific


# Export ------------------------------------------------------------------

# Check variable names alongside a sample of data
# tibble(var_name = names(df_vf),
#        data = unname(t(df_vf[1000, ]))) %>%
#   write_xlsx(file.path("output", "nba_var_names.xlsx"), col_names = FALSE)


#commented by Javad: my additions start here
z_home2_sorted = z_home2[order(z_home2$date),]
z_away2_sorted = z_away2[order(z_away2$date),]
z_home2_sorted$First_Quarter_Score_Allowed = z_away2_sorted$First_Quarter_Score
z_home2_sorted$Second_Quarter_Score_Allowed = z_away2_sorted$Second_Quarter_Score
z_home2_sorted$Third_Quarter_Score_Allowed = z_away2_sorted$Third_Quarter_Score
z_home2_sorted$Fourth_Quarter_Score_Allowed = z_away2_sorted$Fourth_Quarter_Score
z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(First_Quarter_Score_avg=lag(cummean(First_Quarter_Score),k=1, default=0))

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Second_Quarter_Score_avg=lag(cummean(Second_Quarter_Score),k=1, default=0))

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Third_Quarter_Score_avg=lag(cummean(Third_Quarter_Score),k=1, default=0))

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Fourth_Quarter_Score_avg=lag(cummean(Fourth_Quarter_Score),k=1, default=0))


z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(First_Quarter_Score_Allowed_avg=lag(cummean(First_Quarter_Score_Allowed),k=1, default=0))

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Second_Quarter_Score_Allowed_avg=lag(cummean(Second_Quarter_Score_Allowed),k=1, default=0))	

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Third_Quarter_Score_Allowed_avg=lag(cummean(Third_Quarter_Score_Allowed),k=1, default=0))

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Fourth_Quarter_Score_Allowed_avg=lag(cummean(Fourth_Quarter_Score_Allowed),k=1, default=0))	

df_vf$home_First_Quarter_Scoring_Differential <- z_home2_sorted$First_Quarter_Score_avg - z_home2_sorted$First_Quarter_Score_Allowed_avg	
df_vf$home_Second_Quarter_Scoring_Differential <- z_home2_sorted$Second_Quarter_Score_avg - z_home2_sorted$Second_Quarter_Score_Allowed_avg
df_vf$home_Third_Quarter_Scoring_Differential <- z_home2_sorted$Third_Quarter_Score_avg - z_home2_sorted$Third_Quarter_Score_Allowed_avg	
df_vf$home_Fourth_Quarter_Scoring_Differential <- z_home2_sorted$Fourth_Quarter_Score_avg - z_home2_sorted$Fourth_Quarter_Score_Allowed_avg


z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Scoring_Volatility=lag(sqrt(cumvar(First_Quarter_Score+Second_Quarter_Score+Third_Quarter_Score+Fourth_Quarter_Score)),k=1, default=0))
df_vf$home_Scoring_Volatility <- z_home2_sorted$Scoring_Volatility

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Wasted_Possession_Volatility=lag(sqrt(cumvar(team_Total_FGA+team_Total_FT-team_Total_FGA-team_Total_FTA+team_Total_TOV)),k=1, default=0))
df_vf$home_Wasted_Possession_Volatility <- z_home2_sorted$Wasted_Possession_Volatility

#(FGA+FTA)-(FT+FG)
#z_home2_sorted$team_Total_TOV		

z_home2_sorted <- z_home2_sorted %>% 
  group_by(season, team) %>%
  mutate(Defensive_Volatility=lag(sqrt(cumvar(First_Quarter_Score_Allowed+Second_Quarter_Score_Allowed+Third_Quarter_Score_Allowed+Fourth_Quarter_Score_Allowed-team_Total_STL-team_Total_BLK)),k=1, default=0))
df_vf$home_Defensive_Volatility <- z_home2_sorted$Defensive_Volatility

#points allowed - steal - block	
#for away team
z_away2_sorted$First_Quarter_Score_Allowed = z_home2_sorted$First_Quarter_Score
z_away2_sorted$Second_Quarter_Score_Allowed = z_home2_sorted$Second_Quarter_Score
z_away2_sorted$Third_Quarter_Score_Allowed = z_home2_sorted$Third_Quarter_Score
z_away2_sorted$Fourth_Quarter_Score_Allowed = z_home2_sorted$Fourth_Quarter_Score
library(dplyr)
z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(First_Quarter_Score_avg=lag(cummean(First_Quarter_Score),k=1, default=0))

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Second_Quarter_Score_avg=lag(cummean(Second_Quarter_Score),k=1, default=0))

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Third_Quarter_Score_avg=lag(cummean(Third_Quarter_Score),k=1, default=0))

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Fourth_Quarter_Score_avg=lag(cummean(Fourth_Quarter_Score),k=1, default=0))

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(First_Quarter_Score_Allowed_avg=lag(cummean(First_Quarter_Score_Allowed),k=1, default=0))

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Second_Quarter_Score_Allowed_avg=lag(cummean(Second_Quarter_Score_Allowed),k=1, default=0))	

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Third_Quarter_Score_Allowed_avg=lag(cummean(Third_Quarter_Score_Allowed),k=1, default=0))

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Fourth_Quarter_Score_Allowed_avg=lag(cummean(Fourth_Quarter_Score_Allowed),k=1, default=0))	

df_vf$away_First_Quarter_Scoring_Differential <- z_away2_sorted$First_Quarter_Score_avg - z_away2_sorted$First_Quarter_Score_Allowed_avg	
df_vf$away_Second_Quarter_Scoring_Differential <- z_away2_sorted$Second_Quarter_Score_avg - z_away2_sorted$Second_Quarter_Score_Allowed_avg
df_vf$away_Third_Quarter_Scoring_Differential <- z_away2_sorted$Third_Quarter_Score_avg - z_away2_sorted$Third_Quarter_Score_Allowed_avg	
df_vf$away_Fourth_Quarter_Scoring_Differential <- z_away2_sorted$Fourth_Quarter_Score_avg - z_away2_sorted$Fourth_Quarter_Score_Allowed_avg

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Scoring_Volatility=lag(sqrt(cumvar(First_Quarter_Score+Second_Quarter_Score+Third_Quarter_Score+Fourth_Quarter_Score)),k=1, default=0))	
df_vf$away_Scoring_Volatility <- z_away2_sorted$Scoring_Volatility

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Wasted_Possession_Volatility=lag(sqrt(cumvar(team_Total_FGA+team_Total_FT-team_Total_FGA-team_Total_FTA+team_Total_TOV)),k=1, default=0))
df_vf$away_Wasted_Possession_Volatility <- z_away2_sorted$Wasted_Possession_Volatility

#z_away2_sorted$team_Total_TOV		

z_away2_sorted <- z_away2_sorted %>% 
  group_by(season, team) %>%
  mutate(Defensive_Volatility=lag(sqrt(cumvar(First_Quarter_Score_Allowed+Second_Quarter_Score_Allowed+Third_Quarter_Score_Allowed+Fourth_Quarter_Score_Allowed-team_Total_STL-team_Total_BLK)),k=1, default=0))
df_vf$away_Defensive_Volatility <- z_away2_sorted$Defensive_Volatility

#points allowed - steal - block	
#for away team

write.csv(df_vf, "NBA_Final.csv", row.names = FALSE, na = "")
