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
    ## 1 2010-01-01 sec1 -1.5065692
    ## 2 2010-02-01 sec1 -1.2459160
    ## 3 2010-03-01 sec1  2.9920949
    ## 4 2010-04-01 sec1 -1.1056702
    ## 5 2010-05-01 sec1 -0.2033128
    ## 6 2010-06-01 sec1 -0.2119653

``` r
tail(df)
```

    ##             time     ID    returns
    ## 9995  2017-11-01 sec100 -1.9605737
    ## 9996  2017-12-01 sec100 -1.3381948
    ## 9997  2018-01-01 sec100 -2.7945972
    ## 9998  2018-02-01 sec100  1.0137828
    ## 9999  2018-03-01 sec100 -2.0170081
    ## 10000 2018-04-01 sec100 -0.4031035

Now, you must reshape your data so that each security column contains its returns, and each row represents the date.

``` r
library(tidyr)
df_wide <- spread(df, ID, returns)

head(df_wide[,1:6])
```

    ##         time       sec1        sec10      sec100      sec11      sec12
    ## 1 2010-01-01 -1.5065692 -3.132785331  0.58407110 -1.0142665  3.7421780
    ## 2 2010-02-01 -1.2459160 -2.119524049 -1.02098659 -1.8381268 -0.4319477
    ## 3 2010-03-01  2.9920949 -1.242183987 -0.72353341 -0.4847428 -1.0471885
    ## 4 2010-04-01 -1.1056702  2.413149200 -0.22449996  0.1873594  2.6491458
    ## 5 2010-05-01 -0.2033128  0.009448196 -1.14164639 -2.4188288 -1.0929571
    ## 6 2010-06-01 -0.2119653  1.300410244 -0.09289236 -1.3711938  0.7925469

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

    ##         time       sec1     sec10     sec100     sec11    sec12
    ## 1 2010-01-01 -1.5065692 -3.132785  0.5840711 -1.014267 3.742178
    ## 2 2010-02-01 -2.7524852 -5.252309 -0.4369155 -2.852393 3.310230
    ## 3 2010-03-01  0.2396097 -6.494493 -1.1604489 -3.337136 2.263042
    ## 4 2010-04-01 -0.8660605 -4.081344 -1.3849489 -3.149777 4.912188
    ## 5 2010-05-01 -1.0693732 -4.071896 -2.5265953 -5.568606 3.819230
    ## 6 2010-06-01 -1.2813385 -2.771486 -2.6194876 -6.939799 4.611777

``` r
tail(df_final[,1:6])
```

    ##           time      sec1    sec10    sec100      sec11      sec12
    ## 95  2017-11-01 -13.32270 20.75978 -14.28167  1.5650105 -0.8292663
    ## 96  2017-12-01 -12.22992 22.88248 -15.61986  2.6159072  2.0858858
    ## 97  2018-01-01  -9.39923 25.08027 -18.41446  0.6696950  1.7250855
    ## 98  2018-02-01 -13.53480 27.16878 -17.40067  0.2066707 -0.6727455
    ## 99  2018-03-01 -14.11370 29.34079 -19.41768 -0.8493746 -0.8729705
    ## 100 2018-04-01 -12.62922 28.90401 -19.82079 -1.2788878 -4.1852083
