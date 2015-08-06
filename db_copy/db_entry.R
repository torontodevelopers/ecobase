#Database Entry
setwd(dir = paste0(root,'db_local/'))
con <- dbConnect(SQLite(), dbname='ecobase.sqlite')

#create new db names
dbnames <- gsub('Get', '', methods)
for (i in 1:length(methods)) {
    dbnames[i] <- to_underscore(dbnames[i])
    dbWriteTable(con, dbnames[i], get(methods[i]), overwrite = T)
}

rm(list=c(methods),methods,i)