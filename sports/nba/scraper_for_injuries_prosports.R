
get_injuries_table <- function(payload) {
  data_raw <- payload %>%
    html_nodes(xpath = "//table[@class='datatable center']") %>%
    html_table()
  return(data_raw)
}
get_urls_for_period <- function(start_date, end_date, cl) {
  request_params <- sprintf("SearchResults.php?BeginDate=%s&EndDate=%s&ILChkBx=yes&Submit=Search", start_date, end_date)
  
  url <- paste0(BASE_PROSPORT, request_params)
  payload <- get_payload(url)
  
  urls <- payload %>%
    html_nodes(xpath = "//table[2]//td[position()=3]/p/a/@href") %>%
    html_text() 
  
  urls <- c(request_params, urls)
  return(urls)  
}

if (file.exists(FILENAME_PROSPORT_INJURIES_RAW)) {
  start_date <- read_csv(FILENAME_PROSPORT_INJURIES_RAW, col_types = cols()) %>% .$Date %>% max(.) + 1
}

end_date <- TODAY

urls <- get_urls_for_period(start_date, end_date)

if (length(urls) > 0) {
  print("Injuries prosport data: scrape started")
  list_df <- pblapply(urls, function(url) {
    response <- list(
      try_url = url,
      try_df = try({
        url <- paste0(BASE_PROSPORT, url)
        payload <- get_payload(url)
        data_raw <- get_injuries_table(payload)
        if (length(data_raw) > 0) {
          data_raw <- data_raw[[1]][-1,]
        } 
        data_raw
      })
    )
    return(response)
  })
  
  rm(urls)
  
  # clusters do not work with prosports
  ind_err <- 1:length(list_df) %>% lapply(function(x){class(list_df[[x]]$try_df) == 'try-error'}) %>% unlist()
  success_rate <- round(100 * mean(!ind_err), 2)
  print(paste0('Success rate: ', success_rate, '%'))
  
  if (success_rate > 0) {
    df_tr <- (1:length(list_df))[!ind_err] %>%
      lapply(function(x){list_df[[x]]$try_df}) %>% 
      bind_rows()
    
    if (nrow(df_tr) > 0) {
      names(df_tr) <- c("Date", "Team", "Acquired", "Relinquished", "Notes")
      df_tr <- df_tr %>%
        mutate(Acquired = trimws(substring(Acquired, 3))) %>% 
        mutate(Relinquished = trimws(substring(Relinquished, 3))) %>%
        mutate(key = paste(Date, Team, Acquired, Relinquished, sep = "-")) %>%
        mutate(Date = as.Date(Date)) %>%
        select(key, everything())
      
      save_data(df_tr, FILENAME_PROSPORT_INJURIES_RAW, update_by_column = "key")
      
      
      # ------------------------------------------------------------------- 
      # calculate lists of injuried for each date
      
      injuried_players_by_date <- data.frame(date = character(), team = character(), player = character(), stringsAsFactors = FALSE)
      
      if (file.exists(FILENAME_PROSPORT_INJURIES_BY_DATE)) {
        latest_date <- read_csv(FILENAME_PROSPORT_INJURIES_BY_DATE, col_types = cols()) %>% .$date %>% max(.)
        injuried_players_stack <- read_csv(FILENAME_PROSPORT_INJURIES_BY_DATE, col_types = cols()) %>% 
          filter(date == latest_date) %>% 
          select(team, player)
        data_injuries <- read_csv(FILENAME_PROSPORT_INJURIES_RAW, col_types = cols()) %>% filter(Date > latest_date)
      } else {
        data_injuries <- df_tr
        injuried_players_stack <- data.frame(team = character(), player = character(), stringsAsFactors = FALSE) 
      }
      
      dates <- as.Date(unique(data_injuries$Date))
      dates <- dates[order(dates)]
      dates <- as.character(dates)
      
      for (day in dates) {
        data_daily <- data_injuries %>% filter(Date == day)
        data_daily_placed    <- data_daily %>% filter(Relinquished != "") %>% select(Team, Relinquished) %>% rename(team = Team, player = Relinquished)
        data_daily_activated <- data_daily %>% filter(Acquired != "") %>% select(Team, Acquired) %>% rename(team = Team, player = Acquired)
        
        injuried_players_stack <- rbind(injuried_players_stack, data_daily_placed) %>% distinct() 
        injuried_players_stack <- injuried_players_stack %>% anti_join(data_daily_activated, by = "player")
        
        injuried_players_on_date <- injuried_players_stack %>% 
          mutate(date = rep(day, nrow(injuried_players_stack))) %>% 
          select(date, team, player)
        
        # remove retired players or other who does not play for a year or more
        injuried_players_by_date <- rbind(injuried_players_by_date, injuried_players_on_date)
        
      }
      
      injuried_players_by_date$source <- "prosporttransactions"
      
      injuried_players_by_date <- injuried_players_by_date %>% 
        mutate(key = paste(date, team, player, sep = "-")) %>%
        mutate(date = as.Date(date)) %>%
        select(key, everything())
      
      save_data(injuried_players_by_date, FILENAME_PROSPORT_INJURIES_BY_DATE, "key")
      
      rm(df_tr, list_df)
      print("Injuries prosport data: scrape finished")
    } else {
      rm(df_tr, list_df)
      print("Injuries prosport data: No new data on prosportstranscations resource")
    }
    
  }
}



