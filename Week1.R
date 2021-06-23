## Week 1 - Revision ##

#------------------------------------------------------------------------------#
###### Video link: https://youtu.be/gnmdIpA56Fc
#------------------------------------------------------------------------------#

# First a reminder about RStudio, and getting help with ? and ??, = vs <-, and comments

# Reading R documentation is key for this course! 
# Consult relevant documentation whenever a new function is used

#------------------------------------------------------------------------------#
# Objects and variable types
#------------------------------------------------
# Video link: https://youtu.be/P9Y_KE0I9Ag
#------------------------------------------------------------------------------#

# Data storage:
# c, character, vector, matrix, list, data frame,
# Data types:
# Numeric, integer, factors, L notation

# Going to use the str (structure) command lots

# Vectors
x <- c(2.3, -4.6, 5.7)
str(x) # A numeric vector
x <- c(1, 4, 6) # Still numeric
str(x)
x <- c(1L, 4L, 6L) # Force it to be an integer
str(x)
x[1] <- x[1] + 0.1
str(x) # Back to numeric
x <- c(FALSE, TRUE, TRUE) # Boolean/logical
str(x)

# Matrices
x <- matrix(1:4, ncol = 2, nrow = 2) # An integer matrix
str(x)
x # filled in by columns
x <- matrix(runif(4), ncol = 2, nrow = 2) # A numeric matrix
str(x)

# Indexing
x[1, ] # The first row of x
x[1, , drop = FALSE] # The first row, but keep as a matrix
x[2, 1] # The second row and the first column

str(x[1,])
str(x[1, , drop = FALSE])

# Can add row names of column names if required (assignment function)
colnames(x)
colnames(x) <- c('one', 'two')
x

# Lists (containing different objects)
x <- list(p = 1L, q = runif(4), r = c(2 + 3i, 7 - 2i))
x[2:3] # Subset of a list
# Referencing lists
x$r
x[[2]] # Alternative ways to index
x[[2]][1:2]
x$q[3:4]

# Factors (nominal and/or ordinal variables)
x <- factor(rep(1:3, length = 12), labels = c('low', 'medium', 'high'))
str(x)
x + 2 # Gives a warning

# An ordered factor
x <- factor(rep(1:3, length = 12),
           labels = c('low', 'medium', 'high'),
           ordered = TRUE)
str(x)

# Change levels (assignment function)
levels(x) <- c('small', 'medium', 'big')

# Can make a difference with various plotting functions and some statistical models

# Data frames (for storing different data types)
x <- data.frame(a = 1:4,
               col2 = runif(4),
               z = factor(rep(1:2,2), labels = c('no','yes')))
x # note how "labels" is repeated
str(x)
# A data frame is just a list but can also be referenced like a matrix
x$col2[1:3]
x[,2:3] # Second and third columns

# Can even have long names but referencing can get a big messy
names(x) <- c('A long name', 'A very long name', 'An even longer name')
x[1:3,1:2]
x$`A very long name`

# A good general rule is to use "_" as a connector
names(x) <- c('a_long_name', 'a_very_long_name', 'an_even_longer_name')
x$a_very_long_name

#------------------------------------------------------------------------------
# Writing functions
#------------------------------------------------
# Video link: https://youtu.be/cGWEaMAh9iw
#------------------------------------------------------------------------------

# The most basic
sq = function(x) return(x^2)
sq(2)

# Advantage or disadvantage? We cannot specify the types of the arguments
print_me <- function(argument) cat("The value is", argument, "\n")
print_me(3.3456)
print_me(3L)
print_me("abcd")
print_me(x)
# Bugs due to incorrect argument type are the extremely common and often difficult to 
# spot

# Multiple arguments
pow = function(x, p) return(x^p)
pow(2,2)

# Multiple lines
pow = function(x, p) { 
  return(x^p)
}
pow(2,2)
# Return is optional but highly recommended

# Default arguments
pow = function(x, p = 2) {
  return(x^p)
}
pow(2)

# Can also name them if specifying in weird order
pow(p = 3, x = 4)

# Advisable to use invisible if you don't want it to print
pow = function(x, p = 2) {
  invisible(x^p)
}
pow(3)
y = pow(3)

# If returning multiple objects use a list
pow = function(x, p = 2) {
  return(list(arguments = c(x, p), output = x^p))
}
pow(2)

# Most functions are automatically vectorised
pow(1:3)

# .. but you need to be a little bit careful
pow(x = 1:3, p = 1:3) # Works ok
pow(x = 1:3, p = 1:2) # Was that what you wanted?

#------------------------------------------------------------------------------
# Ifelse statements
#------------------------------------------------
# Video link: https://youtu.be/TMDFWztFpdg
#------------------------------------------------------------------------------

# if, ifelse
x <- runif(1)
if(x < 0.5) print('x < 0.5!')

# Can make these more complicated
x <- runif(1)
if(x < 0.5) {
  y <- rnorm(1)
  print(x*y)
}

# Can have compound statements using & (and) and | (or)
x <- runif(1)
y <- runif(1)
if( (x + y < 1) || (x*y < 0.2) ) {
  print(x + y)
  print(x*y)
}
# Make sure to add in parentheses

# Can add in else and else if statements
x <- runif(1)
if(x < 0.5) {
  print('x < 0.5')
} else {
  print('x >= 0.5')
}

# Of else-if statements
x <- runif(1)
y <- runif(1)
if(x < 0.5) {
  print('x < 0.5')
} else if(y < 0.5) {
  print('x >= 0.5 and y < 0.5')
} else {
  print('x > 0.5 and y > 0.5')
}

# If you just have something very simple can use ifelse
x <- runif(1)
ifelse(x < 0.5, 2, 1)

# You can also easily store this in a variable
y <- ifelse(x < 0.5, 2, 1)
# It can also be extended to compound statements like if above

#------------------------------------------------------------------------------
# Loops 
#------------------------------------------------
# Video link: https://youtu.be/7FqzC7noslk
#------------------------------------------------------------------------------

# for, repeat, while

# for loops
for (i in 1:10) print(i)

# Can expand with curly brackets
for (i in 1:5) {
  current <- i^2
  cat('i^2 =',current, '\n')
}

# Can nest loops together
for (i in 1:5) {
  for (j in 1:5) {
    cat('i =', i, 'j =', j, ', i*j = ',i*j, '\n')
  }
}

# Doesn't have to be a sequence in the loop
x = runif(10)
for (i in x) {
  print(i < 0.5)
}

# While loops slightly different
x = 1
while(x < 10) {
  print(x)
  x = x + 1
}
# All of the same rules as for loops apply
# Don't forget to adjust the boolean statement in the loop so you don't get stuck

# Perhaps even more basic if repeat
x = 1
repeat {
  print(x)
  x = x + 1
  if(x == 10) break
}
# Don't forget the break statement!
# Least traditional type of loop.

#------------------------------------------------------------------------------
# Plots
#------------------------------------------------
# Video link: https://youtu.be/rhwluND927g
#------------------------------------------------------------------------------

# Use the prostate data (from "The Elements of Statistical Learning: Data Mining, 
# Inference, and Prediction." by Hastie, Tibshirani, Friedman)
prostate <- read.table('https://web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data', header = TRUE)
head(prostate)

# A basic scatter plot
plot(prostate$age, prostate$lcavol)

# Change the axis labels and add a title
plot(prostate$age, prostate$lcavol,
     xlab = 'Age',
     ylab = 'Log(cancer volume)',
     main = 'Scatter plot')

# Use e.g. paste or paste0 to add in objects
var_1 <- 'age'
var_2 <- 'lcavol'
plot(prostate[,var_1], prostate[,var_2],
     xlab = var_1,
     ylab = var_2,
     main = paste('Scatter plot of',var_1,'vs',var_2))

# Change the plotting type
plot(prostate[,var_1], prostate[,var_2],
     pch = 19)
?pch # Look at different point types
plot(prostate[,var_1], prostate[,var_2],
     type = 'l') # Yuck

# Changing colours
plot(prostate[,var_1], prostate[,var_2],
     pch = 19, col = 'blue')

# Transparency
plot(prostate[,var_1], prostate[,var_2],
     pch = 19, col = rgb(1, 0, 0, alpha = 1))

# Changing some options with par
par(mar = c(2, 2, 2, 2), las = 1) # Margins - see ?par for more
plot(prostate[,var_1], prostate[,var_2])
# Be careful - these options are persistent
graphics.off() # to restore default, or equivalently:
par_default<-par(mar = c(5, 4, 4, 2) + 0.1)
par(par_default)

# Add to plots with points and lines
plot(prostate[,var_1], prostate[,var_2], type = 'n')
points(prostate[,var_1], prostate[,var_2], col='red')
lines(prostate[,var_1], prostate[,var_2], col='green')

# Add a legend
legend('topleft', legend = c('points', 'lines'),
       pch = c(1, -1),
       lty = c(-1, 1)
       col = c('red', 'green'))

# Histograms
hist(prostate$lweight, xlab="Log(weight)")

# Better bins:
hist(prostate$lweight, breaks = 30)
hist(prostate$lweight, breaks = seq(2,5, by = 0.2))

# Better x axis
hist(prostate$lweight, breaks = seq(2,5, by = 0.2), xaxt = 'n')
axis(side = 1, at = seq(2, 5, by = 0.2))

# Bar charts (called bar plots)
table(prostate$gleason)
barplot(table(prostate$gleason)) # No axis labels
barplot(table(prostate$gleason), horiz = TRUE)

# Boxplots
boxplot(prostate$lpsa)

# Careful - this does not give you what you might expect
boxplot(prostate$gleason, prostate$lpsa)
# Proper way
boxplot(prostate$lpsa ~ prostate$gleason) # this is a formula
# Lots of extra options regarding direction, style, shape, colour, etc.

# pairs - matrix scatter plots
pairs(prostate)

#------------------------------------------------------------------------------
# Regression
#------------------------------------------------
# Video link: https://youtu.be/w7TKZgD8oIM
#------------------------------------------------------------------------------

# Fit a simple regression model
lm(lpsa ~ lcavol, data = prostate)

# Doesn't have to come from a data frame
lm(prostate$lpsa ~ prostate$lcavol)

# Save as an object and then can manipulate
model1 <- lm(lpsa ~ lcavol, data = prostate)
attributes(model1)
summary(model1)

# Some of the useful things in it
model1$coefficients
model1$residuals
model1$fitted.values

# Can also directly plot but a bit confusing
plot(model1)

# Given the above though it's easy to plot the output
plot(prostate$lcavol, prostate$lpsa,
     ylab="LPSA", xlab="Log(cancer volume)")
lines(prostate$lcavol, model1$fitted.values, lwd=2, col="red")

# A binomial glm
model2 <- glm(svi ~ lcavol, data = prostate, family = binomial)
summary(model2)

#################################################

# Here are some other useful R commands and functions for you.
# I have provided code and examples so that you can work through them in your own time.
# Any specific functions or commands I think need further explaining, I have attached
# a video link.  These are much smaller videos than the topic videos throughout this
# R script.

#------------------------------------------------------------------------------
# Opening and saving files
#------------------------------------------------------------------------------

# read/write.csv, read.table, load, save, scan, saving plots with e.g. pdf

# Set working directory
setwd("~/Desktop/")
# Video link: https://youtu.be/bouEIGIY1_g
# Most useful function is probably read.csv
prostate_new <- read.csv('prostate.csv',header = TRUE)

# write.csv(prostate_new, file="prostate_new.csv", row.names=F)

# More general version is read.table
prostate = read.table('https://web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data', 
                      header = TRUE)
# Useful options: header, sep, stringsAsFactors, skip, nrows

# Load in the first 50 rows but skip the first 10
prostate2 = read.table('https://web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data', 
                       nrows = 50,
                       skip = 10)
str(prostate2)

# If you're dealing with people who only use R often safer to save directly as R format
#save(prostate, file = 'prostate.rda')
#save(prostate, file = 'path/to/my_prostate_file.rda')

# Load it back in
#load('prostate.rda')

# To save plots, use e.g. the pdf or jpeg function, create your plot then follow 
# with dev.off()
# pdf(file = 'my_plot.pdf', width = 8, height = 6)
# plot(prostate$lcavol, prostate$lpsa)
# dev.off()

# Video link: https://youtu.be/DK-V4sYDmjc

#------------------------------------------------------------------------------
# Some other useful R functions 
#------------------------------------------------------------------------------

# Video link: https://youtu.be/KCVxkzJ-xXc
# library/require
library(MASS)
help(package = 'MASS')

# Note the difference
library(bla) # Error
require(bla) # Warning

# Installing
#install.packages('bla')
#install.packages(c('bla', 'bla2'))

# apply
x <- matrix(runif(20), ncol = 2, nrow = 10)
apply(x, 1, 'sum') # rows
apply(x, 2, 'sum') # columns
# Change the function to things like mean/median.  Can be useful for summarising data.

# Lots of different versions for e.g. lists/dataframe (lapply), tapply (ragged arrays), 
# sapply (simple version of lapply)
# Much more on these later
lapply(prostate, 'prod')
# Must need to use unlist
unlist(lapply(prostate, 'prod'))
apply(prostate, 2, 'prod')

# head/tail
head(prostate)
head(prostate, 5)
tail(prostate, 2)

# aggregate
aggregate(prostate$lpsa, by = list(prostate$gleason), 'mean')
aggregate(prostate$lpsa, by = list(prostate$gleason, prostate$age), 'length')

# with
with(prostate, plot(age, lpsa))

# Combining a few functions, messily but see what they all do.

# which
gleasonweight <- aggregate(lweight ~ gleason, FUN = mean, data=prostate)
# min
gleasonweight[which.min(gleasonweight$lweight),]
# max
gleasonweight[which.max(gleasonweight$lweight),]

# Find all the locations where it matches
good <- 6
which(prostate$gleason == good)

# Find the min/max
which.min(prostate$age) # Only gives the first match

# Just find out if the value is in there
good %in% prostate$gleason

# subset
prostate3 <- subset(prostate, age < 60)

# Or more complicated
prostate4 <- subset(prostate, (age < 60) & (gleason == 6))

# scale
par(mfrow=c(1,2)) # Plot side by side (1 row, 2 columns)
hist(prostate$lpsa, breaks = 30, main="Histogram of LPSA")
# Note the difference:
hist(scale(prostate$lpsa), breaks = 30, main="Histogram of scale(LPSA)")
# Centered around zero
par(mfrow=c(1,1)) # Back to default

# Just subtract off the mean
scale(prostate$lpsa, scale = FALSE)

# Also see sweep

# cat/paste/print
print("Hello world!")
cat("Hello world!\n") # Slightly neater - \n for a new line (also \t for tab, \r for remove)
word = 'World'
cat("Hello", word, '\n')
result = paste("Hello", word, '\n')
cat(result)
result = paste("Hello", word, '\n', sep = ',')
cat(result)

# order
plot(prostate$age, prostate$lcavol, type = 'l') # Messy
ord = order(prostate$age)
plot(prostate$age[ord], prostate$lcavol[ord], type = 'l')


