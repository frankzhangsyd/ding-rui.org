---
title: Functional Programming in R (Using purrr Package)
author: Frank
date: '2019-01-06'
slug: purrr
categories: []
tags: []
---

I wrote a [small article](https://dingruizhang.me/2018/07/25/r-scripts-for-combining-excels-file) about **purrr** packge before.

Now I think it's time to write a better article introducing the **purrr** package.

You can find the official website through this [link](https://purrr.tidyverse.org).

## Map Family

The **map** family is used to apply function or functions over a list or vector.

The "primary" function is the **map** function.

```r
library(purrr)
#Remember: map always return a list rather than a vector
test_list <- list(a=c(1,2,3),
                  b=c(2,3,4),
                  c=c(3,4,5))

map(test_list,mean)
#> $a
#> [1] 2
#> 
#> $b
#> [1] 3
#> 
#> $c
#> [1] 4
```
<!--more-->
**map** takes 3 arguments which are **.x**,**.f**,**...**.

**.x** is the list or vector you want to apply function on.  

**.f** is the function you want to apply.  

**...** is the arguments you want to specify in **.f**.  

```r
library(purrr)
test_list <- list(a=c(1,2,NULL),
                  b=c(2,3,4),
                  c=c(3,4,5))

map(test_list,mean,na.rm=TRUE)
#> $a
#> [1] 1.5
#> 
#> $b
#> [1] 3
#> 
#> $c
#> [1] 4
```

Another good thing is that you can use lambda function in **.f** part. All you need to is:
1. Add "~" before you lambda function
2. Use ".x" in **.f** to specify the location.

``` r
library(purrr)
test_list <- list(a=c(1,2,3),
                  b=c(2,3,4),
                  c=c(3,4,5))

map(test_list,~.x+5)
#> $a
#> [1] 6 7 8
#> 
#> $b
#> [1] 7 8 9
#> 
#> $c
#> [1]  8  9 10
```

Other **map\_** functions are similar to **map**. You just need to specify the output type.
``` r
library(purrr)
test_list <- list(a=c(1,2,3),
                  b=c(2,3,4),
                  c=c(3,4,5))

map_dbl(test_list,sum)
#>  a  b  c 
#>  6  9 12
```
Now it returns a vector rather than a list.

## Manipulate Functions

Another good thing in purrr is that you can manipulate functions. Yes, you can manupulate functions just as other objects in R!It is really fantastic.

##### Create Function From Lambda
**as_mapper** enables you to create a function quickly and make your code cleaner and more readable.
``` r
library(purrr)
new_fc <- as_mapper(~(.x*100+1)/2)
new_fc(1)
#> [1] 50.5
```

##### Compose Function
**compose** enables you to connect a function from other existing functions.
``` r
library(purrr)
test_list <- list(a=c(1,2,3),
                  b=c(2,3,4),
                  c=c(3,4,5))
mutiply100 <- as_mapper(~.x*100)

mean_multiply100 <- compose(mutiply100,mean)
map_dbl(test_list,mean_multiply100)
#>   a   b   c 
#> 200 300 400
```
Please note the equivalent of **compose(round,mean)** is **round(mean(x))**. The order here is important.

##### Create Function with Default Arguments
``` r
library(purrr)
my_mean <- partial(mean,na.rm=TRUE)
my_mean(c(1,2,3,NULL))
#> [1] 2
```
Now **my_mean** is the **mean** function with default argument to ignore all **NULL** in calculating mean value of a vector.

##### Negate a Predicate Function
Predicate Function is the function that returns a logical output like **TRUE** or **FALSE**.
Such as **is.numeric()**,**is.character()**.

**negate** makes your life easy because you don't need to write a second function!

``` r

library(purrr)
test_list <- list(a=c(1,2,0.5),
                  b=c(2,3,4),
                  c=c(3,4,5))
mean_over_2 <- as_mapper(~mean(.x)>=2)
mean_under_2 <- negate(mean_over_2)
map_lgl(test_list,mean_over_2)
#>     a     b     c 
#> FALSE  TRUE  TRUE
map_lgl(test_list,mean_under_2)
#>     a     b     c 
#>  TRUE FALSE FALSE
```









