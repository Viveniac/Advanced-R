## Week 4 - magrittr ##

#------------------------------------------------
# Video link: https://youtu.be/a8eeUFiqsWA
#------------------------------------------------

# Sources
# Why bother with magrittr: http://civilstat.com/2015/10/why-bother-with-magrittr/
# Pipes: http://blog.revolutionanalytics.com/2014/07/magrittr-simplifying-r-code-with-pipes.html
# Magrittr vignette https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html

#------------------------------------------------------------------------------#
# Introducing magrittr
#------------------------------------------------------------------------------#

# Why use this? Let's start with an example

# A common function use in classification is the logsumexp function
# It's not in the base package but is in lots of fancier matrix and others

# At its simplest the function is log( sum ( exp( some_data ) ) )
# So first exponentiate, then sum, then log
my_vec <- 1:4
log(sum(exp(my_vec)))

# There's a bit of cognitive overload associated with this function as you have to read 
# from right to left to see what's happening with your data

# Enter magrittr
library(magrittr)
my_vec %>% exp %>% sum %>% log

# We've re-written the function from left to right in a 'readable' order.
# The operators are separated by %>% - known as pipes.
# Far fewer brackets - much more easily readable code.
# Those of you who are familiar with other programming languages will be used to using 
# pipes.

# This will change the way you write R code!

#------------------------------------------------------------------------------#
# magrittr: The Basics
#------------------------------------------------
# Video link: https://youtu.be/EOl6lVXAcyU
#------------------------------------------------------------------------------#

# The key to magrittr is understanding the pipe %>%
# Here are some simple examples
my_vec %>% log
my_vec %>% sum
my_vec %>% ( function(x) x^2 ) # Don't forget parentheses
my_fun <- function(x, y = 2) x*y
my_vec %>% my_fun
my_vec %>% my_fun(y = 4)
my_fun2 <- function(x, y) x*y
# my_vec %>% my_fun2 # This will not work
my_vec %>% my_fun2(y = -1)
my_vec %>% my_fun2(x = 3) 

# You can then chain them up for real fanciness
my_vec %>% log %>% sum
my_vec %>% my_fun2(y = 4) %>% exp

# Magrittr has some alias functions which are useful for everyday commands
rnorm(1000) %>%
  multiply_by(7) %>%
  add(6) %>%
  hist

# You can also use slightly shorter (but uglier) code:
rnorm(1000) %>%
  '*'(7) %>%
  '+'(6) %>%
  hist

# You can also assign these things to objects for manipulation
hist_dat <- rnorm(1000) %>%
  '*'(7) %>%
  '+'(6) %>%
  hist

#------------------------------------------------------------------------------#
# magrittr: Typical Workflow
#------------------------------------------------
# Video link: https://youtu.be/wE7Aj3s1lIY
#------------------------------------------------------------------------------#

# Have a look at the mtcars data set
head(mtcars)

# Consider the following things you want to do:
# 1) Transform miles per gallon into km per litre (by multiplying it by 0.4251).
# 2) Taking only those cars with horsepower bigger than 100.
# 3) Aggregating the data set by cylinders and computing the means of all the remaining 
#    variables.
# 4) Saving this new data set into a data frame.

# Let's do it the traditional way:
my_data <- mtcars
my_data$kpl <- my_data$mpg * 0.4251
my_data2 <- subset(my_data, hp > 100)
my_data3 <- aggregate(. ~ cyl, data = my_data2, FUN = 'mean')

# Or alternatively in one big line:
my_data4 <- transform(aggregate(. ~ cyl,
                               data = subset(mtcars, hp > 100),
                               FUN = mean),
                     kpl = mpg * 0.4251)

# Now the magrittr way:
my_data5 <- mtcars %>%
  subset(hp > 100) %>%
  aggregate(. ~ cyl, data = ., FUN = 'mean') %>%
  transform(., kpl = mpg %>% multiply_by(0.4251))

# A few things to note about the above:
# - Notice that . is used everywhere to mark the full data frame.
# - The within statement (can be used instead of transform) allows us to create a 
#   new variable (within is a base function) whilst keeping the whole data frame 
#   (different from with).
# - We can use nested chains of %>% inside other functions!

# Let's see which is faster
fun1 <- function() {
  my_data4 <- transform(aggregate(. ~ cyl,
                                 data = subset(mtcars, hp > 100),
                                 FUN = function(x) round(mean(x, 2))),
                       kpl = mpg*0.4251)
}
fun2 <- function() {
  my_data4 = mtcars %>%
    subset(hp > 100) %>%
    aggregate(. ~ cyl, data = ., FUN = 'mean') %>%
    transform(., kpl = mpg %>% multiply_by(0.4251))
}
system.time(replicate(1e6, fun1))
system.time(replicate(1e6, fun2)) # Almost identical
# You don't lose any speed by using magrittr

#------------------------------------------------------------------------------#
# Aliases
#------------------------------------------------
# Video link: https://youtu.be/xGh9HDmWDUs
#------------------------------------------------------------------------------#

# I can never remember what all the different aliases do and how they work: the doc 
# file associated to any of these (e.g. ?multiply_by) provides a useful list.

# First extract
mtcars %>% extract(,1)            # Same as [ - here mtcars[,1]
mtcars %>% '['(,1)                # Exactly the same but less readable
mtcars %>% extract('wt')          # Or by name
mtcars %>% extract(c('wt', 'am')) # Or multiple names
mtcars %>% extract(4, 3)          # Same as mtcars[4, 3]

# Now extract2 - same as '[[' - i.e. indexing a list
mtcars %>% extract2(1) 
# Now returns it as a vector - same as mtcars[[1]]

# inset - add or modify the variables in a data.frame
mtcars %>% inset('new_value', value = rnorm(nrow(.))) 
# Same as mtcars$new_value = rnorm(nrow(mtcars))
# inset2 - similar purpose for lists

# use_series same as $
mtcars %>% use_series('wt')

# add/subtract/multiply_by/raise_to_power/divide_by
# All pretty obvious
mtcars %>% within(., wt <- wt %>% add(200)) %>% head

# and, or, equals, is_greater_than, is_weakly_greater_than
mtcars %>% subset(cyl %>% is_weakly_greater_than(6))
mtcars %>% subset(and(mpg %>% is_greater_than(21), cyl %>% is_weakly_less_than(6)))

# Set colnames, etc
mtcars %>% extract(,1:2) %>% set_colnames(c('miles per gallon', 'cylinders'))

#------------------------------------------------------------------------------#
# Other pipes
#------------------------------------------------
# Video link: https://youtu.be/fYekTTgPDO8
#------------------------------------------------------------------------------#

# %T>% for returning the other side. Try
mtcars %>% extract(, 1)
mtcars %T>% extract(, 1) # Returns the left hand side instead

ans1 <- mtcars %>%
  subset(hp > 100) %>%
  extract(, 1:2) %>%
  plot
# Nothing saved in ans1

# Compare with this (watch out for the %T>%)
ans2 <- mtcars %>%
  subset(hp > 100) %>%
  extract(, 1:2) %T>%
  plot
# More useful - ans2 contains something

# The %$% operator - exposes the names to the right hand side
mtcars %>%
 subset(hp > 100) %>%
 cor(cyl, disp)
# Doesn't work!
mtcars %>%
  subset(hp > 100) %$%
  cor(cyl, disp)
# Works properly.
# Use this whenever you want to refer to variable names in a subsequent step but 
# it's not passing them properly.
# Will likely occur whenever there isn't a data argument in a function.

# The %<>% operator - saves a bit of typing

# Previously
mtcars2 <- mtcars
mtcars2 <- mtcars %>% within(., wt <- wt %>% add(200))

# Now
mtcars3 <- mtcars
mtcars3$wt %<>% add(200)

#------------------------------------------------------------------------------#
# Other clever features
#------------------------------------------------
# Video link: https://youtu.be/X5cF9Y8zzwo
#------------------------------------------------------------------------------#

# Piping into functions
mtcars %>%
  (function(x) {
    if (nrow(x) > 2)
      rbind(head(x, 1), tail(x, 1))
    else x
  })

# Equivalent to:
my_fun <- function(x) {
  if (nrow(x) > 2)
    rbind(head(x, 1), tail(x, 1))
  else x
}
my_fun(mtcars)

mtcars %>% my_fun

# Another example
mtcars %>% {
  n <- sample(1:10, size = 1)
  H <- head(., n)
  T <- tail(., n)
  rbind(H, T)
  } %>%
  summary

# This is the same as:
my_fun <- function(x) {
  n <- sample(1:10, size = 1)
  H <- head(x, n)
  T <- tail(x, n)
  return(rbind(H, T))
}
summary(my_fun(mtcars))

mtcars %>% my_fun %>% summary

# Using magrittr to create functions
mae <- . %>% abs %>% mean(na.rm = TRUE)
mae(rnorm(10))

# That’s equivalent to:
mae <- function(x) {
  mean(abs(x), na.rm = TRUE)
}
mae(rnorm(10))

# Or, for more complicated functions which return multiple arguments
med_mean <- . %>%  { c(median(.), mean(., na.rm = TRUE)) }
med_mean(rnorm(10))

# End ---------------------------------------------------------------------
