# Date, Team, Salary on Court, Salary on Injury Report

calculate_salary <- function(df_salaries, season, team_, player_ids = c()) {
  team_salary <- df_salaries %>% filter(year == season & team == team_)
  
  if (length(player_ids) > 0) {
    team_salary <- team_salary %>% filter(!id %in% player_ids)
  }
  
  team_salary <- team_salary %>% 
    summarize(s = sum(salary)) %>% 
    .$s
  return(team_salary)
}

# -----------------------------------------------------------------------------------------------------

print("Salaries calculation: started")

df_salaries           <- read_csv(FILENAME_SALARIES, col_types = cols())
df_players_dictionary <- read_csv(FILENAME_PLAYERS_DICT, col_types = cols())
game_urls             <- read_csv(FILENAME_GAMEURLS, col_types = cols())

#game_urls <- game_urls %>% filter(date == "2020-01-25" | date == "2020-01-24" | date == "2020-01-23" | date == "2020-01-22" | date == "2020-01-21")
game_date <- NULL 

# combine injuries data (basketball-reference primary)
df_injuried_PROSPORT_by_date  <- read_csv(FILENAME_PROSPORT_INJURIES_BY_DATE, col_types = cols())
df_injuried_BASKETREF_by_date <- read_csv(FILENAME_BASKETREF_INJURIES_REPORT_BY_DATE, col_types = cols())

df_injuries_MASTER_by_date <- df_injuried_PROSPORT_by_date %>%
  anti_join(df_injuried_BASKETREF_by_date, by = "date") %>%
  left_join(df_players_dictionary, by = c("player" = "name_sporttransactions")) %>%
  select(date, id_basketball_reference, team, player, source) %>%
  bind_rows(df_injuried_BASKETREF_by_date %>% 
              rename(id_basketball_reference = player_id, team = Team, player = Player) %>%
              select(date, id_basketball_reference, team, player, source))
rm(df_injuried_PROSPORT_by_date, df_injuried_BASKETREF_by_date, df_players_dictionary)

# missing ids in the dictionary, must be added
missing_player_ids <- df_injuries_MASTER_by_date %>% 
  filter(is.na(id_basketball_reference)) %>% 
  select(team, player) %>% distinct() %>% arrange(player)

if (nrow(missing_player_ids) > 0) {
  print(missing_player_ids)
  write_csv(missing_player_ids, FILENAME_PLAYERS_DICT_MISSING_IDS)
  rm(missing_player_ids)
  stop("Players dictionary must be completed")
}else{
  # calculate salaries 
  # game.id df_injuried_by_date team date
  
  game_urls <- game_urls %>% filter(is.na(date) == FALSE & date <= TODAY)  
  
  if (file.exists(FILENAME_SALARIES_BY_GAMES)) {
    game_urls <- game_urls %>% 
      filter(!key %in% (read_csv(FILENAME_SALARIES_BY_GAMES, col_types = cols()) %>% .$key))
  }
 
  df <- pbapply(game_urls, 1, function(game) {
    if (is.null(game_date) || game_date != game["date"]) {
      injuried_player_ids <- df_injuries_MASTER_by_date %>%
        filter(date == game["date"]) %>%
        drop_na() %>%
        .$id_basketball_reference
    }
    
    gross_salary_hometeam     <- calculate_salary(df_salaries, game["season"], game["home_team_id"])
    salary_on_court_hometeam  <- calculate_salary(df_salaries, game["season"], game["home_team_id"], injuried_player_ids)
    salary_on_injury_hometeam <- gross_salary_hometeam - salary_on_court_hometeam
  
    gross_salary_awayteam     <- calculate_salary(df_salaries, game["season"], game["away_team_id"])
    salary_on_court_awayteam  <- calculate_salary(df_salaries, game["season"], game["away_team_id"], injuried_player_ids)
    salary_on_injury_awayteam <- gross_salary_awayteam - salary_on_court_awayteam
      
    res_list <- list(
      key = game["key"],
      date = as.Date(game["date"]),
      game.id = game["game.id"],
      home_team_id = game["home_team_id"],
      salary_on_court_hometeam  = salary_on_court_hometeam,
      salary_on_injury_hometeam = salary_on_injury_hometeam,
      away_team_id = game["away_team_id"],
      salary_on_court_awayteam  = salary_on_court_awayteam,
      salary_on_injury_awayteam = salary_on_injury_awayteam
    )
  
    return(res_list)
  }) %>% bind_rows()
  
  if (nrow(df) > 0) {
    save_data(df, FILENAME_SALARIES_BY_GAMES, "key")
  } else {
    print("Salaries calculation: no new data")
  }
  
  rm(df, game_urls, missing_player_ids, df_injuries_MASTER_by_date, df_salaries)
print("Salaries calculation: finished")
}