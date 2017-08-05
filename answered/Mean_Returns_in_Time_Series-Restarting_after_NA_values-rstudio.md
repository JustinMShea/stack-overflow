Mean Returns in Time Series - Restarting after NA values - rstudio
================

[](https://stackoverflow.com/questions/45465421/mean-returns-in-time-series-restarting-after-na-values-rstudio/45470156#45470156)
---------------------------------------------------------------------------------------------------------------------------------

Has anyone encountered calculating historical mean log returns in time series datasets?

The dataset is ordered by individual security first and by time for each respective security. I am trying to form a historical mean log return, i.e. the mean log return for the security from its first appearance in the dataset to date, for each point in time for each security.

Luckily, the return time series contains NAs between returns for differing securities. My idea is to calculate a historical mean that restarts after each NA that appears.

A simple `cumsum()` probably will not do it, as the NAs will have to be dropped.

I thought about using `rollmean()`, if I only knew an efficient way to specify the 'width' parameter to the length of the vector of consecutive preceding non-NAs. The current approach I am taking, based on Count how many consecutive values are true, takes significantly too much time, given the size of the data set I am working with. For any x of the form x : \[r(1) r(2) ... r(N)\], where r(2) is the log return in period 2:

``` r
df <- data.frame(x, zcount = NA) 
df[1,2] = 0 #df$x[1]=NA by construction of the data set
for(i in 2:nrow(df)) 
df$zcount[i] <- ifelse(!is.na(df$x[i]), df$zcount[i-1]+1, 0)
```

Any idea how to speed this up would be highly appreciated!

Answer
------

You will need to reshape the data.frame to apply the cumsum function over each security. Here's how:

First, I'll generate some data on 100 securities over 100 months which I think corresponds to your description of the data set

``` r
securities <- 100
months <- 100

time <- seq.Date(as.Date("2010/1/1"), by = "months", length.out = months)
ID <- rep(paste0("sec", 1:months), each = securities)
returns <- rnorm(securities * months, mean = 0.08, sd = 2)

df <- data.frame(time, ID, returns)

head(df)
```

    ##         time   ID    returns
    ## 1 2010-01-01 sec1  2.8724106
    ## 2 2010-02-01 sec1 -0.1665607
    ## 3 2010-03-01 sec1 -0.7440986
    ## 4 2010-04-01 sec1 -2.9341218
    ## 5 2010-05-01 sec1 -1.6355142
    ## 6 2010-06-01 sec1  0.9249833

``` r
tail(df)
```

    ##             time     ID   returns
    ## 9995  2017-11-01 sec100  1.934427
    ## 9996  2017-12-01 sec100 -2.633445
    ## 9997  2018-01-01 sec100  2.678013
    ## 9998  2018-02-01 sec100 -1.397908
    ## 9999  2018-03-01 sec100  1.006777
    ## 10000 2018-04-01 sec100 -1.647376

Now, you must reshape your data so that each security column contains its returns, and each row represents the date.

``` r
library(tidyr)
df_wide <- spread(df, ID, returns)

head(df_wide[,1:6])
```

    ##         time       sec1      sec10     sec100      sec11       sec12
    ## 1 2010-01-01  2.8724106 -0.6019116  0.3911511 -1.0915669  2.45689357
    ## 2 2010-02-01 -0.1665607  1.4623801  1.4591807  1.0220396  1.87430349
    ## 3 2010-03-01 -0.7440986  3.1538335 -2.0318876  0.3019025 -0.79741743
    ## 4 2010-04-01 -2.9341218  4.9162262 -1.2363915  0.8749974  4.50069824
    ## 5 2010-05-01 -1.6355142  1.7370831 -1.4636139 -1.9466297  2.09596194
    ## 6 2010-06-01  0.9249833  0.3175962  0.4965642  1.3703646 -0.07548665

Once this is done, you can use the `apply` function to `sum` every column which now represents each security. Or use the `cumsum` function. Notice the data object `df_wide[-1]`, which drops the time column. This is necessary to avoid the sum or cumsum functions throwing an error.

``` r
matrix_sum <- apply(df_wide[-1], 2, FUN = sum)

matrix_cumsum <- apply(df_wide[-1], 2, FUN = cumsum)
```

Now, add the `time` column back as a `data.frame` if you like:

``` r
df_final <- data.frame(time = df_wide[,1], matrix_cumsum)

head(df_final[,1:6])
```

    ##         time       sec1      sec10     sec100       sec11     sec12
    ## 1 2010-01-01  2.8724106 -0.6019116  0.3911511 -1.09156694  2.456894
    ## 2 2010-02-01  2.7058500  0.8604685  1.8503317 -0.06952737  4.331197
    ## 3 2010-03-01  1.9617513  4.0143019 -0.1815559  0.23237513  3.533780
    ## 4 2010-04-01 -0.9723705  8.9305282 -1.4179474  1.10737253  8.034478
    ## 5 2010-05-01 -2.6078846 10.6676112 -2.8815613 -0.83925717 10.130440
    ## 6 2010-06-01 -1.6829013 10.9852074 -2.3849971  0.53110746 10.054953

``` r
tail(df_final[,1:6])
```

    ##           time       sec1    sec10    sec100      sec11     sec12
    ## 95  2017-11-01 -14.664549 25.75324 -12.48747 -10.308537  8.024234
    ## 96  2017-12-01  -9.685539 25.74694 -15.12091  -8.718868 10.216177
    ## 97  2018-01-01 -11.245319 25.68613 -12.44290  -9.615479 10.159007
    ## 98  2018-02-01  -9.418278 24.10952 -13.84081 -12.250951  7.977667
    ## 99  2018-03-01 -10.614289 23.64217 -12.83403 -12.497015  5.947972
    ## 100 2018-04-01 -10.247786 22.47987 -14.48140 -13.464190  5.159006
