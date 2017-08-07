file_path <- paste0(getwd(),"/data/Frame.txt")

Frame <- read.table(file_path, stringsAsFactors = FALSE)
Frame$Time <- sort(as.Date(c("2010-01-01", "2010-07-02", "2010-08-03", "2011-02-04", "2011-11-05", "2011-12-06", "2012-06-07", "2012-08-30", "2013-04-16", "2013-03-18", "2014-02-22", "2014-01-27", "2015-12-15", "2015-09-28", "2016-05-04", "2017-11-07", "2017-09-22", "2017-04-04"),
                      format = "%Y-%m-%d"))

plot(y = Frame$Quantity, x = Frame$Time, type = "l")

Frame <- ts(Frame$Quantity, start = 1, end = NROW(Frame), frequency = 1)

library(forecast)
TheForecast <- naive(Frame)
str(TheForecast)
class(TheForecast)
plot(TheForecast, xlab="Time",ylab="Quantity",main="Stock Quantity vs Time",type='l')

