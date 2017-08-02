# You will need to reshape your data so that we can apply the cumsum function
# over each security. Here's how:

# First, generate some data on 100 securities over 100 months

securities <- 100
months <- 100

time <- seq.Date(as.Date("2010/1/1"), by = "months", length.out = months)
ID <- rep(paste0("sec", 1:months), each = securities)

returns <- rnorm(securities * months, mean = 0.08, sd = 2)

df <- data.frame(time, ID, returns)

# Now, you must reshape your data so that each securities contains its
# its own column of prices, and each row contains the same date.
library(tidyr)
df_wide <- spread(df, ID, returns)
tail(df_wide)
# Once this is done, you can use the apply the sum function to your data,
# or the cumsum function

matrix_sum <- apply(df_wide[-1], 2, FUN = sum)

matrix_cumsum <- apply(df_wide[-1], 2, FUN = cumsum)

df_final <- data.frame(time = df_wide[,1], matrix_cumsum)


