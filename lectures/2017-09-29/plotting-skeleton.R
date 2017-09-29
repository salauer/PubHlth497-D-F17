## Plotting sample code
## by Steve Lauer

## If you don't have ggplot2 install it
install.packages("ggplot2")

## Once you have it put it in your library
library(ggplot2)

## Look at the datasets that are available in R
library(help="datasets")

## Choose a dataset and load it with data()
data("ToothGrowth")

## Check out the dataset
View(ToothGrowth)
?ToothGrowth

## Two dimensions are numeric, one is a factor
## What kind of plots could we make?
## Check out http://www.cookbook-r.com or http://sape.inf.usi.ch/quick-reference/ggplot2/
