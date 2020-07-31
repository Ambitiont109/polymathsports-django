library(tidyverse)
library(rvest)
library(pbapply)
library(parallel)


collect_raw_weather_data <- function(zip, date) {
  year <- as.character(format(as.Date(date, "%Y-%m-%d"), "%Y"))
  month <- as.character(format(as.Date(date, "%Y-%m-%d"), "%m"))
  day <- as.character(format(as.Date(date, "%Y-%m-%d"), "%d"))

  resource <- paste("https://www.farmersalmanac.com/weather-history",
                    zip, year, month, day, sep = "/")

  table <- resource %>%
    read_html() %>%
    html_node("table.wx-results-table") %>%
    html_table() %>%
    as.data.frame()
  table <- table[-nrow(table), ]
  table$date <- as.character(date)
  table$zip <- zip

  return(table)
}

zipcodes <- read.csv("team_timezones.csv",
                     stringsAsFactors = FALSE,
                     colClasses = c("ZIPCODE" = "character")) %>%
  as_tibble() %>%
  select("ZIPCODE") %>%
  distinct()

data_to_parse <- read.csv("NCAAF_Final.csv", stringsAsFactors = FALSE,
                          colClasses = c("Home_ZIPCODE" = "character")) %>%
  as_tibble() %>%
  mutate(Date = format(as.Date(Date, tryFormats = c("%m/%d/%y", "%Y-%m-%d"),
                               origin = "1970-01-01"), "%Y-%m-%d")) %>%
  mutate(Home_ZIPCODE = ifelse(Home_ZIPCODE == "2467", "02467", Home_ZIPCODE)) %>%
  mutate(Home_ZIPCODE = ifelse(Home_ZIPCODE == "6457", "06457", Home_ZIPCODE)) %>%
  mutate(Home_ZIPCODE = ifelse(Home_ZIPCODE == "8854", "08854", Home_ZIPCODE)) %>%
  mutate(Home_ZIPCODE = ifelse(Home_ZIPCODE == "1003", "01003", Home_ZIPCODE)) %>%
  mutate(Home_ZIPCODE = ifelse(Home_ZIPCODE == "7073", "07073", Home_ZIPCODE)) %>%
  mutate(Home_ZIPCODE = ifelse(Home_ZIPCODE == "2035", "02035", Home_ZIPCODE)) %>%
  select(Date, Home_ZIPCODE) %>%
  filter(Date < Sys.time()) %>%
  filter(Home_ZIPCODE != "") %>%
  distinct()



if (!file.exists("weather_success_dates_and_zips.csv")) {
  success_dates_and_zips <- data.frame(date = character(),
                                       zip = character(),
                                       stringsAsFactors = FALSE)
} else {
  success_dates_and_zips <- read.csv("weather_success_dates_and_zips.csv",
                                     stringsAsFactors = FALSE,
                                     colClasses = c("date" = "character",
                                                    "zip" = "character")) %>%
    as_tibble() %>%
    distinct()
}

dw_list <- anti_join(data_to_parse, success_dates_and_zips,
                     by = c("Date" = "date", "Home_ZIPCODE" = "zip")) %>%
  rename("date" = "Date") %>%
  rename("zip" = "Home_ZIPCODE")
# dw_list <- dw_list[1:100,]

if (length(dw_list) > 0) {
  print("Scraping these dates:")
  print(dw_list)

  cl <- makeCluster(detectCores())
  clusterEvalQ(cl, {
    library(tidyverse)
    library(rvest)
  })
  clusterExport(cl, c("collect_raw_weather_data"))

  list_df <- pbapply(dw_list, 1,
                     function(n) {
                       list(
                         try_date = n["date"],
                         try_zip = n["zip"],
                         try_df = try(collect_raw_weather_data(n["zip"], n["date"]))
                       )
                     },
                     cl = cl
  )
  stopCluster(cl = cl)

  ind_err <- 1:length(list_df) %>%
    lapply(function(x) {class(list_df[[x]]$try_df) == "try-error"}) %>%
    unlist()
  success_rate <- round(100 * mean(!ind_err), 2)
  print(paste0("Success rate: ", success_rate, "%"))

  if (success_rate > 0) {
    df_tr <- (1:length(list_df))[!ind_err] %>%
      lapply(function(x) {list_df[[x]]$try_df}) %>%
      bind_rows() %>%
      # transform
      mutate(name = gsub(":", "", X1)) %>%
      mutate(name = gsub(" ", "_", name)) %>%
      mutate(name = tolower(name)) %>%
      mutate(value = ifelse(X1 != "Observations:",
                            as.numeric(str_extract(X2, "^\\d*\\.?\\d*")), X2)) %>%
      select(c("date", "zip", "name", "value")) %>%
      as_tibble()

    # log success parse
    success_new_dates <- df_tr[, 1:2] %>% distinct()

    success_dates_and_zips$date <- as.character(success_dates_and_zips$date)
    success_new_dates %>%
      mutate(date = as.character(date)) %>%
      dplyr::union(success_dates_and_zips) %>%
      write.csv("weather_success_dates_and_zips.csv", row.names = FALSE, na = "")
    #-----------------------
    # load
    if (!file.exists("weather_db.csv")) {
      df_tr %>%
        write.csv(file = "weather_db.csv", row.names = FALSE, na = "")
    } else {
      df_tr %>%
        write.table(file = "weather_db.csv",
                    sep = ",",
                    row.names = FALSE,
                    col.names = FALSE,
                    append = TRUE,
                    na = "")
    }
  }
} else {
  print("No dates to scrape.")
}
