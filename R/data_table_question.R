library(pryr)
library(data.table)
library(microbenchmark)

N <- 1e8
P <- 1e2

data <- as.data.frame(rep(data.frame(rnorm(N)), P))

object_size(data)

tracemem(data)

data <- data.table(data)

tracemem(data)
class(data)

setDT(data)
 
tracemem(data)
class(data)


library(pryr)
library(data.table)
library(microbenchmark)
N <- 1e5
P <- 1e2
data <- as.data.frame(rep(data.frame(rnorm(N)), P))

# data.table method
object_size(data)
tracemem(data)
data <- data.table(data)
class(data)

# setDT method
# back to data.frame
data <- as.data.frame(data)
class(data)
tracemem(data)
setDT(data)
tracemem(data)
class(data)

# timing example
data <- as.data.frame(rep(data.frame(rnorm(N)), P))
microbenchmark(setDT(data), data.table(data))
