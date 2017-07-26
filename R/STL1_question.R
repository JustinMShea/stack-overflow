dat <- data.frame(year= seq(1962,2014,1),yields=c(1100,1040,1130,1174,1250,1350,1450,1226,1070,1474,1526,1719,1849,1766,1342,2000,1750,1750,2270,1550,1220,2400,2750,3200,2125,3125,3737,2297,3665,2859,3574,4519,3616,3247,3624,2964,4326,4321,4219,2818,4052,3770,4170,2854,3598,4767,4657,3564,4340,4573,3834,4700,4168))

dat$trend  <- loess(yields ~ year, data = dat)$fitted

plot(y = dat$yields, x = dat$year, data = dat, type = "l",  xlab="Years", ylab="Kg/ha", main="Crop yields")
lines(y = dat$trend, x = dat$year, col = "blue", type = "l")

dat$cycle <- dat$yields - dat$trend

plot(y = dat$cycle, x = dat$year, col = "red", data = dat, type = "l",  xlab="Years", ylab="Kg/ha", main="Crop yields")
