library(rvest)
library(tidyverse)
library(pbapply)
library(parallel)

source("functions.R")

seasons <- seq(2011, 2020)

BASE_URL <- "https://www.sports-reference.com"

FILENAME_GAMELOGS <- "game_logs.csv"
FILENAME_GAMEURLS <- "game_urls.csv"


