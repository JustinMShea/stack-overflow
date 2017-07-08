When should I use setDT() instead of data.table() to create a data.table?
================

[Original Post](https://stackoverflow.com/questions/41917887/when-should-i-use-setdt-instead-of-data-table-to-create-a-data-table)
----------------------------------------------------------------------------------------------------------------------------------

I am having difficulty grasping the essence of the setDT() function. As I read code on SO, I frequently come across the use of setDT() to create a data.table. Of course the use of data.table() is ubiquitous. I feel like I solidly comprehend the nature of data.table() yet the relevance of setDT() eludes me. ?setDT tells me this:

> "setDT converts lists (both named and unnamed) and data.frames to data.tables by reference."

as well as:

> "In data.table parlance, all set\* functions change their input by reference. That is, no copy is made at all, other than temporary working memory, which is as large as one column."

So this makes me think I should only use setDT() to make a data.table, right? Is setDT() simply a list to data.table converter?

``` r
library(data.table)

a <- letters[c(19,20,1,3,11,15,22,5,18,6,12,15,23)]
b <- seq(1,41,pi)
ab <- data.frame(a,b)
d <- data.table(ab)
e <- setDT(ab)

str(d)
```

    ## Classes 'data.table' and 'data.frame':   13 obs. of  2 variables:
    ##  $ a: Factor w/ 12 levels "a","c","e","f",..: 9 10 1 2 5 7 11 3 8 4 ...
    ##  $ b: num  1 4.14 7.28 10.42 13.57 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

``` r
#Classes ‘data.table’ and 'data.frame': 13 obs. of  2 variables:
# $ a: Factor w/ 12 levels "a","c","e","f",..: 9 10 1 2 5 7 11 3 8 4 ...
# $ b: num  1 4.14 7.28 10.42 13.57 ...
# - attr(*, ".internal.selfref")=<externalptr>

str(e)
```

    ## Classes 'data.table' and 'data.frame':   13 obs. of  2 variables:
    ##  $ a: Factor w/ 12 levels "a","c","e","f",..: 9 10 1 2 5 7 11 3 8 4 ...
    ##  $ b: num  1 4.14 7.28 10.42 13.57 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

Seemingly no difference in this instance. In another instance the difference is evident:

    ## Classes 'data.table' and 'data.frame':   2 obs. of  1 variable:
    ##  $ ba:List of 2
    ##   ..$ : chr  "s" "t" "a" "c" ...
    ##   ..$ : num  1 4.14 7.28 10.42 13.57 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

    ## Classes 'data.table' and 'data.frame':   13 obs. of  2 variables:
    ##  $ V1: chr  "s" "t" "a" "c" ...
    ##  $ V2: num  1 4.14 7.28 10.42 13.57 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

When should I use setDT()? What makes setDT() relevant? Why not just make the original data.table() function capable of doing what setDT() is able to do?

Answer
------

I like this question on stackoverflow because I think it is really about avoiding stack overflow in R when dealing with larger data sets. 😊 Those who are unfamiliar with data.table family of set operations may benefit from this discussion!

One should use setDT() when working with larger data sets that take up a considerable amount of RAM because the operation will modify each object in place, conserving memory. For data that is a very small percentage of RAM, using data.table’s copy-and-modify is fine.

The creation of the setDT function was actually inspired by the following thread on stack overflow, which is about working with a large data set (several GB's). You will see Matt Dowle chime in an suggest the 'setDT' name.

[convert-a-data-frame-to-a-data-table-without-copy](https://stackoverflow.com/questions/20345022/convert-a-data-frame-to-a-data-table-without-copy)

**A bit more depth:**

With R, data is stored in memory. This speeds things up considerably because RAM is much faster to access than storage devices. However, a problem can arise when one’s data set is a large portion of RAM. Why? Because base R has a tendency to make copies of each data.frame when some operations are applied to them. This has improved after version 3.1, but addressing that is beyond the scope of this post. If one is pulling multiple data.frames or lists into one data.frame or data.table, your memory usage will expand rather quickly because at some point during the operation, multiple copies of your data exist in RAM. The function tracemem can help you determine how many times an object is being copied in R. So...If your data set is big enough, you may run out of memory when all the copies are produced, and your stack will overflow. See example of this below:

``` r
library(pryr)
library(data.table)
library(microbenchmark)
> N <- 1e8
> P <- 1e2
> 
> data <- as.data.frame(rep(data.frame(rnorm(N)), P))
> 
> object_size(data)
800 MB
> tracemem(data)
[1] "<00000000180C1150>"
> data1 <- data.table(data)
Error: cannot allocate vector of size 762.9 Mb
```

The ability to just modify the object in place without copying is a big deal. That is what setDT does when it takes a list or data.frame and returns a data.table. The same example as above using setDT, now works fine and without error.

``` r
> tracemem(data)
[1] "<00000000180C1150>"
> data2 <- setDT(data)
> tracemem(data2)
[1] "<000000001A196A48>"
```

@Roland points out that for most people, the bigger concern is speed, which suffers as a side effect of such intensive use of memory management. Here is an example with smaller data that does not crash the cpu, and illustrates how much faster setDT is for this job. Notice the results of 'tracemem' in the wake of data1 &lt;- data.table(data), making copies of data. Contrast that with 'data2 &lt;- setDT(data)' which doesn't print a single copy. We have to then call tracemem(data2) to see the newly assigned memory address.

``` r
> N <- 1e6
> P <- 1e2
> data <- as.data.frame(rep(data.frame(rnorm(N)), P))
> object_size(data)
8.01 MB
> tracemem(data)
[1] "<000000001CC36A78>"
> 
> data1 <- data.table(data)
tracemem[0x000000001cc36a78 -> 0x000000000ca75d18]: data.table 
tracemem[0x000000000ca75d18 -> 0x000000001cbf1d30]: copy as.data.table.data.frame as.data.table data.table 
tracemem[0x000000000ca75d18 -> 0x000000001a9c5448]: as.list.data.frame as.list vapply copy as.data.table.data.frame as.data.table data.table 
> 
> tracemem(data)
[1] "<000000001CC36A78>"
> 
> data2 <- setDT(data)
>  
> tracemem(data2)
[1] "<000000001376EEE8>"
>
> data <- as.data.frame(rep(data.frame(rnorm(N)), P))
> microbenchmark(data.table(data), setDT(data))
Unit: microseconds
            expr        min          lq         mean      median         uq        
 data.table(data) 607392.340 730672.8620 755195.35575 746919.9160 779550.867 
      setDT(data)     48.237     54.5665     66.75908     71.5005     73.724    
> 
```

Set functions can be used in many areas, not just when converting objects to a data.tables. You can find more information on the reference semantics and how to apply them elsewhere by calling the vignette on the subject.

``` r
library(data.table)    
vignette("datatable-reference-semantics")
```

This is a great question and people thinking of using R with larger data sets can benefit from being familiar with the significant performance improvements of data.table reference semantics. On a side note, [Szilard Pafka gave an excellent talk at the recent R/Finance conference](https://channel9.msdn.com/Events/RFinance/RFinance-2017/No-Bullshit-Data-Science) in which he says that although the data size most work with is growing, CPU memory size is growing faster. Between accessing recent advances in CPU size with AWS and getting familiar with approaches to efficient programming, R users can bring our legacy of statistical programming to increasingly expanding modern data sets.