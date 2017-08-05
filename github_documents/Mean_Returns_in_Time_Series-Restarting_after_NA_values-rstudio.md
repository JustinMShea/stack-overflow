Mean Returns in Time Series - Restarting after NA values - rstudio
================

[Question Link](https://stackoverflow.com/questions/45465421/mean-returns-in-time-series-restarting-after-na-values-rstudio/45470156#45470156)
----------------------------------------------------------------------------------------------------------------------------------------------

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
    ## 1 2010-01-01 sec1 -2.4550713
    ## 2 2010-02-01 sec1  0.5795619
    ## 3 2010-03-01 sec1 -1.7078643
    ## 4 2010-04-01 sec1 -4.5178964
    ## 5 2010-05-01 sec1  3.1700078
    ## 6 2010-06-01 sec1  0.1350590

``` r
tail(df)
```

    ##             time     ID    returns
    ## 9995  2017-11-01 sec100  0.5901535
    ## 9996  2017-12-01 sec100 -0.3409562
    ## 9997  2018-01-01 sec100 -2.9363401
    ## 9998  2018-02-01 sec100  4.1891351
    ## 9999  2018-03-01 sec100  0.2691638
    ## 10000 2018-04-01 sec100 -1.1592334

Now, you must reshape your data so that each security column contains its returns, and each row represents the date.

``` r
library(tidyr)
df_wide <- spread(df, ID, returns)

head(df_wide[,1:6])
```

    ##         time       sec1       sec10     sec100      sec11      sec12
    ## 1 2010-01-01 -2.4550713  2.72823727 -1.3072551 -0.2324520 -0.9927411
    ## 2 2010-02-01  0.5795619 -0.27660421 -1.5220847  0.2488368 -0.9991461
    ## 3 2010-03-01 -1.7078643 -0.06856399 -0.3846257 -1.2867916  2.8586346
    ## 4 2010-04-01 -4.5178964  0.19533809  1.7737381 -0.2638643 -0.2786438
    ## 5 2010-05-01  3.1700078 -0.72381067  1.4368389  2.8329633 -5.5413927
    ## 6 2010-06-01  0.1350590 -1.94419626  2.1099822 -0.6051878  0.3328232

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

    ##         time      sec1       sec10       sec100       sec11      sec12
    ## 1 2010-01-01 -2.455071  2.72823727 -1.307255121 -0.23245198 -0.9927411
    ## 2 2010-02-01 -1.875509  2.45163307 -2.829339802  0.01638483 -1.9918872
    ## 3 2010-03-01 -3.583374  2.38306907 -3.213965515 -1.27040681  0.8667474
    ## 4 2010-04-01 -8.101270  2.57840717 -1.440227408 -1.53427114  0.5881036
    ## 5 2010-05-01 -4.931262  1.85459650 -0.003388486  1.29869214 -4.9532890
    ## 6 2010-06-01 -4.796203 -0.08959976  2.106593705  0.69350435 -4.6204658

``` r
tail(df_final[,1:6])
```

    ##           time       sec1    sec10   sec100     sec11    sec12
    ## 95  2017-11-01 -3.3623931 3.140612 29.44099 -25.94364 50.56823
    ## 96  2017-12-01 -3.4226709 3.347950 29.10003 -29.77063 53.90259
    ## 97  2018-01-01 -3.3249083 1.625984 26.16369 -30.01739 57.81489
    ## 98  2018-02-01 -0.4380824 0.999595 30.35283 -31.79697 59.24930
    ## 99  2018-03-01 -0.5163720 1.181396 30.62199 -33.78094 59.82608
    ## 100 2018-04-01 -2.2147063 1.008539 29.46276 -31.74161 58.83910
