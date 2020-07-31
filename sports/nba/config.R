library(rvest)
library(tidyverse)
library(pbapply)
library(parallel)

source("functions.R")

seasons <- seq(2015, 2020)
start_date <- "2010-01-01" # for PROSPORTTRANSACTIONS

TODAY <- Sys.Date()

BASE_URL      <- "https://www.basketball-reference.com"
BASE_PROSPORT <- "https://www.prosportstransactions.com/basketball/Search/"

FILENAME_GAMELOGS <- "game_logs.csv"
FILENAME_GAMEURLS <- "game_urls.csv"

FILENAME_PROSPORT_INJURIES_RAW             <- "injuries_PROSPORT_raw.csv"
FILENAME_PROSPORT_INJURIES_BY_DATE         <- "injuries_PROSPORT_by_date.csv"
FILENAME_BASKETREF_INJURIES_REPORT_BY_DATE <- "injuries_BASKETREF_by_date.csv"
FILENAME_SALARIES                          <- "salaries.csv"
FILENAME_SALARIES_BY_GAMES                 <- "salaries_by_games.csv"
FILENAME_PLAYERS_DICT                      <- "players_dictionary.csv"
FILENAME_PLAYERS_DICT_MISSING_IDS          <- "players_dictionary_missing_ids.csv"
#----------------------------------------------------------------------------------------------------
DATA_FOLDER_PATH = paste0(getwd(), "/data/")

FILENAME_GAMELOGS <- paste0(DATA_FOLDER_PATH, FILENAME_GAMELOGS)
FILENAME_GAMEURLS <- paste0(DATA_FOLDER_PATH, FILENAME_GAMEURLS)

FILENAME_PROSPORT_INJURIES_RAW <- paste0(DATA_FOLDER_PATH, FILENAME_PROSPORT_INJURIES_RAW)
FILENAME_PROSPORT_INJURIES_BY_DATE <- paste0(DATA_FOLDER_PATH, FILENAME_PROSPORT_INJURIES_BY_DATE)
FILENAME_BASKETREF_INJURIES_REPORT_BY_DATE <- paste0(DATA_FOLDER_PATH, FILENAME_BASKETREF_INJURIES_REPORT_BY_DATE)

FILENAME_SALARIES <- paste0(DATA_FOLDER_PATH, FILENAME_SALARIES)
FILENAME_SALARIES_BY_GAMES <- paste0(DATA_FOLDER_PATH, FILENAME_SALARIES_BY_GAMES)
FILENAME_PLAYERS_DICT <- paste0(DATA_FOLDER_PATH, FILENAME_PLAYERS_DICT)
FILENAME_PLAYERS_DICT_MISSING_IDS <- paste0(DATA_FOLDER_PATH, FILENAME_PLAYERS_DICT_MISSING_IDS)