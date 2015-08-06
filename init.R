#init script
library(reco)
library(yaml)
library(httr)
library(jsonlite)
library(RSQLite)

#get all credentials from config file
config <- yaml.load_file(input='config.yaml')

# credentials and methods
creds <- as.character(unlist(as.data.frame(config$eco_api)))
methods <- as.character(unlist(as.data.frame(config$methods)))
root <- as.character(unlist(as.data.frame(config$root)))

# Run all methods
beginmethod <- 1
source('db_copy/get_all_methods.R')

# Clean Data
source('db_copy/clean_all.R')

# Deposit Into DB
source('db_copy/db_entry.R')

print('init script done.')


