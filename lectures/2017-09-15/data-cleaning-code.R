## read in raw class data
class_data <- read.csv("lectures/2017-09-15/student-data-raw.csv", stringsAsFactors = FALSE)

## look at a summary of the data
summary(class_data)

## look at group names
unique(class_data$Group)

## rename misspelled entries
misspelled_index <- which(class_data$Group=="It's To Early")
class_data$Group[misspelled_index] <- "It's too early"

## find blank group names
blank_group_index <- which(class_data$Group=="")

## fill in with random group names sampled evenly from observed values
class_data$Group[blank_group_index] <-
    sample(unique(class_data$Group)[-1],
           length(blank_group_index),
           replace=TRUE)

## find blank music entries
blank_music_index <- which(class_data$Music=="")

## fill in with the most common value
music_table <- table(class_data$Music) # makes a table of musicians by number of observances
sorted_music <- sort(music_table, decreasing = TRUE) # sorts the table
sorted_music # by looking at this we see that blank is the most common response, the most common artist is Logic, which is the second value
class_data$Music[blank_music_index] <- names(sorted_music)[2]

## find blank programming entries
blank_programming_index <- which(class_data$Programming=="")

## fill in with random samples of with same distribution as rest of class
class_data$Programming[blank_programming_index] <-
    sample(class_data$Programming[-blank_programming_index],
           size = length(blank_programming_index),
           replace = TRUE)

## save the file
write.csv(class_data, "lectures/2017-09-15/student-data-filled.csv")
