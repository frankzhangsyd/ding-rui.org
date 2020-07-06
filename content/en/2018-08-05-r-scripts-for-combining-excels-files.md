---
title: R Scripts for Combining Excels Files
author: Frank
date: '2018-08-05'
slug: r-scripts-for-combining-excels-files
---
Excel format file might be the most common one you will face in the business or accouting job. Here are some tips on how to combine excels files using R.

#### Preparation
There are two packages we need-`tidyverse` and `readxl` all created by [Hadley Wickham](http://hadley.nz/ "Hadley Wickham")

If you are interested in more of them, feel free to go to their documentation [readxl](https://cran.r-project.org/web/packages/readxl/readxl.pdf "readxl") and [tidyverse](https://cran.r-project.org/web/packages/tidyverse/tidyverse.pdf "tidyverse")

#### Let's Do It!
![](/en/2019-08-05-r-scripts-for-combining-excels-files_files/challenge.png)

##### 1. Get the Path of Excel Files

```r
#Always remember to use forward slash "/" in R
> excel_path <- list.files('C:/Blog example',pattern = '*.xlsx',full.names = TRUE)
[1] "C:/Blog example/example1.xlsx" "C:/Blog example/example2.xlsx"
[3] "C:/Blog example/example3.xlsx"
```
The `list.files` function will help you easily list the path or names of files in a folder. If you only want the names of the file, just change to `full.names = FALSE`.

Now we have the full path of the files.

##### Open and Combine
```r
> combine_excel <- map_df(excel_path,~read_xlsx(.,sheet = 1,col_types = c('text')))
```

![](/en/2018-08-05-r-scripts-for-combining-excels-files_files/Capture-3-279x300.jpg)

The function we use here is `read_xlsx` from `readxl` and `map_df` from `purrr`(included in tidyverse)

###### read_xlsx()
```r
read_xlsx(path, sheet = NULL, range = NULL, col_names = TRUE,
  col_types = NULL, na = "", trim_ws = TRUE, skip = 0, n_max = Inf,
  guess_max = min(1000, n_max))
```
The main arguments here are `path` and `sheet`.

`path` is the full path of the Excel file. If you are too lazy to get the full path, you can use `file.choose()` function to pop up a file select window.

`sheet` can be the sheet index or name.
You can also use `excel_sheets()` to get the sheet name like this.
```r
> excel_sheets('C:/Blog example/example1.xlsx')
[1] "Orders"
```

Sometimes you also need to specify the `col_types`. `read_xlsx()` will guess the first couple rows to determine the type of that column. Refer to my experience, it can easily trigger problem. I always import all of them as text.

###### map_df()
`map_df()` is one of the `map` family function in `purrr` package, which is a nice functional programming toolkit for R.

There are couple funtions of `map` family like `map_chr()`,`map_df()`,`map_dbl()` etc. You might notice the difference the last 3 characters of each function. It means the type of output expected. Here we expect the Excel can be combined in one big dataframe(tibble), we choose using `map_df()`.

All `map` family have similar arguments`.x` and `.f`.

`.x` is the list of arguments that you will put in the function applied. Here the `.x` is the `path` of `read_xlsx()`
`.f` is the function you are going to apply on `x`. If you don't have any arguments need to pass to the function,you can simply use the name of function(do not include brackets).

```r
> map_df(excel_path,read_xlsx)
```
But what if we need to pass another or more same arguments for `.x`?

Just add `~` before `.f` and specify the arguments inside the `.f`. And remember use `.` to occupy the postion of `.x` in `.f`.

```r
map_df(excel_path,~read_xlsx(.,sheet = 1,col_types = c('text')))
```
When R read there 3 Excel files in `excel_path`,`read_xlsx()` will use same arguments `sheet=1` and `col_types=c("text")`.

You can also do this in the old traditional way though `for` loop. But the functional programming way will make your code more easy to read and save your time to focus on data rather than coding.

![](/en/2018-08-05-r-scripts-for-combining-excels-files_files/cat_gif_1.gif)


