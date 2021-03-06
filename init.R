#init script
library(reco)
library(yaml)
library(httr)
library(jsonlite)
library(RSQLite)
library(ggplot2)
library(gdata)
library(lubridate)

#get all credentials from config file
config <- yaml.load_file(input='config.yaml')

# credentials and methods
creds <- as.character(unlist(as.data.frame(config$eco_api)))
methods <- as.character(unlist(as.data.frame(config$methods)))
root <- as.character(unlist(as.data.frame(config$root)))
query_product <- as.character(unlist(as.data.frame(config$queries)))

