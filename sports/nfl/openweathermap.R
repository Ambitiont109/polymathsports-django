# install.packages("owmr")
library(owmr)
library(tidyverse)
library(rvest)
library(pbapply)
library(parallel)

Sys.setenv(OWM_API_KEY = "e491c48664140f0cf0bb5916abda39d4")
# owmr_settings("e491c48664140f0cf0bb5916abda39d4")

zipcodes <- read.csv("team_timezones.csv",
                     stringsAsFactors = FALSE,
                     colClasses = c("ZIPCODE" = "character")) %>%
  as_tibble() %>%
  select("ZIPCODE") %>%
  distinct()

cl <- makeCluster(detectCores())
clusterEvalQ(cl, {
  library(tidyverse)
  library(owmr)
})

list_df <- pbapply(zipcodes, 1, function(zip) {
  list(try_zip = zip,
       try_df = try(
         get_forecast(zip = zip, units = "imperial") %>%
           owmr_as_tibble() %>%
           mutate(zip) %>%
           select(zip, everything()) %>%
           as.data.frame()
       )
  )
}, cl = cl)

stopCluster(cl = cl)

ind_err <- 1:length(list_df) %>%
  lapply(function(x) {class(list_df[[x]]$try_df) == "try-error"}) %>%
  unlist()
print(paste0("Success rate: ", round(100 * mean(!ind_err), 2), "%"))

df_tr <- (1:length(list_df))[!ind_err] %>%
  lapply(function(x) {list_df[[x]]$try_df}) %>%
  bind_rows() %>%
  as_tibble()  %>%
  filter(as.POSIXlt(dt_txt, "%Y-%m-%d %H:%M:%S", tz = "")$hour == 15)

if (!file.exists("weather_forecast_openweathermap.csv")) {
  df_tr %>%
    write.csv("weather_forecast_openweathermap.csv", row.names = FALSE, na = "")
} else {
  read.csv("weather_forecast_openweathermap.csv", colClasses = c("zip" = "character"), stringsAsFactors = FALSE) %>% 
  anti_join(df_tr, by = c("zip", "dt_txt")) %>%
  bind_rows(df_tr) %>% 
  write.csv("weather_forecast_openweathermap.csv", row.names = FALSE, na = "")
}

rm(cl, df_tr, zipcodes, list_df)
