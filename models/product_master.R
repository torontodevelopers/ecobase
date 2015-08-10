# Create Product Detail Report
source('../init.R')
setwd(paste0(root,'db_local'))
con <- dbConnect(SQLite(), dbname='ecobase.sqlite')

# products
product_type <- dbReadTable(con,'product_type')
product_sub_type <- dbReadTable(con,'product_sub_type')
product <- dbReadTable(con,'product')
# programs
program_product_price <- dbReadTable(con,'program_product_price')
program <- dbReadTable(con,'program')
# customers
customer_product <- dbReadTable(con,'customer_product')
customers <- dbReadTable(con,'customers')
# installs
installation_scheduler <- dbReadTable(con,'installation_scheduler')

# SQL Query

sql <- '
SELECT DISTINCT product_type.ProductType, product_sub_type.ProductSubType, product.Product, program.Name, customer_product.ModelNo, customer_product.SerialNo, customer_product.ApplicationNumber, customers.Code, customer_product.Price, customer_product.funded, customer_product.Type, customer_product.CustomerProductStatus, customers.FirstName, customers.LastName, installation_scheduler.Date
FROM product_type, product_sub_type, product, program_product_price, program, customer_product, customers, installation_scheduler
WHERE product_type.Id = product_sub_type.ProductTypeId AND product_sub_type.Id = product.ProductSubType AND program_product_price.ProductId=product.Id AND program.Id = program_product_price.ProgramId AND program_product_price.ProgramId = customer_product.ProgramId AND program_product_price.ProductId = customer_product.ProductId AND customers.CustomerId = customer_product.CustomerId AND installation_scheduler.ApplicationNumberId = customer_product.CustomerProductDescriptionId;
'

req <- dbGetQuery(con,sql)

#fix Dates
req[,'Date'] <- as.POSIXct(req[,'Date'], tz = "EST", origin='1970-01-01')
# installed only
req <- req[req$CustomerProductStatus=="INCompleted",]
# app greater than only
req <- req[req$ProductType != 'Accessories',]
req <- req[req$ProductType != 'Roll Back WH',]

#export
names(req)[c(4,8,10,11,12,15)] <- c('ProgramName','Cx.Id','Funded','Owned','Status','InstallDate')
write.csv(req,paste0(root,'results/product_detail_report.csv'))