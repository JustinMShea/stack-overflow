https://stackoverflow.com/questions/45336684/multiple-time-series-graphs-in-one-plot-disregarding-empty-fields

df <-  read.table(text = c(" 
CompanyA    NA  1000    NA  NA  NA  1000
CompanyB    600 NA  NA  NA  600 NA
CompanyC    NA  5000    NA  500 NA  NA"), 
                  header = F) 

colnames(df) <-  c("CompanyName",   "2001-01",  "2001-02"   ,"2001-03", "2001-04",  "2001-05",  "2001-06")

# Transpose the data frame
df_t <- t(df)

#Now, save the first row, which contains the company names. 
company_names <- df_t[1,]

# drop the first row and make df_t object class data.frame

df_t <- data.frame(df_t[-1, ], stringsAsFactors = FALSE)

# add the company names stored in "company_names" back as the column names
colnames(df_t) <- company_names

# You likely lost the data class during the transpose, so convert column to numerics
df_numeric <- data.frame(sapply(df_t, FUN=as.numeric), row.names =  rownames(df_t))


# Now convert to time series based xts object.
library(xts)
# convert rownames "2001-01, 2001-02, ..." to yearmon fromat
rownames(df_numeric ) <- as.yearmon(rownames(df_numeric ), "%Y-%m")

# pass the dates as an index to the xts via the `order.by` command.
df_xts <- xts(df_numeric , order.by = as.yearmon(rownames(df_numeric )))


# Finall, we can use the "Last Observation Carried Forward" function to fill in the dates.
df_locf <- na.locf(df_xts)

df_locf

# The plot function works.
plot(df_locf)
