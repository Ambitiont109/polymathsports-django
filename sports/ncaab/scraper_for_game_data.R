
df_scrape_task <- read_csv(FILENAME_GAMEURLS) %>% filter(date < Sys.Date() & !is.na(url))

if (file.exists(FILENAME_GAMELOGS)) {
  df_scrape_task <- df_scrape_task %>% filter(!game.id %in% (read_csv(FILENAME_GAMELOGS) %>% .$game.id %>% unique()) )
}

#df_scrape_task <- df_scrape_task %>% sample_n(100)

if (nrow(df_scrape_task) > 0) {
  
  cl <- makeCluster(detectCores())
  
  clusterEvalQ(cl, {
    library(rvest)
    library(tidyverse)
    library(pbapply)
    library(parallel)
    source("functions.R")
  })
  
  clusterExport(cl,  c("BASE_URL", "get_game_info", "get_payload"))

  list_df <- pbapply(df_scrape_task, 1, 
                     function(game) {
                       response <- list(
                         try_game = game["game.id"],
                         try_df = try({
                           game_url <- paste0(BASE_URL, game["url"])
                           payload <- get_payload(game_url)
                           data <- get_game_info(payload)
                           data$game.id <- game["game.id"]
                           data$key <- paste(game["game.id"], data$homeOrAway, sep = "-")
                           data <- data %>% select(key, game.id, everything())
                           data
                         }) 
                       )
                       return(response)
                     }, cl = cl)
  
  stopCluster(cl = cl)
  
  ind_err <- 1:length(list_df) %>% lapply(function(x){class(list_df[[x]]$try_df) == 'try-error'}) %>% unlist()
  success_rate <- round(100 * mean(!ind_err), 2)
  print(paste0('Success rate: ', success_rate, '%'))
  
  if (success_rate > 0) {
    df_tr <- (1:length(list_df))[!ind_err] %>%
      lapply(function(x){list_df[[x]]$try_df}) %>% 
      bind_rows()
    
    save_data(df_tr, FILENAME_GAMELOGS, update_by_column = "key")
    rm(cl, df_scrape_task, df_tr, list_df)
  }
  
} else {
  print("Nothing to scrape")
}