# Week 3 Exercises #

## EX 1 --------------------------------------------------------------
# Load in the package - install if necessary
library(ggplot2)
library(reshape2)
# We will use data on fuel economy
str(mpg)
?mpg

# I want to create a boxplot of miles per gallon (hwy) for each manufacturer. 
# Fill in the blanks [A] and [B]:

ggplot(mpg, aes([A], hwy)) + geom_[B]()

# I want to create a histogram of engine size (displ) by transmission (trans). 
# Fill in the blanks [A] and [B]:

ggplot(mpg, aes([A] = displ)) +
   geom_histogram() +
   facet_wrap( ~ [B])

# EX 2 --------------------------------------------------------------

# Play with some colour gradients. Start with
p = ggplot(mpg, aes(x = displ, y = hwy, colour = hwy)) + geom_point()

# I want to create a colour gradient that goes from white (low hwy) to blue 
# to black (high hwy)
# What col_palette should go in the blank [C]?
p + scale_colour_gradientn(colours = [C])

# Write a ggplot function which uses label as an aesthetic argument and adds 
# a geom_text geom to add the drive type (drv) as the plotting symbols.

