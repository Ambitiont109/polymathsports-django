
df_scrape_task <- data.frame(season = numeric(), date = character())

if (!file.exists(FILENAME_GAMEURLS)) {
  df_scrape_task <- lapply(seasons, generate_dates_for_season) %>% bind_rows()
} else {
  game_urls <- read_csv(FILENAME_GAMEURLS,
                        col_types = cols(
                          key = col_character(),
                          game.id = col_character(),
                          season = col_double(),
                          date = col_date(format = ""),
                          home_team = col_character(),
                          away_team = col_character(),
                          home_team_id = col_character(),
                          away_team_id = col_character(),
                          url = col_character()
                        ))
  seasons_checked <- unique(game_urls$season)
  new_seasons <- setdiff(seasons, seasons_checked)
  if (length(new_seasons) > 0) {
    df_scrape_task <- lapply(new_seasons, generate_dates_for_season) %>% bind_rows()
  }
  
  new_games_played <- game_urls %>% filter(is.na(url) & date < Sys.Date()) %>% select(season, date) %>% distinct()
  if (nrow(new_games_played) > 0) {
    df_scrape_task <- rbind(df_scrape_task, new_games_played)
  }
  
  rm(game_urls)
}

#df_scrape_task <- df_scrape_task %>% sample_n(100)

if (nrow(df_scrape_task) > 0) {
  cl <- makeCluster(detectCores())
  
  clusterEvalQ(cl, {
    library(rvest)
    library(tidyverse)
    library(pbapply)
    library(parallel)
  })
  
  clusterExport(cl,  c("BASE_URL", "get_game_urls_by_date", "get_payload", "extract_team.id", "transform_team_name_to_id"))
  
  list_df <- pbapply(df_scrape_task, 1, function(date) {
    response <- list(
      try_season = date["season"],
      try_date = date["date"],
      try_df = try({
        urls <- get_game_urls_by_date(date["date"])
        if (length(urls) == 0) {
          urls <- "no_games_this_day"
        }
        urls
      }) 
    )
    return(response)
  }, cl = cl)
  
  stopCluster(cl = cl)
  
  ind_err <- 1:length(list_df) %>% 
    lapply(function(x){
      df <- list_df[[x]]$try_df
      class(df) == 'try-error' || df == 'no_games_this_day'
    }) %>% unlist()
  
  success_rate <- round(100 * mean(!ind_err), 2)
  print(paste0('Success rate: ', success_rate, '%'))
  
  if(success_rate > 0) {
    df_tr <- (1:length(list_df))[!ind_err] %>%
      lapply(function(x) {
        l <- list_df[[x]]
        df <- l$try_df
        df$date <- as.Date(l$try_date)
        df$season <- as.numeric(l$try_season)
        df$game.id <- extract_game.id(df$url)
        df$key <- make_schedule.id(df$home_team, df$away_team, df$date)
        df
      }) %>% 
      bind_rows() %>%
      select(key, game.id, season, date, everything())
    
    save_data(df_tr, filename = FILENAME_GAMEURLS, update_by_column = "key")
    rm(df_scrape_task, list_df, ind_err, success_rate, df_tr)
  }
} else {
  print("Nothing to scrape")
}