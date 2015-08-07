# db_copy makes a local copy of the EES database in SQLite.
source('../init.R')
setwd(paste0(root,'db_copy'))

# Run all eco API methods 
beginmethod <- 1
source('get_all_methods.R')

# Clean Data
source('clean_all.R')

# Deposit Into DB
source('db_entry.R')
