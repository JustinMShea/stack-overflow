S3 method for class vector in R
================

[Question Link](https://stackoverflow.com/questions/45521273/s3-method-for-class-vector-in-r)
---------------------------------------------------------------------------------------------

Is it possible to create an S3 method for all vector types at once? I.e. one that is called for a numeric, integer, character etc. vector. Something like this:

``` r
first_element <- function(x, ...){
  UseMethod("first_element", x)
}

first_element.vector <- function(x){
  x[1]
}

first_element(1:3)
```

Answer
------

By type, I assume you mean `class`. The `structure` function will allow you to define multiple classes of a vector.

First, create some data and look at its class.

``` r
set.seed(1)
vector <- rnorm(100, mean = 1, sd = 3)
class(vector)
```

    ## [1] "numeric"

``` r
head(vector)
```

    ## [1] -0.8793614  1.5509300 -1.5068858  5.7858424  1.9885233 -1.4614052

Now use the structure function on your vector to define additional classes. Then check the class again and call str function to see the classes and data of the new\_vector object.

``` r
new_vector <- structure(vector, class = c("character", "integer", "numeric", "double"))

class(new_vector)
```

    ## [1] "character" "integer"   "numeric"   "double"

``` r
head(new_vector)
```

    ## [1] -0.8793614  1.5509300 -1.5068858  5.7858424  1.9885233 -1.4614052
