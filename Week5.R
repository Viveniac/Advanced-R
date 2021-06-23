## Week 5 - dplyr ###

#------------------------------------------------
# Video link: https://youtu.be/2cuP1HRmNTM
#------------------------------------------------

# Sources
# dplyr vignette: https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html
# dplyr introduction: https://blog.rstudio.org/2014/01/17/introducing-dplyr/

#------------------------------------------------------------------------------#
# dplyr
#------------------------------------------------------------------------------#

# A really useful package for manipulating large data sets
library(dplyr)

# Just a few main functions:
# filter/slice
# arrange
# select and rename
# distinct
# mutate and transmute
# summarise
# sample_n and sample_frac
# group_by

# You can use dplyr with magrittr for readable and powerful code
library(magrittr)

# Let's use the adult dataset from: https://archive.ics.uci.edu/ml/datasets/adult
adult <- read.table('https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data', sep = ',', strip.white = T)
colnames(adult) <- c('age', 'workclass', 'final_weight', 'education', 'education_num', 
                     'marital_status', 'occupation', 'relationship', 'race', 'sex', 
                     'capital_gain', 'capital_loss', 'hours_per_week', 'native_country', 
                     'class')
# Note that the argument strip.white = T is getting rid of white strips within the data.

adult %<>% as_tibble # now the data.frame is a tibble

# Get much neater output for big data sets
head(adult)
# Now same as
adult
# Note that this is a tibble, formed via as_tibble

# You can look at a tibble by either printing it like above or with
glimpse(adult)

# Tibbles are nicer for printing and also for warning
mtcars$something_else # NULL
adult$something_else # Warning message!

#------------------------------------------------------------------------------#
# Filter and arrange
#------------------------------------------------
# Video link: https://youtu.be/iVmOtRzZsH0
#------------------------------------------------------------------------------#

# filter - like subset but neater - make this as long as required
filter(adult, education == 'Masters', age == 35)
filter(adult, education == 'Masters', age == 35, sex == 'Female')

# Easy to change into magrittr format
adult %>% filter(education == 'Masters', age == 35, sex == 'Female')

# Now go back and compare with base R code
adult[adult$education == 'Masters' & adult$age == 35 & adult$sex == 'Female', ]

# You might think: why am I not using subset? Well filter is neater because it takes as 
# many arguments as you like and joins them together with &.

# You can do the same thing as subset though by combining boolean operators
adult %>% filter(education == 'Masters' & age == 35 & sex == 'Female')
# or, uglier
adult %>% filter(and(education %>% equals('Masters'), and(age %>% equals(35), 
                                                          sex %>% equals('Female'))))

# Or replace 'and' with 'or'
adult %>% filter(education == 'Masters' | age == 35)

# Use slice to extract specific rows
slice(adult, 1)
slice(adult, 5:10)
slice(adult, nrow(adult))
slice(adult, n()) # n() used here for the number of rows
adult %>% slice(1:2)

# arrange
# R is a pain to sort by multiple columns in a data.frame; arrange makes this easier
arrange(adult, age)
arrange(adult, age, hours_per_week)

# Use desc for decreasing
arrange(adult, desc(age))

# Neater magrittr version
adult %>% arrange(age %>% desc)

# This code is more readable than base R!

#------------------------------------------------------------------------------#
# Select, distinct and mutate
#------------------------------------------------
# Video link: https://youtu.be/mhb4t4FCXf4
#------------------------------------------------------------------------------#

# select is a quick way of looking at the columns of interest
adult %>% select(age, marital_status, class)

# Can also store in an object
adult_small <- adult %>% select(age, marital_status, class)
adult_small # Also a tibble

# select allows for indexing on names
adult %>% select(age:occupation)

# ... and negation of said indexes
adult %>% select(-(age:capital_loss))

# If you've got large numbers of columns then you can use some clever arguments
adult %>% select(ends_with('s'))
adult %>% select(ends_with('ss'))
adult %>% select(starts_with('c'))
adult %>% select(contains('capital'))
# Also matches, which allows for a regular expressions

# Remember: filter for selecting rows, select for selecting columns

# A related function to select is rename which will rename a column
adult %>% rename(weekly_hours = hours_per_week)

# Use distinct as a (supposedly) much faster alternative to unique
adult %>% distinct(age)

# How much faster? - not at all
system.time(replicate(1e3, adult %>% distinct(age)))
system.time(replicate(1e3, unique(adult$age)))

# you can also do it with multiple arguments
adult %>% distinct(education, native_country)

# Is this faster?
system.time(replicate(1e2, adult %>% distinct(education, native_country)))
system.time(replicate(1e2, adult %>% extract(c('education','native_country')) %>% unique))
# Now distinct seems to be faster

# Add new columns with mutate
adult %>% mutate(minutes_per_week = hours_per_week * 60) %>% select(age, minutes_per_week)

# You can get round using the select command above by using transmute instead
adult %>% transmute(minutes_per_week = hours_per_week * 60)

#------------------------------------------------------------------------------#
# Summarise, sample and group_by
#------------------------------------------------
# Vidoe link: https://youtu.be/pP4OvgIB2w0
#------------------------------------------------------------------------------#

# Use sample_n and sample_frac to take samples of rows

# sample_n for a fixed number
adult %>% sample_n(10) # 10 random rows

# sample_frac for a proportion
adult %>% sample_frac(0.01)

# use replace = TRUE for a bootstrap sample
adult %>% sample_frac(0.01, replace = TRUE)

# group_by transforms the tibble into a grouped tibble, then summarise aggregates the values
adult %>% group_by(marital_status) %>% summarise(count=n(), mean_age = age %>% mean(na.rm = TRUE))

# example:
library(ggplot2)

adult2 <- adult %>% 
  group_by(education_num, age) %>% 
  summarise(count = n(), proportion_over_50k = class %>% as.numeric %>% subtract(1) %>% mean)

ggplot(adult2, aes(x = education_num, y = age, col = proportion_over_50k, size = count)) + 
  geom_point(position = 'jitter') +
  xlab('Education level')

# End -------------------------------------------