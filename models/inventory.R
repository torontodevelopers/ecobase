# find our inventory
source('init.R')
setwd(paste0(root,'db_local'))
con <- dbConnect(SQLite(), dbname='ecobase.sqlite')

# SQL Query is a join between product_type, product_sub_type, product, program_product_price,
# program, customer_product, customers, and installation_scheduler

sql <- '
SELECT DISTINCT product_type.ProductType, product_sub_type.ProductSubType, product.Product, program.Name, customer_product.ModelNo, customer_product.SerialNo, customer_product.ApplicationNumber, customers.Code, customer_product.Price, customer_product.funded, customer_product.Type, customer_product.CustomerProductStatus, customers.FirstName, customers.LastName, installation_scheduler.Date, technician.FirstName, technician.LastName, technician.TechnicianNo
FROM product_type, product_sub_type, product, program_product_price, program, customer_product, customers, installation_scheduler, technician
WHERE product_type.Id = product_sub_type.ProductTypeId AND product_sub_type.Id = product.ProductSubType AND program_product_price.ProductId=product.Id AND program.Id = program_product_price.ProgramId AND program_product_price.ProgramId = customer_product.ProgramId AND program_product_price.ProductId = customer_product.ProductId AND customers.CustomerId = customer_product.CustomerId AND installation_scheduler.ApplicationNumberId = customer_product.CustomerProductDescriptionId AND installation_scheduler.TechnicianId = technician.Technicianid;
'

req <- dbGetQuery(con,sql)

#fix Dates
req[,'Date'] <- as.POSIXct(req[,'Date'], tz = "EST", origin='1970-01-01')

# subset to installed only
req <- req[req$CustomerProductStatus=="INCompleted",]

# remove Roll Back WH
req <- req[req$ProductType != 'Roll Back WH',]
req <- req[req$ProductType != 'Accessories',]
req <- req[req$ProductType != 'Builder - Equipment',]

installed <- req

## inventory from Goodman

goodman <- read.xls('goodman_inv/inv.xls')
goodman <- goodman[,c(3:6,8:10)]
cols <- c('OrderNo','PO','InvoiceDate','ItemNo','Serial','Qty','Price')
names(goodman) <- cols

# type formatting
goodman$Serial <- as.character(goodman$Serial)

elim <- merge(installed,goodman,by.x = 'SerialNo', by.y = 'Serial')

elim.vec <- !(goodman$Serial %in% elim$SerialNo)
uninstalled <- goodman[elim.vec,]

