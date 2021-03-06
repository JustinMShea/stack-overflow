Using `data()` for time series objects in R
================

[Question Link](https://stackoverflow.com/questions/44736963/using-data-for-time-series-objects-in-r/44738106#44738106)
-----------------------------------------------------------------------------------------------------------------------

I apologise if this question has been asked already (I haven't been able to find it). I was under the impression that I could access datasets in R using data(), for example, from the datasets package. However, this doesn't work for time series objects. Are there other examples where this is not the case? (And why?)

``` r
data("ldeaths")  # no dice
```

    ## Warning in data("ldeaths"): data set 'ldeaths' not found

``` r
ts("ldeaths")    # works
```

    ## Time Series:
    ## Start = 1 
    ## End = 1 
    ## Frequency = 1 
    ## [1] ldeaths

(However, this works for data("austres"), which is also a time-series object).

My Answer
---------

The data function is designed to load package data sets and all their attributes, time series or otherwise.

I think the issue your having is that there is no stand-alone data set called ldeaths in the datasets package. `ldeaths` does exist as 1 of 3 data sets in the `UKLungDeaths` data set. The other two are `fdeaths` and `mdeaths`.

The following should lazily load all data sets.

``` r
data(UKLungDeaths)
```

Then, typing `ldeaths` in the console or using it as an argument in some function will load it.

``` r
str(ldeaths)
```

    ##  Time-Series [1:72] from 1974 to 1980: 3035 2552 2704 2554 2014 ...

While it is uncommon for package authors to include multiple objects in 1 data set, it does happen. This line from the `data` function documentation gives on a 'heads up' about this:

> "For each given data set, the first two types (â€˜.Râ€™ or â€˜.râ€™, and â€˜.RDataâ€™ or â€˜.rdaâ€™ files) can create several variables in the load environment, which might all be named differently from the data set"

That is the case here, as while there are three time series objects contained in the data set, not one of them is named `UKLungDeaths`.

This choice occurs when the package author uses the save function to write multiple R objects to an external file. In the wild, I've seen folks use the save function to bundle a description file with the data set, although this would not be the proper way to document something in a full on package. If your really curious, go read the documentation on the save function.

Justin
