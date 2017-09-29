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

library(dplyr)

ggplot(data=ToothGrowth) +
    geom_bar(aes(x=as.factor(dose), y=len), fill="blue", stat="identity")


?geom_boxplot
ggplot(data=ToothGrowth) +
    geom_boxplot(aes(x=as.factor(dose), y=len), color="blue")

ggplot(data=ToothGrowth) +
    geom_boxplot(aes(x=as.factor(dose), y=len, color=supp))

?scale_x_discrete
ggplot(data=ToothGrowth) +
    geom_boxplot(aes(x=as.factor(dose), y=len, color=supp)) +
    scale_x_discrete("Dosage") +
    scale_y_continuous("Tooth length") +
    scale_color_discrete("Supplement type")

?theme
ggplot(data=ToothGrowth) +
    geom_boxplot(aes(x=as.factor(dose), y=len, color=supp)) +
    scale_x_discrete("Dosage") +
    scale_y_continuous("Tooth length") +
    scale_color_discrete("Supplement type") +
    theme(axis.text.x = element_text(size=20, color="red3"))
