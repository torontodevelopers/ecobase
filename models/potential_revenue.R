# find our customers
source('init.R')
setwd(paste0(root,'db_local'))
con <- dbConnect(SQLite(), dbname='ecobase.sqlite')

#step 1: Customers

sql <- '
SELECT DISTINCT product_type.ProductType, product_sub_type.ProductSubType, product.Product, program.Name, customer_product.ModelNo, customer_product.SerialNo, customer_product.CoilModelNo, customer_product.CoilSerialNo, customer_product.ApplicationNumber, customers.Code, customer_product.Price, customer_product.funded, customer_product.Type, customer_product.CustomerProductStatus, customers.FirstName, customers.LastName, installation_scheduler.Date, technician.TechnicianNo, customers.OBAReferenceNumber
FROM product_type, product_sub_type, product, program_product_price, program, customer_product, customers, installation_scheduler, technician
WHERE product_type.Id = product_sub_type.ProductTypeId AND product_sub_type.Id = product.ProductSubType AND program_product_price.ProductId=product.Id AND program.Id = program_product_price.ProgramId AND program_product_price.ProgramId = customer_product.ProgramId AND program_product_price.ProductId = customer_product.ProductId AND customers.CustomerId = customer_product.CustomerId AND installation_scheduler.ApplicationNumberId = customer_product.CustomerProductDescriptionId AND installation_scheduler.TechnicianId = technician.Technicianid;
'
req <- dbGetQuery(con,sql)

#fix Dates
req[,'Date'] <- as.POSIXct(req[,'Date'], tz = "EST", origin='1970-01-01')
# subset to installed only
req <- req[req$CustomerProductStatus=="INCompleted",]

customers <- unique(req$Code)
cx.oba <- unique(req$OBAReferenceNumber)

today <- as.POSIXct(Sys.Date())

- as.Date(cxitem$Date)

for (i in 1:length(customers)) {
    cx.code <- customers[i]
    cxprod <- req[req$Code==cx.code,]
    serials <- cxprod$SerialNo
    for (j in 1:length(serials)) {
        serial <- serials[j]
        cxitem <- cxprod[cxprod$SerialNo==serial,]
        months(as.POSIXct(today) - cxitem$Date)
        cxitem$Price * 3
    }
}

for each cx create a data frame of what they should have paid.

