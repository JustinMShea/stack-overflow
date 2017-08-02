
# example using 1000 rows and 50 cols of data
N <- 1000
P <- 50

data <- as.data.frame(rep(data.frame(rnorm(N)), P))

# Assign your y data to y.
y <- as.data.frame(rep(data.frame(rnorm(N)), 1))

# create a new data.frame containing y and the last 22 columns.

model_data <- cbind(y, data[ ,29:50])
colnames(model_data) <- c("y", paste0("x", 1:10), paste0("z",1:12))
str(model_data)

reg <-lm(y ~ ., data = model_data)

plot(reg)
