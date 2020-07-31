
library(tidyverse)
library(rvest)
library(pbapply)
library(parallel)

stats_tr <- read.delim('teamranking_stats.csv', header = FALSE, sep = ',') %>%
  mutate(Stat_tr = gsub('https://www.teamrankings.com/nfl/stat/', '', V1,),
         Stat_tr = gsub('-', '_', Stat_tr),
         Web = V1) %>% select(-V1)

get_stat_web_date <- function(stat_name, web_name, date_scrap){
  df_aux <- paste0(web_name, '?date=', date_scrap) %>%
    read_html() %>% html_nodes('table') %>% html_table() %>% as.data.frame() %>%
    mutate_all(function(x){ifelse(x == '--', NA, x)}) %>%
    mutate(Date = date_scrap) %>% mutate_all(as.character) %>%
    filter(Team != "")
  colnames(df_aux) <- lapply(c('Rank', 'Team', 'CurrentSeason',
                               'Last3','Last1', 'Home', 'Away', 'PreviuosSeason', 'Date'),
                             function(x){ifelse(!x %in% c('Team', 'Date'), 
                                                paste(stat_name, x,
                                                      sep = '_'), 
                                                x)}) %>% unlist()
  return(df_aux)
}

get_all_stats_date <- function(stat_names, web_names, date_scrap){
  df_aux <- mapply(get_stat_web_date, stat_names, web_names, 
                     date_scrap = date_scrap, SIMPLIFY = FALSE) %>%
    reduce(full_join, by = c('Date', 'Team'))
  ind_col1 <- which(colnames(df_aux) == 'Date')
  ind_col2 <- which(colnames(df_aux) == 'Team')
  ind_col3 <- which(!colnames(df_aux) %in% c('Date', 'Team'))
  df_aux <- df_aux[, c(ind_col1, ind_col2, ind_col3)]
  return(df_aux)
}

if(!file.exists('teamrankings_success_dates.csv')){
  success_dates <- c()
  list_date <- seq(from = as.Date('2019-04-25', format = '%Y-%m-%d'),
                   to = Sys.Date(), 
                   by = 'day')
} else {
  success_dates <- read.csv('teamrankings_success_dates.csv', stringsAsFactors = FALSE) %>%
    .$x %>% as.Date(format = '%Y-%m-%d', origin = '1970-01-01')
  start_date <- max(min(success_dates)-60,
                    as.Date('2002-01-01',
                            format = '%Y-%m-%d',
                            origin = '1970-01-01'))
  list_date <- seq(from = start_date, to = Sys.Date(), by = 'day')
}

dw_list <- setdiff(list_date, success_dates) %>%
  as.Date(format = '%Y-%m-%d', origin = '1970-01-01')

if(length(dw_list) > 0){
  print('Scraping these dates:')
  print(dw_list)
  
  cl <- makeCluster(detectCores())
  clusterEvalQ(cl, {
    library(tidyverse)
    library(rvest)
  })
  clusterExport(cl, c('get_stat_web_date', 'get_all_stats_date'))
  
  list_df <- pblapply(dw_list, 
                      function(stat_names, web_names, date_scrap){
                        list(try_date = date_scrap,
                             try_df = try(get_all_stats_date(stat_names, web_names, date_scrap))
                             )}, 
                      stat_names = stats_tr$Stat_tr, web_names = stats_tr$Web,
                      cl = cl)
  stopCluster(cl = cl)
  
  ind_err <- 1:length(list_df) %>%
    lapply(function(x){class(list_df[[x]]$try_df) == 'try-error'}) %>%
    unlist()
  
  print(paste0('Success rate: ', round(100*mean(!ind_err),2), '%'))
  
  success_new_dates <- (1:length(list_df))[!ind_err] %>%
    lapply(function(x){list_df[[x]]$try_date}) %>% unlist() %>%
    as.Date(format = '%Y-%m-%d', origin = '1970-01-01')
  
  success_new_dates %>% union(success_dates) %>%
    as.Date(format = '%Y-%m-%d', origin = '1970-01-01') %>%
    write.csv('teamrankings_success_dates.csv', row.names = FALSE)
  
  df_tr <- (1:length(list_df))[!ind_err] %>%
    lapply(function(x){list_df[[x]]$try_df}) %>% 
    bind_rows()
  
  if(!file.exists('teamrankings_db.csv')){
    df_tr %>% write.csv(file = 'teamrankings_db.csv', row.names = FALSE)
  } else {
    df_tr %>% write.table(file = 'teamrankings_db.csv', sep = ',',
                          row.names = FALSE, col.names = FALSE,
                          append = TRUE)
  }
} else {
  print('No dates to scrape.')
}
