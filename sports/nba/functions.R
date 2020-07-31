
get_game_info <- function(payload) {
  
  date <- get_game_date(payload)
  location <- get_game_location(payload)
  
  team_names <- get_team_names(payload)
  team_ids <- get_team_ids(payload)
  
  scores_data <- get_scores_data(payload)
  scores_data$homeOrAway[1] <- "away"
  scores_data$homeOrAway[2] <- "home"
  #scores_data$Team <- ifelse(is.na(team_ids), transform_team_name_to_id(as.character(team_names)), team_ids)
  
  pace_data <- get_pace_data(payload)
  
  basic_score <- rbind(get_basic_score(payload, scores_data$team_id[1]), get_basic_score(payload, scores_data$team_id[2]))
  advanced_score <- rbind(get_advanced_score(payload, scores_data$team_id[1]), get_advanced_score(payload, scores_data$team_id[2]))
  
  game_info <- scores_data %>% 
    left_join(pace_data, by = "team_id") %>%
    left_join(basic_score, by = "team_id") %>%
    left_join(advanced_score, by = "team_id")
  
  game_info$Date <- date
  game_info$Location <- location
  
  return(game_info %>% select(team_id, homeOrAway, everything()))
}

get_scores_data <- function(payload) {
  line_score <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="line_score"]') %>%
    html_table() %>% .[[1]]
  
    names(line_score) <- as.character(line_score[1,])
    line_score <- line_score[-1,]
    names(line_score)[1] <- "team_id"
    line_score$First_Quarter_Score <- as.numeric(line_score$`1`)
    line_score$Second_Quarter_Score <- as.numeric(line_score$`2`)
    line_score$Third_Quarter_Score <- as.numeric(line_score$`3`)
    line_score$Fourth_Quarter_Score <- as.numeric(line_score$`4`)
    
    total_score <- as.numeric(line_score$`T`)
    line_score$OT_score <- total_score - line_score$`1` - line_score$`2` - line_score$`3` - line_score$`4`
    line_score$Total_Score <- total_score
    line_score <- line_score %>% select(team_id, First_Quarter_Score, Second_Quarter_Score, Third_Quarter_Score, Fourth_Quarter_Score, OT_score, Total_Score)
    
  return(line_score)
}

get_pace_data <- function(payload) {
  four_factors <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="four_factors"]') %>%
    html_table() %>% .[[1]]
  
  names(four_factors) <- as.character(four_factors[1,])
  names(four_factors)[1] <- "team_id"
  four_factors <- four_factors[-1,]
  
  return(four_factors %>% select(team_id, Pace) %>% mutate(Pace = as.numeric(Pace)))
}

get_advanced_score <- function(payload, team_id) {
  
  advanced_score_stat_names <- c("TS%", "eFG%", "3PAr", "FTr", "ORB%", "DRB%", "TRB%", "AST%", "STL%", "BLK%", "TOV%", "ORtg", "DRtg")
  xpath <- sprintf('//table[@id="box-%s-game-advanced"]', team_id)
                                 
  box_score_advanced <-  payload %>%
    html_nodes(xpath = xpath) %>%
    html_table() %>% .[[1]]
  
  names(box_score_advanced) <- as.character(box_score_advanced[1,])
  names(box_score_advanced)[1] <- "Player"
  #box_score_advanced %>% filter(Player == "School Totals")
  
  box_score_advanced <- box_score_advanced %>% 
    filter(Player == "Team Totals") %>% 
    select(advanced_score_stat_names) %>%
    mutate_all(as.numeric) %>% 
    mutate(team_id = team_id) %>%
    select(team_id, everything())
  
  return(box_score_advanced)
}

get_basic_score <- function(payload, team_id) {
    
    basic_score_stat_names <- c("MP","FG","FGA","3P","3PA","FT","FTA","ORB","DRB","TRB","AST","STL","BLK","TOV","PF","PTS")
    xpath <- sprintf('//table[@id="box-%s-game-basic"]', team_id)
                                   
    box_score_basic <-  payload %>%
      html_nodes(xpath = xpath) %>%
      html_table() %>% .[[1]]
    
    names(box_score_basic) <- as.character(box_score_basic[1,])
    names(box_score_basic)[1] <- "Player"
    
    idx <- match(c("Starters", "Reserves", "Team Totals"), box_score_basic$Player ) 
    names(idx) <- c("Starters", "Reserves", "Team Totals")
    idx <- as.list(idx)
    idx$Starters <- idx$Starters
    idx$Reserves <- idx$Reserves
    idx$`Team Totals` <- idx$`Team Totals`
    
    box_score_basic <- box_score_basic %>% mutate(MP = transform_mp(MP))
    
    starters <- box_score_basic %>% 
      slice(idx$Starters:idx$Reserves) %>% 
      filter(!Player %in% names(idx)) %>% 
      select(basic_score_stat_names) %>% 
      mutate_all(as.numeric) %>% 
      summarise_each(funs(sum(., na.rm = TRUE))) %>%
      rename_all(funs(paste("Starters", ., sep="_")))
    
    reserves <- box_score_basic %>% 
      slice(idx$Reserves:idx$`Team Totals`) %>% 
      filter(!Player %in% names(idx)) 
    
    n <- nrow(reserves)
    
    reserves <- reserves %>% 
      select(basic_score_stat_names) %>% 
      mutate_all(as.numeric) %>%
      summarise_each(funs(sum(., na.rm = TRUE))) %>%
      rename_all(funs(paste("Reserves", ., sep="_"))) %>%
      mutate(Reserves_Played = n)
    
    totals <- box_score_basic %>% 
      slice(idx$`Team Totals`) %>% 
      select(basic_score_stat_names) %>%
      rename_all(funs(paste("Team_Total", ., sep="_"))) %>%
      mutate_all(as.numeric) %>% 
      mutate(team_id = team_id) %>%
      select(team_id, everything())
    
    basic_score <- cbind(starters, reserves, totals) %>% select(team_id, everything())
    
    return(basic_score)
}

get_team_names <- function(payload){
  names <-  payload %>%
    html_nodes(xpath = "//div[@itemprop='performer']/*/a[contains(@itemprop,'name')]") %>%
    html_text()
  return(names)
}

get_team_ids <- function(payload){
  divs <-  payload %>%
    html_nodes(xpath = "//div[@itemprop='performer']")
  
  away_team <- divs[1] %>% html_node(xpath = ".//a[contains(@itemprop,'name')]/@href") %>% html_text()
  home_team <- divs[2] %>% html_node(xpath = ".//a[contains(@itemprop,'name')]/@href") %>% html_text()
  
  away_team <- ifelse(is.na(away_team), NA, extract_team.id(away_team))
  home_team <- ifelse(is.na(home_team), NA, extract_team.id(home_team))
  
  return(c(away_team, home_team))
}

transform_team_name_to_id <- function(name) {
  name <- gsub(" ","-", name)
  name <- gsub("'","", name)
  id <- str_to_lower(name)
  return(id)
}

get_game_date <- function(payload) {
  date <-  payload %>%
    html_nodes(xpath = "//div[@class='scorebox_meta']/div[1]") %>%
    html_text()
  return(date)
  
}

get_game_location <- function(payload) {
  location <-  payload %>%
    html_nodes(xpath = "//div[@class='scorebox_meta']/div[2]") %>%
    html_text()
  return(location)
}

get_payload <- function(url) {
  return(read_html(url))
}

save_data <- function(data_new, filename, update_by_column = "id") {
  if (!file.exists(filename)) {
    data_new %>% write_csv(path = filename)
  } else {
    data <- read_csv(filename, col_types = cols())
    data <- data %>% anti_join(data_new, by = update_by_column) 
    if (nrow(data) > 0) {
      data <- data %>% bind_rows(data_new)
      write_csv(data, filename)
    }
    rm(data, data_new)
  }
}
#------------------------------------------------------------------------------------------------------



scrap_urls_for_season <- function(season) {
  url_for_season <- sprintf("%s/leagues/NBA_%s_games.html", BASE_URL, season)
  payload <- get_payload(url_for_season)
  df <- get_urls_for_season_months(payload) 
  df$season <- season
  return(df)
}

get_urls_for_season_months <- function(payload) {
  url_nodes <- payload %>% html_nodes(xpath = "//div[@class='filter']/div/a")
  df <- lapply(url_nodes, function(node) {
          l <- list( 
                url = node %>% html_node(xpath = "./@href") %>% html_text(),
                month = node %>% html_node(xpath = "./text()") %>% html_text()
              )
          
          return(l)
        }
      ) %>% bind_rows()
  return(df)
}


get_game_urls_by_date <- function(date) {
  url <- sprintf("%s/leagues/NBA_%s_games-%s.html", BASE_URL, date["season"], date["date"])
  df <- get_month_schedule(url)
  print(url)
  return(df)
}

get_month_schedule <- function(month_url) {
  payload <- get_payload(month_url)
  
  schedule_table_nodes <- payload %>%
    html_nodes(xpath = "//table[@id='schedule']/tbody/tr")
  
  date_game_url = schedule_table_nodes %>%  html_node(xpath = ".//th[@data-stat='date_game']/a/@href") %>% html_text()
  
  home_team_url     <- schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='home_team_name']/a/@href") %>% html_text()
  visitor_team_url  <- schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='visitor_team_name']/a/@href") %>% html_text()

  df <- list(
    date = extract_game_date(date_game_url),
    game_start_time = schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='game_start_time']") %>% html_text(),
    home_team         = schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='home_team_name']") %>% html_text(),
    away_team         = schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='visitor_team_name']") %>% html_text(),
    home_team_url     = schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='home_team_name']/a/@href") %>% html_text(),
    visitor_team_url  = schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='visitor_team_name']/a/@href") %>% html_text(),
    url               = schedule_table_nodes %>%  html_node(xpath = ".//td[@data-stat='box_score_text']/a/@href") %>% html_text()
  ) %>% bind_rows()
  

  return(df)
}

extract_game_date <- function(url) {
  
  month <- gsub(".+month=(\\d+).+", "\\1", url)
  day <- gsub(".+day=(\\d+).+", "\\1", url)
  year <- gsub(".+year=(\\d+)", "\\1", url)

  return(as.Date(paste(year, month, day, sep = '-')))
}


generate_dates_for_season <- function(season) {
  months <- month.name[c(10,11,12,1,2,3,4,5,6,7,8,9)]
  df <- data.frame(date = months, stringsAsFactors = FALSE)
  df$date <- str_to_lower(months)
  df$season <- season
  return(df)
}

extract_game.id <- function(str) {
  return(gsub("/boxscores/(.+).html", "\\1", str))
}

extract_team.id <- function(str) {
  return(gsub("/teams/(.+)/.+.html", "\\1", str))
}

extract_year <- function(str) {
  return(gsub("/teams/(.+)/(.+).html", "\\2", str))
}

make_schedule.id <- function(team1, team2, date) {
  return(paste(substr(str_to_lower(gsub(" ", "-", team1)), 1, 3), substr(str_to_lower(gsub(" ", "-", team2)), 1, 3), date, sep = "-"))
}

make_player.id <- function(name) {
  return(str_to_lower(gsub(" ", "-", name)))
}

transform_mp <- function(str) {
  MP_minutes = as.numeric(gsub("(\\d{1,2}):(\\d{1,2})", "\\1", str))
  MP_sec = as.numeric(gsub("(\\d{1,2}):(\\d{1,2})", "\\2", str))
  return(MP_minutes + MP_sec / 60)
}
