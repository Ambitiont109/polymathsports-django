#run once or twice a year

get_player_salaries <- function(url) {
  payload <- get_payload(url)
  
  tbl_salaries <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="salaries2"]') %>% .[[1]]
  
  tbl_rows <- tbl_salaries %>% html_nodes(xpath = './/tr') %>% .[-1]
  
  df <- lapply(tbl_rows, function(row) {
    player_id     <- row %>% html_nodes(xpath = './/td/@data-append-csv') %>% html_text()
    player_name   <- row %>% html_nodes(xpath = './/td[@data-stat="player"]') %>% html_text()
    player_salary <- row %>% html_nodes(xpath = './/td[@data-stat="salary"]/@csk') %>% html_text()
    
    if(length(player_id) == 0) {
      player_id <- make_player.id(player_name)
    }
    
    if(length(player_salary) == 0) {
      player_salary <- 0
    }
    
    l <- list(
      id     = player_id, 
      name   = player_name, 
      salary = as.numeric(player_salary)
    )
    return(l)
  }) %>% bind_rows()
  
  return(df)
}

scrap_player_salaries_by_season <- function(season) {
  #print(season)
  url <- sprintf("%s/leagues/NBA_%s_standings.html", BASE_URL, season)
  payload <- get_payload(url)
  
  team_urls <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="expanded_standings"]//td/a/@href') %>% 
    html_text()
  
  d <- lapply(team_urls, function(team_url) {
    url <- paste0(BASE_URL, team_url)
    df <- get_player_salaries(url)
    df$team <- extract_team.id(team_url)
    df$year <- as.numeric(extract_year(team_url))
    df$key  <- paste(df$year, df$id, sep = "-")
    return(df)
  }) %>% bind_rows()
  
  return(d)
}

if (!file.exists(FILENAME_SALARIES)) {
  df_scrape_task <- seasons
} else {
  df_scrape_task <- setdiff(seasons, read_csv(FILENAME_SALARIES, col_types = cols()) %>% .$year)
}

if (length(df_scrape_task) > 0) {
  print("Salaries data: scrape started")
  df_tr <- pblapply(seasons, scrap_player_salaries_by_season) %>% bind_rows()
  save_data(df_tr, FILENAME_SALARIES, update_by_column = "key")
  print("Salaries data: scrape finished")
}

