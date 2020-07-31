
df_scrape_task <- data.frame(season = numeric(), date = character())

if (!file.exists(FILENAME_GAMEURLS)) {
  df_scrape_task <- lapply(seasons, generate_dates_for_season) %>% bind_rows()
} else {
  game_urls <- read_csv(FILENAME_GAMEURLS, col_types = cols())
  seasons_checked <- unique(game_urls$season)
  new_seasons <- setdiff(seasons, seasons_checked)
  if (length(new_seasons) > 0) {
    df_scrape_task <- lapply(new_seasons, generate_dates_for_season) %>% bind_rows()
  }
  
  new_games_played <- game_urls %>% 
    filter(is.na(url) & date < Sys.Date()) %>% 
    mutate(date = str_to_lower(month.name[as.integer(format(date, "%m"))])) %>%
    select(season, date) %>% 
    distinct()
  if (nrow(new_games_played) > 0) {
    df_scrape_task <- rbind(df_scrape_task, new_games_played)
  }
  
  rm(game_urls, new_games_played)
}

df_extra_schedule <- data.frame(season = c(2020,2020,2020), date = c("july", "august", "september") )
df_scrape_task <- rbind(df_scrape_task, df_extra_schedule)

#df_scrape_task <- df_scrape_task %>% sample_n(100)

if (nrow(df_scrape_task) > 0) {
  print("Schedule: scrape started")
  cl <- makeCluster(detectCores())
  
  clusterEvalQ(cl, {
    library(rvest)
    library(tidyverse)
    library(pbapply)
    library(parallel)
  })
  
  clusterExport(cl,  c("BASE_URL", "get_game_urls_by_date", "get_payload", "get_month_schedule", "extract_game_date"))
  
  list_df <- pbapply(df_scrape_task, 1, function(date) {
    response <- list(
      try_season = date["season"],
      try_date = date["date"],
      try_df = try({
        urls <- get_game_urls_by_date(date)
        urls
      }) 
    )
    return(response)
  }, cl = cl)
  
  stopCluster(cl = cl)
  
  ind_err <- 1:length(list_df) %>% 
    lapply(function(x){
      df <- list_df[[x]]$try_df
      if (class(df) == 'try-error') {
        return(TRUE)
      } else {
        return(FALSE)
      }
    }) %>% unlist()
  
  success_rate <- round(100 * mean(!ind_err), 2)
  print(paste0('Success rate: ', success_rate, '%'))
  
  if(success_rate > 0) {
    df_tr <- (1:length(list_df))[!ind_err] %>%
      lapply(function(x) {
        l <- list_df[[x]]
        df <- l$try_df
        df$date <- df$date
        df$season <- as.numeric(l$try_season)
        df$game.id <- extract_game.id(df$url)
        df$home_team_id <- extract_team.id(df$home_team_url)
        df$away_team_id <- extract_team.id(df$visitor_team_url)
        df$key <- make_schedule.id(df$home_team_id, df$away_team_id, df$date)
        df
      }) %>% 
      bind_rows() %>%
      select(key, game.id, season, date, home_team_id, away_team_id, home_team, away_team, url)
    
    save_data(df_tr, filename = FILENAME_GAMEURLS, update_by_column = "key")
    rm(list_df, ind_err, success_rate, df_tr)
  }
  rm(cl, df_scrape_task)
  print("Schedule: scrape finished")
} else {
  rm(df_scrape_task)
  print("Schedule: nothing to scrape")
}








