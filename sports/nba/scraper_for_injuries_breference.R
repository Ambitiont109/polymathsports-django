# save 1 per date

get_injuries_report <- function() {
  url <- "https://www.basketball-reference.com/friv/injuries.cgi"
  payload <- get_payload(url)
  df_injuries_report <- payload %>% html_nodes(xpath = '//table[@id="injuries"]') %>% html_table() %>% .[[1]]
  player_id <- payload %>% html_nodes(xpath = '//table[@id="injuries"]/tbody/tr/th/@data-append-csv') %>% html_text()
  df_injuries_report$player_id <- player_id
  df_injuries_report$date <- as.Date(format(Sys.time(), tz="EST")) # 
  #df_injuries_report$id <- paste0(df_injuries_report$addedAt, df_injuries_report$player_id)
  df_injuries_report$source <- "basketballreference"
  df_injuries_report <- df_injuries_report %>% select(player_id, everything())
  return(df_injuries_report)
}

df_injuries_report <- get_injuries_report()

save_data(df_injuries_report, filename = FILENAME_BASKETREF_INJURIES_REPORT_BY_DATE, "date")