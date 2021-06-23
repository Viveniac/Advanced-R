# Week 4 Exercises #

## EX 1 --------------------------------------------------------------

# The function below to takes 1000 uniform random variables, converts them 
# to normal using qnorm, then produces a histogram. 
# Re-write it in magrittr format 
hist(qnorm(runif(1000)), breaks = 30)

## EX 2 --------------------------------------------------------------

# Take the iris data (included by default in R) and write magrittr code that:
# 1) takes only those observations with sepal width > 3
# 2) computes the Petal.area as pi * Petal.length / 2 * Petal.width / 2
# 3) aggregates to produce the median Petal.area across species

## EX 3 --------------------------------------------------------------

# Write magrittr code to find the following subsets in the mtcars data set
# All cars with disp < 200 or wt > 3.3
# All cars with gear greater than or equal to 4 and cylinders equal to 6

## EX 4 --------------------------------------------------------------

# Here is a pretty inelegant function that provides the negative log likelihood 
# for a given vector assuming the data come from a N(0, 1) distribution
nll = function(x) -1 * sum(log(dnorm(x)))
nll(rnorm(10))
# Re-write nll in magrittr format

