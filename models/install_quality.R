# This script calculates Installer Quality as measured by Service Work Orders requested on Installer's Jobs

setwd(paste0(root,'db_local'))
con <- dbConnect(SQLite(), dbname='ecobase.sqlite')

# read in tables of interest
tech <- dbReadTable(con, 'technician')
tech <- unique(tech)

swoscheduler <- dbReadTable(con, 'service_work_order_scheduler')
swoscheduler <- swoscheduler[swoscheduler$Status=="SWOCompleted",]
install <- dbReadTable(con, 'installation_scheduler')
install <- install[install$Status=="INCompleted",]
install <- merge(install,tech,by.x="TechnicianId",by.y="Technicianid")[c(1,11)]

swoproddetails <- dbReadTable(con, 'service_work_order_product_details')

# SQL query to create original tech id and cx id table


sql <- '
SELECT installation_scheduler.TechnicianId AS original_tech, customer_product.CustomerId AS cx_id'

sql <- 'SELECT installation_scheduler.TechnicianId, customer_product.CustomerId
FROM installation_scheduler
INNER JOIN customer_product
ON installation_scheduler.ApplicationNumberId = customer_product.CustomerProductDescriptionId'
original_tech_cx_id <- dbGetQuery(con,sql)

original_tech_cx_id <- merge(original_tech_cx_id,tech,by.x='TechnicianId',by.y='Technicianid')[,c(1,2,5)]

# merge with swo table to investigate which original techs recieved most swo on their work
original_tech_swo <- merge(original_tech_cx_id,swoscheduler,by='CustomerId')
original_tech_swo <- original_tech_swo[original_tech_swo$TechnicianId != 18,]

#rename for clarity
names(original_tech_swo)[3] <- 'OriginalTech'
names(original_tech_swo)[6] <- 'SWOTech'

swo <- table(original_tech_swo$OriginalTech)
ins <- table(install$FirstName)

ins.qual <- as.data.frame(swo/ins)
ins.qual <- ins.qual[order(ins.qual$Freq),]

setwd(paste0(root,'results/'))
write.csv(ins.qual,'Install Quality-2.csv',row.names = F)

dbDisconnect(con)
