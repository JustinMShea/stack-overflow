library(pryr)
library(data.table)
library(microbenchmark)

N <- 1e8
P <- 1e2

data <- as.data.frame(rep(data.frame(rnorm(N)), P))

object_size(data)

gc(reset=TRUE)

tracemem(data)

data1 <- data.table(data)

tracemem(data)

data2 <- setDT(data)
 
tracemem(data2)

data <- as.data.frame(rep(data.frame(rnorm(N)), P))
microbenchmark(data.table(data), setDT(data))


gc()


N <- 1e6
P <- 1e2

data <- as.data.frame(rep(data.frame(rnorm(N)), P))

object_size(data)

microbenchmark(data2 <- setDT(data), data1 <- data.table(data), times = 10)
