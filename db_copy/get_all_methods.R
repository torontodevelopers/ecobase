#build static elements of API call, including base url, username, and password (from config file)

baseurl <- "http://miecotest.office-on-the.net/miecotest/ECOService/ECOService.svc/"
username = creds[1]
key1 = paste0('"username": \"',username,"\"",",")
password = creds[2]
key2 = paste0('"password": \"',password,"\"",",")

# Loop through each API method
for (j in beginmethod:length(methods)) {
    method <- methods[j]
    value <- data.frame()
    # call for 1 to get # of Total Records
    get_api(1,method)
    i = 1
    while(i < totalrecords) {
        get_api(i,method)
        }
# create separate objects
    assign(method,value)
    rm(value)
}
# Clean all unneccessary variables
rm(baseurl,beginmethod,creds,i,j,key1,key2,method,password,username,totalrecords)

# Save to RData file
save.image(file=paste0(root,'db_local/ecodb.Rdata'))


