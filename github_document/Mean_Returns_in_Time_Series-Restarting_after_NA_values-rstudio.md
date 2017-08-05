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
    ## 1 2010-01-01 sec1 -0.1423442
    ## 2 2010-02-01 sec1  1.3272738
    ## 3 2010-03-01 sec1 -1.6710388
    ## 4 2010-04-01 sec1 -1.2207499
    ## 5 2010-05-01 sec1  0.5352951
    ## 6 2010-06-01 sec1  1.2478967

``` r
tail(df)
```

    ##             time     ID    returns
    ## 9995  2017-11-01 sec100  1.6610386
    ## 9996  2017-12-01 sec100 -1.9733768
    ## 9997  2018-01-01 sec100  0.5494929
    ## 9998  2018-02-01 sec100 -1.1410701
    ## 9999  2018-03-01 sec100  2.0215292
    ## 10000 2018-04-01 sec100  0.4269100

Now, you must reshape your data so that each security column contains its returns, and each row represents the date.

``` r
library(tidyr)
df_wide <- spread(df, ID, returns)

head(df_wide[,1:6])
```

    ##         time       sec1      sec10     sec100     sec11      sec12
    ## 1 2010-01-01 -0.1423442  0.8623391  0.9085417 -2.131237 -1.0168186
    ## 2 2010-02-01  1.3272738 -2.0342838 -1.5956718 -1.572809 -1.6867294
    ## 3 2010-03-01 -1.6710388 -0.7380200  0.6343911  3.171278 -1.3913973
    ## 4 2010-04-01 -1.2207499 -0.7684065  4.6803263  3.287772  0.1465185
    ## 5 2010-05-01  0.5352951 -0.7157588 -1.2490020 -2.924942  2.6276118
    ## 6 2010-06-01  1.2478967  1.7151369  0.1022406 -1.721672 -0.9170751

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

    ##         time        sec1      sec10      sec100      sec11     sec12
    ## 1 2010-01-01 -0.14234424  0.8623391  0.90854170 -2.1312369 -1.016819
    ## 2 2010-02-01  1.18492953 -1.1719447 -0.68713008 -3.7040455 -2.703548
    ## 3 2010-03-01 -0.48610929 -1.9099647 -0.05273901 -0.5327677 -4.094945
    ## 4 2010-04-01 -1.70685920 -2.6783712  4.62758730  2.7550040 -3.948427
    ## 5 2010-05-01 -1.17156412 -3.3941300  3.37858528 -0.1699378 -1.320815
    ## 6 2010-06-01  0.07633262 -1.6789931  3.48082591 -1.8916095 -2.237890

``` r
tail(df_final[,1:6])
```

    ##           time      sec1     sec10   sec100    sec11     sec12
    ## 95  2017-11-01  9.116497  8.419603 19.22923 20.39031 -7.467275
    ## 96  2017-12-01  9.461440  7.919773 17.25586 20.43343 -5.802587
    ## 97  2018-01-01  8.888429  8.689618 17.80535 20.16459 -5.932726
    ## 98  2018-02-01 12.383196  7.936807 16.66428 18.36388 -6.077175
    ## 99  2018-03-01 12.952587 10.479638 18.68581 20.13695 -8.064173
    ## 100 2018-04-01 11.293595 11.530271 19.11272 22.40239 -4.871165
