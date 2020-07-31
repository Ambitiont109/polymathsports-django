#source("config.R")

#game_url <- "https://www.sports-reference.com/cbb/boxscores/2019-11-18-18-michigan-state.html"

#payload <- get_payload(game_url)

#https://www.sports-reference.com/cbb/boxscores/2019-11-23-19-coppin-state.html WITH OT
#https://www.sports-reference.com/cbb/boxscores/2019-11-23-19-pacific.html 3 OT

get_game_info <- function(payload) {
  
  date <- get_game_date(payload)
  location <- get_game_location(payload)
  
  team_names <- get_team_names(payload)
  team_ids <- get_team_ids(payload)
  
  scores_data <- get_scores_data(payload)
  scores_data$homeOrAway[1] <- "away"
  scores_data$homeOrAway[2] <- "home"
  scores_data$team_id <- ifelse(is.na(team_ids), transform_team_name_to_id(as.character(team_names)), team_ids)
  
  pace_data <- get_pace_data(payload)
  
  basic_score <- rbind(get_basic_score(payload, scores_data$team_id[1]), get_basic_score(payload, scores_data$team_id[2]))
  advanced_score <- rbind(get_advanced_score(payload, scores_data$team_id[1]), get_advanced_score(payload, scores_data$team_id[2]))
  
  game_info <- scores_data %>% 
    left_join(pace_data, by = "School") %>%
    left_join(basic_score, by = "team_id") %>%
    left_join(advanced_score, by = "team_id")
  
  game_info$Date <- date
  game_info$Location <- location
  
  return(game_info %>% select(School, team_id, homeOrAway, everything()))
}

get_scores_data <- function(payload) {
  line_score <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="line-score"]') %>%
    html_table() %>% .[[1]]
  
  names(line_score) <- as.character(line_score[1,])
  line_score <- line_score[-1,]
  names(line_score)[1] <- "School"
  line_score$First_Half_Score <- as.numeric(line_score$`1`)
  line_score$Second_Half_Score <- as.numeric(line_score$`2`)
  
  total_score <- as.numeric(line_score$`T`)
  line_score$OT_score <- total_score - line_score$`1` - line_score$`2`
  line_score$Total_Score <- total_score
  line_score <- line_score %>% select(School, First_Half_Score, Second_Half_Score, OT_score, Total_Score)
  
  return(line_score)
}

get_pace_data <- function(payload) {
  four_factors <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="four-factors"]') %>%
    html_table() %>% .[[1]]
  
  names(four_factors) <- as.character(four_factors[1,])
  four_factors <- four_factors[-1,]
  
  return(four_factors %>% select(School, Pace) %>% mutate(Pace = as.numeric(Pace)))
}

get_advanced_score <- function(payload, team_id) {
  
  advanced_score_stat_names <- c("TS%", "eFG%", "3PAr", "FTr", "ORB%", "DRB%", "TRB%", "AST%", "STL%", "BLK%", "TOV%", "ORtg", "DRtg")
  xpath <- sprintf('//table[@id="box-score-advanced-%s"]', team_id)
  
  box_score_advanced <-  payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = xpath)
  
  if(length(box_score_advanced) == 0) {
    box_score_advanced <-  payload %>% html_nodes(xpath = xpath)
  }
  
  box_score_advanced <- box_score_advanced %>% html_table() %>% .[[1]]
  
  names(box_score_advanced) <- as.character(box_score_advanced[1,])
  names(box_score_advanced)[1] <- "Player"
  #box_score_advanced %>% filter(Player == "School Totals")
  
  box_score_advanced <- box_score_advanced %>% 
    filter(Player == "School Totals") %>% 
    select(advanced_score_stat_names) %>%
    mutate_all(as.numeric) %>% 
    mutate(team_id = team_id) %>%
    select(team_id, everything())
  
  return(box_score_advanced)
}

get_basic_score <- function(payload, team_id) {
  
  basic_score_stat_names <- c("MP","FG","FGA","2P","2PA","3P","3PA","FT","FTA","ORB","DRB","TRB","AST","STL","BLK","TOV","PF","PTS")
  xpath <- sprintf('//table[@id="box-score-basic-%s"]', team_id)
  
  box_score_basic <-  payload %>%
    html_nodes(xpath = xpath) %>%
    html_table() %>% .[[1]]
  
  names(box_score_basic) <- as.character(box_score_basic[1,])
  names(box_score_basic)[1] <- "Player"
  
  idx <- match(c("Starters", "Reserves", "School Totals"), box_score_basic$Player ) 
  names(idx) <- c("Starters", "Reserves", "School Totals")
  idx <- as.list(idx)
  idx$Starters <- idx$Starters
  idx$Reserves <- idx$Reserves
  idx$`School Totals` <- idx$`School Totals`
  
  starters <- box_score_basic %>% 
    slice(idx$Starters:idx$Reserves) %>% 
    filter(!Player %in% names(idx)) %>% 
    select(basic_score_stat_names) %>% 
    mutate_all(as.numeric) %>% 
    summarise_each(funs(sum)) %>%
    rename_all(funs(paste("Starters", ., sep="_")))
  
  reserves <- box_score_basic %>% 
    slice(idx$Reserves:idx$`School Totals`) %>% 
    filter(!Player %in% names(idx)) 
  
  n <- nrow(reserves)
  
  reserves <- reserves %>% 
    select(basic_score_stat_names) %>% 
    mutate_all(as.numeric) %>%
    summarise_each(funs(sum)) %>%
    rename_all(funs(paste("Reserves", ., sep="_"))) %>%
    mutate(Reserves_Played = n)
  
  totals <- box_score_basic %>% 
    slice(idx$`School Totals`) %>% 
    select(basic_score_stat_names) %>%
    rename_all(funs(paste("School_Total", ., sep="_"))) %>%
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
    data <- read_csv(filename)
    data <- data %>% anti_join(data_new, by = update_by_column) 
    if (nrow(data) > 0) {
      data <- data %>% bind_rows(data_new)
      write_csv(data, filename)
    }
    rm(data, data_new)
  }
}
#---------------------------


#SCHEDULE TABLE
#schedule 
#Date 
#TEAM A
#TEAM B
#FINAL LINK



generate_dates_for_season <- function(season) {
  start_date <- as.Date(paste0(as.character(season - 1), "-11-01"))
  end_date   <- as.Date(paste0(as.character(season), "-04-01"))
  dates <- format(seq(start_date, end_date, by = 1), "%Y-%m-%d")
  df <- data.frame(date = dates, stringsAsFactors = FALSE)
  df$date <- as.Date(df$date)
  df$season <- season
  return(df)
}

get_game_urls_by_date <- function(date) { # "%Y-%m-%d"
  year  <- format(as.Date(date),"%Y")
  month <- format(as.Date(date),"%m")
  day   <- format(as.Date(date),"%d")
  url <- sprintf("%s/cbb/boxscores/index.cgi?month=%s&day=%s&year=%s", BASE_URL, month, day, year)
  
  payload <- get_payload(url)
  
  team_nodes <- payload %>%
    html_nodes(xpath = "//table[contains(@class,'teams')]")
  
  df <- lapply(team_nodes, function(team_node){
    
    home_team <- team_node %>% html_node(xpath = ".//tr[2]/td[1]/a") %>% html_text()
    away_team <- team_node %>% html_node(xpath = ".//tr[1]/td[1]/a") %>% html_text()
    
    home_team_id <- extract_team.id(team_node %>% html_node(xpath = ".//tr[2]/td[1]/a/@href") %>% html_text())
    away_team_id <- extract_team.id(team_node %>% html_node(xpath = ".//tr[1]/td[1]/a/@href") %>% html_text())
    
    home_team_id <- ifelse(is.na(home_team_id), transform_team_name_to_id(as.character(home_team)), home_team_id)
    away_team_id <- ifelse(is.na(away_team_id), transform_team_name_to_id(as.character(away_team)), away_team_id)
    
    game <- list(
      home_team = home_team,
      away_team = away_team,
      home_team_id = home_team_id,
      away_team_id = away_team_id,
      url = team_node %>% html_node(xpath = ".//td[contains(@class,'gamelink')]/a/@href") %>% html_text()
    )
  }) %>% bind_rows()
  
  return(df)
}

extract_game.id <- function(str) {
  return(gsub("/cbb/boxscores/(.+).html", "\\1", str))
}

extract_team.id <- function(str) {
  return(gsub("/cbb/schools/(.+)/.+.html", "\\1", str))
}

make_schedule.id <- function(team1, team2, date) {
  return(paste(substr(str_to_lower(gsub(" ", "-", team1)), 1, 3), substr(str_to_lower(gsub(" ", "-", team2)), 1, 3), date, sep = "-"))
}


# https://www.sports-reference.com/cbb/boxscores/index.cgi?month=11&day=23&year=2019
#extract TEam A
#extract TEam B
#FINAL LINK



#//table[@class="teams"]/tbody/tr[2]/td/a/@href
# extract team name

#game_url <- "https://www.sports-reference.com/cbb/boxscores/2019-11-18-18-michigan-state.html"

#payload <- get_payload(game_url)

#https://www.sports-reference.com/cbb/boxscores/2019-11-23-19-coppin-state.html WITH OT
#https://www.sports-reference.com/cbb/boxscores/2019-11-23-19-pacific.html 3 OT

get_game_info <- function(payload) {
  
  date <- get_game_date(payload)
  location <- get_game_location(payload)
  
  team_names <- get_team_names(payload)
  team_ids <- get_team_ids(payload)
  
  scores_data <- get_scores_data(payload)
  scores_data$homeOrAway[1] <- "away"
  scores_data$homeOrAway[2] <- "home"
  scores_data$team_id <- ifelse(is.na(team_ids), transform_team_name_to_id(as.character(team_names)), team_ids)
  
  pace_data <- get_pace_data(payload)
  
  basic_score <- rbind(get_basic_score(payload, scores_data$team_id[1]), get_basic_score(payload, scores_data$team_id[2]))
  advanced_score <- rbind(get_advanced_score(payload, scores_data$team_id[1]), get_advanced_score(payload, scores_data$team_id[2]))
  
  game_info <- scores_data %>% 
    left_join(pace_data, by = "School") %>%
    left_join(basic_score, by = "team_id") %>%
    left_join(advanced_score, by = "team_id")
  
  game_info$Date <- date
  game_info$Location <- location
  
  return(game_info %>% select(School, team_id, homeOrAway, everything()))
}

get_scores_data <- function(payload) {
  line_score <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="line-score"]') %>%
    html_table() %>% .[[1]]
  
    names(line_score) <- as.character(line_score[1,])
    line_score <- line_score[-1,]
    names(line_score)[1] <- "School"
    line_score$First_Half_Score <- as.numeric(line_score$`1`)
    line_score$Second_Half_Score <- as.numeric(line_score$`2`)
    
    total_score <- as.numeric(line_score$`T`)
    line_score$OT_score <- total_score - line_score$`1` - line_score$`2`
    line_score$Total_Score <- total_score
    line_score <- line_score %>% select(School, First_Half_Score, Second_Half_Score, OT_score, Total_Score)
    
  return(line_score)
}

get_pace_data <- function(payload) {
  four_factors <- payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = '//table[@id="four-factors"]') %>%
    html_table() %>% .[[1]]
  
  names(four_factors) <- as.character(four_factors[1,])
  four_factors <- four_factors[-1,]
  
  return(four_factors %>% select(School, Pace) %>% mutate(Pace = as.numeric(Pace)))
}

get_advanced_score <- function(payload, team_id) {
  
  advanced_score_stat_names <- c("TS%", "eFG%", "3PAr", "FTr", "ORB%", "DRB%", "TRB%", "AST%", "STL%", "BLK%", "TOV%", "ORtg", "DRtg")
  xpath <- sprintf('//table[@id="box-score-advanced-%s"]', team_id)
  
  box_score_advanced <-  payload %>%
    html_nodes(xpath = '//comment()') %>%
    html_text() %>%
    paste(collapse = '') %>% 
    read_html() %>%
    html_nodes(xpath = xpath)
  
  if(length(box_score_advanced) == 0) {
    box_score_advanced <-  payload %>% html_nodes(xpath = xpath)
  }
  
  box_score_advanced <- box_score_advanced %>% html_table() %>% .[[1]]
  
  names(box_score_advanced) <- as.character(box_score_advanced[1,])
  names(box_score_advanced)[1] <- "Player"
  #box_score_advanced %>% filter(Player == "School Totals")
  
  box_score_advanced <- box_score_advanced %>% 
    filter(Player == "School Totals") %>% 
    select(advanced_score_stat_names) %>%
    mutate_all(as.numeric) %>% 
    mutate(team_id = team_id) %>%
    select(team_id, everything())
  
  return(box_score_advanced)
}

get_basic_score <- function(payload, team_id) {
    
    basic_score_stat_names <- c("MP","FG","FGA","2P","2PA","3P","3PA","FT","FTA","ORB","DRB","TRB","AST","STL","BLK","TOV","PF","PTS")
    xpath <- sprintf('//table[@id="box-score-basic-%s"]', team_id)
  
    box_score_basic <-  payload %>%
      html_nodes(xpath = xpath) %>%
      html_table() %>% .[[1]]
    
    names(box_score_basic) <- as.character(box_score_basic[1,])
    names(box_score_basic)[1] <- "Player"
    
    idx <- match(c("Starters", "Reserves", "School Totals"), box_score_basic$Player ) 
    names(idx) <- c("Starters", "Reserves", "School Totals")
    idx <- as.list(idx)
    idx$Starters <- idx$Starters
    idx$Reserves <- idx$Reserves
    idx$`School Totals` <- idx$`School Totals`
    
    starters <- box_score_basic %>% 
      slice(idx$Starters:idx$Reserves) %>% 
      filter(!Player %in% names(idx)) %>% 
      select(basic_score_stat_names) %>% 
      mutate_all(as.numeric) %>% 
      summarise_each(funs(sum)) %>%
      rename_all(funs(paste("Starters", ., sep="_")))
    
    reserves <- box_score_basic %>% 
      slice(idx$Reserves:idx$`School Totals`) %>% 
      filter(!Player %in% names(idx)) 
    
    n <- nrow(reserves)
    
    reserves <- reserves %>% 
      select(basic_score_stat_names) %>% 
      mutate_all(as.numeric) %>%
      summarise_each(funs(sum)) %>%
      rename_all(funs(paste("Reserves", ., sep="_"))) %>%
      mutate(Reserves_Played = n)
    
    totals <- box_score_basic %>% 
      slice(idx$`School Totals`) %>% 
      select(basic_score_stat_names) %>%
      rename_all(funs(paste("School_Total", ., sep="_"))) %>%
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
    data <- read_csv(filename)
    data <- data %>% anti_join(data_new, by = update_by_column) 
    if (nrow(data) > 0) {
      data <- data %>% bind_rows(data_new)
      write_csv(data, filename)
    }
    rm(data, data_new)
  }
}
#---------------------------


#SCHEDULE TABLE
#schedule 
#Date 
#TEAM A
#TEAM B
#FINAL LINK



generate_dates_for_season <- function(season) {
  start_date <- as.Date(paste0(as.character(season - 1), "-11-01"))
  end_date   <- as.Date(paste0(as.character(season), "-04-01"))
  dates <- format(seq(start_date, end_date, by = 1), "%Y-%m-%d")
  df <- data.frame(date = dates, stringsAsFactors = FALSE)
  df$date <- as.Date(df$date)
  df$season <- season
  return(df)
}

get_game_urls_by_date <- function(date) { # "%Y-%m-%d"
  year  <- format(as.Date(date),"%Y")
  month <- format(as.Date(date),"%m")
  day   <- format(as.Date(date),"%d")
  url <- sprintf("%s/cbb/boxscores/index.cgi?month=%s&day=%s&year=%s", BASE_URL, month, day, year)
  
  payload <- get_payload(url)

  team_nodes <- payload %>%
    html_nodes(xpath = "//table[contains(@class,'teams')]")
  
  df <- lapply(team_nodes, function(team_node){
    
    home_team <- team_node %>% html_node(xpath = ".//tr[2]/td[1]/a") %>% html_text()
    away_team <- team_node %>% html_node(xpath = ".//tr[1]/td[1]/a") %>% html_text()
    
    home_team_id <- extract_team.id(team_node %>% html_node(xpath = ".//tr[2]/td[1]/a/@href") %>% html_text())
    away_team_id <- extract_team.id(team_node %>% html_node(xpath = ".//tr[1]/td[1]/a/@href") %>% html_text())
    
    home_team_id <- ifelse(is.na(home_team_id), transform_team_name_to_id(as.character(home_team)), home_team_id)
    away_team_id <- ifelse(is.na(away_team_id), transform_team_name_to_id(as.character(away_team)), away_team_id)

    game <- list(
      home_team = home_team,
      away_team = away_team,
      home_team_id = home_team_id,
      away_team_id = away_team_id,
      url = team_node %>% html_node(xpath = ".//td[contains(@class,'gamelink')]/a/@href") %>% html_text()
    )
  }) %>% bind_rows()
  
  return(df)
}

extract_game.id <- function(str) {
  return(gsub("/cbb/boxscores/(.+).html", "\\1", str))
}

extract_team.id <- function(str) {
  return(gsub("/cbb/schools/(.+)/.+.html", "\\1", str))
}

make_schedule.id <- function(team1, team2, date) {
  return(paste(substr(str_to_lower(gsub(" ", "-", team1)), 1, 3), substr(str_to_lower(gsub(" ", "-", team2)), 1, 3), date, sep = "-"))
}


# https://www.sports-reference.com/cbb/boxscores/index.cgi?month=11&day=23&year=2019
#extract TEam A
#extract TEam B
#FINAL LINK



#//table[@class="teams"]/tbody/tr[2]/td/a/@href
# extract team name