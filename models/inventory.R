# find our inventory
source('init.R')
setwd(paste0(root,'db_local'))
con <- dbConnect(SQLite(), dbname='ecobase.sqlite')

# SQL Query is a join between product_type, product_sub_type, product, program_product_price,
# program, customer_product, customers, and installation_scheduler

sql <- '
SELECT DISTINCT product_type.ProductType, product_sub_type.ProductSubType, product.Product, program.Name, customer_product.ModelNo, customer_product.SerialNo, customer_product.CoilModelNo, customer_product.CoilSerialNo, customer_product.ApplicationNumber, customers.Code, customer_product.Price, customer_product.funded, customer_product.Type, customer_product.CustomerProductStatus, customers.FirstName, customers.LastName, installation_scheduler.Date, technician.TechnicianNo
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
rm(req)

## inventory from Goodman

goodman <- read.xls('goodman_inv/inv.xls')
goodman <- goodman[,c(3:6,8:10)]
names(goodman) <- c('OrderNo','PO','InvoiceDate','ItemNo','Serial','Qty','Price')

# type formatting
goodman$Serial <- as.character(goodman$Serial)
goodman$PO <- as.character(goodman$PO)

#find which rows are for coils, and split goodman into two lists
coil.vec <- grepl('CAUF',goodman$ItemNo,fixed=T)

goodman_hvac <- goodman[!coil.vec,]
goodman_coil <- goodman[coil.vec,]

elim_hvac <- merge(installed,goodman_hvac,by.x = 'SerialNo', by.y = 'Serial')
elim_hvac.vec <- !(goodman_hvac$Serial %in% elim_hvac$SerialNo)

elim_coil <- merge(installed,goodman_coil,by.x = 'CoilSerialNo', by.y='Serial')
elim_coil.vec <- !(goodman_coil$Serial %in% elim_coil$CoilSerialNo)

uninstalled_hvac <- goodman_hvac[elim_hvac.vec,]
uninstalled_coil <- goodman_coil[elim_coil.vec,]

uninstalled <- rbind(uninstalled_hvac,uninstalled_coil)

####

goodman$PO <- gsub('C:','',goodman$PO)
goodman$PO <- gsub(' ','',goodman$PO)

2200* 2


# [Tech ID]-[Supplier]-[App No or Date]
# 0001-01-20150403


save.xlsx('test.xlsx',uninstalled,elim)

