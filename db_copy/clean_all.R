#Date Conversions

# grep to find all Date Columns across all tables
for (i in 1:length(methods)) {
    w <- grep('Date',names(get(methods[i])))
    if (length(w) > 0) {
        for (j in 1:length(w)) {
            date_convert(dataset = get(methods[i]),col = w[j],name = methods[i])
        }
    }
    x <- grep('CustomerCreated',names(get(methods[i])))
    if (length(x) > 0) {
        for (j in 1:length(x)) {
            date_convert(dataset = get(methods[i]),col = x[j],name = methods[i])
        }
    }
    y <- grep('EffectiveFrom',names(get(methods[i])))
    if (length(y) > 0) {
        for (j in 1:length(y)) {
            date_convert(dataset = get(methods[i]),col = y[j],name = methods[i])
        }
    }
    z <- grep('EffectiveTo',names(get(methods[i])))
    if (length(z) > 0) {
        for (j in 1:length(z)) {
            date_convert(dataset = get(methods[i]),col = z[j],name = methods[i])
        }
    }
}

#cleanup
rm(i,j,w,x,y,z)

# Save to RData file
save.image(file=paste0(root,'db_local/ecodb.Rdata'))