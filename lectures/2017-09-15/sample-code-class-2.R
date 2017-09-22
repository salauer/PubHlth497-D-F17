## Sample code for class on 9/15/2017

## find out where your "working directory" is
getwd()

## you can change your working directory using setwd()
setwd("Downloads/2017-09-15/")
getwd()

## when you read in a file, the path can be relative to your working directory or absolute from your desktop
## make sure that you know where your working directory is when reading in files
## if the path is wrong, you will get an error
student_data <- read.csv("student-data-filled.csv", stringsAsFactors = FALSE)

student_data <- read.csv("2017-09-15/student-data-filled.csv",
                         stringsAsFactors = FALSE) # the default is to read in strings (characters) as ordered factors, which is often not what you want see help(read.csv) for more details

## use str() and summary() are good ways to see the structure and summarize your data
str(student_data)
summary()

## try using the table() function on a column of your data to see what it does
table(student_data$Beach)

## unique() will give you a vector of unique values in your vector
unique(student_data$Group)
