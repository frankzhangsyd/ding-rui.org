---
title: A Simple Way to Call VBA Macro and Pass Arguments From R and Python
author: Frank
date: '2019-06-12'
slug: macro-python-r
categories: []
tags: []
---

Sometimes you may encounter huge legacy VBA codes and you are so redundant to re-develop them in other languages (ie. R and Python). However, you really want to add running VBA codes in your workflow. Now there is a simple solution for R and Python. (Tested on Windows OS)

## Sample VBA code

We have following macro.
```r

Public Sub Test_Add(Arg1, Arg2)
Sheets(1).Range("a1").Value = Arg1 + Arg2
End Sub

```
We would like to pass the 2 numbers to this macro and write the value in the excel book.

## For R
<!--more-->
```r
# Install package (Not avaliable on CRAN at 12 June 2019)
devtools::install_github("omegahat/RDCOMClient")
library(RDCOMClient)

# Create Excel Application
xlApp <- COMCreate("Excel.Application")

# Open the Macro Excel book
xlWbk <- xlApp$Workbooks()$Open("E:/Test.xlsm")# Change to your directory


# its ok to run macro without visible excel application
# If you want to see your workbook, please set it to TRUE
xlApp[['Visible']] <- TRUE 

# Run the macro called "MyMacro": and Pass 10 and 30 as argument
# Successful return would be NULL
xlApp$Run("Test_Add",10,30)
#> NULL 

# Close the workbook and quit the app:
xlWbk$Close(FALSE)# not save and close excel book
xlWbk$close(TRUE) # save and close excel book
xlApp$Quit()

```

## For Python

```python
# Import packages
import os
import win32com.client

# Create Excel Application
xlApp=win32com.client.Dispatch("Excel.Application")

# In default, Python open excel book visibly.
xlApp.Workbooks.Open(Filename="E:\Test.xlsm")
#< <COMObject Open>

# Same as R code
xlApp.Application.Run("Test_add", 100,310)
```



