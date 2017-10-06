## Finding associations sample code
## by Steve Lauer

## Linear models are a commonly used way of finding associations between variables.
## There are entire courses devoted to this, so I won't cover much of that today.
## Instead, I'd like to bring attention to the fact that linear models are but one
## of many tools to help you figure out whether and how much your variables are
## associated with one another.

## load up some helpful libraries, if you don't have either of these, run the
## commented out code
# install.packages("ggplot2")
library(ggplot2)
# install.packages("dplyr")
library(dplyr)

## set seed for reproducibility
set.seed(1)

## Look at the datasets that are available in R
library(help="datasets")

## choose a dataset and load it with data()
data("ToothGrowth")
View(ToothGrowth)

## visualize the data (as we learned last class)
ggplot(data=ToothGrowth) +
    geom_point(aes(y=len, x=dose, color=supp), alpha=0.5) +
    scale_x_continuous("Dosage") +
    scale_y_continuous("Tooth length") +
    scale_color_discrete("Supplement") +
    ggtitle("Guinea pig tooth growth\nby supplement and dosage") +
    theme_bw() +
    theme(plot.title = element_text(size=14, hjust=0.5))
## here we see that there could be an association between tooth length and dosage,
## tooth length and supplement, or between all 3. Let's go through each.

## 1) Let's make a hypothesis: "there is a (positive) relationship between tooth
## length and dosage."
## How do we go about testing that hypothesis? These are both continuous variables,
## so we can use some of the methods used in this week's homework:
cor(ToothGrowth$len, ToothGrowth$dose)
## That's some strong correlation!

## Let's see how the linear model fits:
tg_lm <- lm(len~dose, data=ToothGrowth)
summary(tg_lm)

## we'll extend this further in part 3...

## it's easier to visualize lm in ggplot2 than in the base package (IMO)
ggplot(data=ToothGrowth) +
    geom_point(aes(y=len, x=dose), alpha=0.5) +
    geom_smooth(aes(y=len, x=dose), method="lm")

## 2) Is there a relationship between tooth length and supplement type?
## Null hypothesis: there is no difference between the
## compare the means
mean(ToothGrowth$len[ToothGrowth$supp=="OJ"])
mean(ToothGrowth$len[ToothGrowth$supp=="VC"])

## code for dplyr
average_supp_len <- ToothGrowth %>%
    group_by(supp) %>%
    summarise(average_length=mean(len))
average_supp_len

## find the difference of the means
average_supp_len$average_length[1]-average_supp_len$average_length[2]
## Is 3.7 big? There's no context!

## Instead of doing a linear model (which would also work), let's do a permutation
## test. This is a clever concept. Basically, what if we didn't know which gerbil
## was assigned to which group? If they were randomly assigned, what are the chances
## that we see a differences as large as 3.7?
tg_random_assignment <- ToothGrowth %>%
    mutate(fake_supp = sample(rep(c("OJ", "VC"),30),60,replace=FALSE)) %>%
    group_by(fake_supp) %>%
    summarise(average_fake_len = mean(len))
tg_random_assignment$average_fake_len[1]-tg_random_assignment$average_fake_len[2]
## 2.86 < 3.7
## Could run this 100 or 1000 times to find the likelihood of more extreme values.
## There are programs that allow you to do this more quickly and easily.

install.packages("perm")
library(perm)
?permTS

## probability that the two are the same
permTS(len~supp, data=ToothGrowth, alternative="two.sided", exact=TRUE)

## the probability that VC ≥ OJ
permTS(len~supp, data=ToothGrowth, alternative="greater", exact=TRUE)

## 3) Incorporating both variables. Maybe you want to know what the true effect of
## supplement is, given a certain dosage (or vice versa). Do either effects go away
## when both are in the model?
## Some would argue that a model that can't predict the tooth length for new gerbils
## (not in your data), wouldn't be an accurate model. So you want a model that
## does a good job fitting and predicting!

## Before we do anything, I'm going to make a "junk" variables for use later
tg2 <- ToothGrowth %>%
    mutate(junk = rnorm(60))

## We break up our data into "training" and "testing" sets
training_idx <- sample(1:nrow(tg2), nrow(tg2)/2, replace=FALSE)
train_set <- tg2[training_idx,]
test_set <- tg2[-training_idx,]

## Let's make a few linear models
train_null_lm <- lm(len~1, data=train_set) # a null model (no independent covariates)
summary(train_null_lm)
train_cov_lm <- lm(len~dose+supp, data=train_set) #  with two covariates
summary(train_cov_lm)
train_interact_lm <- lm(len~dose*supp, data=train_set) # with interaction term
summary(train_interact_lm)
train_junk_lm <- lm(len~dose*supp+junk, data=train_set) # with junk
summary(train_junk_lm)
## none of the junk covariates are significant, but R-squared gets higher!

## now let's predict the test set with our training linear models
test_null <- predict(train_null_lm, test_set)
test_null
test_cov <- predict(train_cov_lm, test_set)
test_cov
test_interact <- predict(train_interact_lm, test_set)
test_interact
test_junk <- predict(train_junk_lm, test_set)
test_junk

## We can use mean squared error to measure which predictions performed best!
mean((test_null-test_set$len)^2)
mean((test_cov-test_set$len)^2)
mean((test_interact-test_set$len)^2)
mean((test_junk-test_set$len)^2)
