## Week 1 - ggplot2 ##

# Video link: https://youtu.be/W7-Oh79spEE

# Resources for this lecture
# The ggplot2 documentation at: https://ggplot2.tidyverse.org/
# The introduction guide by Matloff: http://heather.cs.ucdavis.edu/~matloff/GGPlot2/GGPlot2Intro.pdf
# Stack overflow ggplot2: http://stackoverflow.com/questions/tagged/ggplot2
# Rstudio cheat sheet: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# ggplot2 extensions: https://exts.ggplot2.tidyverse.org/gallery/

#------------------------------------------------------------------------------#
# ggplot2 - The Basics
#------------------------------------------------
# Video link: https://youtu.be/VxtU69far9M
#------------------------------------------------------------------------------#

# Load in the package - install if necessary
library(ggplot2)

# ggplot has two main functions, qplot and ggplot.
# qplot (quick plot) is supposed to be a replacement for plot but it doesn't really 
# work as well.
# ggplot however is a fantastically rich plotting method that is a massive improvement 
# over base R.

# The key to ggplot is to have a data frame
# We will use one that comes with the package on fuel economy
str(mpg)
?mpg

# Here is some code to produce a cool plot in ggplot2. Just run it - don't 
# worry about what it does yet
ggplot(mpg, aes(x = displ, y = hwy, colour = as.factor(cyl))) +
  geom_point() +
  xlab('Engine size') +
  ylab('Highway miles per gallon') +
  stat_smooth() +
  scale_color_discrete(name="Number of\ncylinders")

# All you need for a ggplot is a data frame, an aesthetic, and a geom.
# An aesthetic is just a list of the variables in your plot, and possible colours, 
# groups or fill types.
# A geom is just a geometric object that ggplot will create. Without the geom, you won't 
# get anything on the plot.
# Different commands in ggplot are separated by + which seperates everything out into 
# layers.

# Let's start by creating a simple scatter plot of displ (engine size) vs hwy (highway 
# miles per gallon).
ggplot(mapping = aes(x = displ, y = hwy), data = mpg) +
  geom_point() 
# So geom_point draws a scatter plot.

# geom_line by contrast draws lines.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_line()

# Here's the clever thing: we can store the first function call in an object and 
# then add to it if we want to change things.
my_plot <- ggplot(mpg, aes(x = displ, y = hwy))
my_plot2 <- my_plot + geom_point()
my_plot2 + geom_line()

# Alternatively...
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_line()

# Here are some geoms for some common 1D graphs.
p <- ggplot(mpg, aes(x = hwy))
p + geom_histogram()
p + geom_density()
p + geom_bar()

# Here is a common geom with 1 discrete and 1 continuous variable.
p <- ggplot(mpg, aes(x = drv, y = hwy))
p + geom_boxplot()

# Take away:
# 1. Data frame
# 2. ggplot - aesthetics
# 3. Geometry - aesthetics

#------------------------------------------------------------------------------#
# Customisation
#------------------------------------------------
# Video link: https://youtu.be/-m7YpmW9t24
#------------------------------------------------------------------------------#

# Let's start with a scatter plot
p <- ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()

# Axis labels and titles - use \n to separate over lines
p + xlab('Engine size') +
  ylab('Highway miles \n per gallon') +
  ggtitle('A scatter plot')

# Alternatively, use a label 'layer'
p +
  labs(
    title = "A scatter plot",
    x = 'Engine size',
    y = 'Highway miles \n per gallon'
  )

# Colours and shapes - specify in the aesthetic
ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) +
  geom_point()

# Alternatively you can specify in the geom (locally defined colour aesthetic)
p + geom_point(aes(colour = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + geom_point(aes(shape = drv,colour=drv))
# Note that the legend is added automatically

# Alternatively...
ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  labs(
    title = "A scatter plot",
    x = 'Engine size',
    y = 'Highway miles \n per gallon',
    color = 'Drive'
  )

# Changing axis styles
# Expand the axis - short version
p + xlim(c(0, 8)) + ylim(c(0, 50))

# Equally... (see documentation)
p + xlim(0,8) + ylim(0,50)

# Expand the axis, longer version
p + scale_x_continuous(limits = c(0, 8))

# Change the number of labels
p + scale_y_continuous(breaks = seq(10, 50, by = 5))
p + scale_y_continuous(breaks = seq(10, 50, by = 5)) + ylim(0,50)
p + ylim(0,50) + scale_y_continuous(breaks = seq(10, 50, by = 5))
p + scale_y_continuous(breaks = seq(10, 50, by = 5), limits = c(0, 50))

# Change the type of labels
p + scale_x_continuous(labels = letters[1:7])

# Changing coordinate structures - amazingly easy compared to base R
# Reverse an axis
p + scale_x_reverse()

# Even change the whole coordinate system (switch the axes)
p + coord_flip()

## Facets  ##

# Video link: https://youtu.be/j_CaUWNleuo

# Break up into multiple panels using a formula
p + facet_wrap(~drv) # 3 columns, 1 row
p + facet_grid(cyl~drv) # 3 columns, 4 rows
p + facet_grid(.~manufacturer)
# Note: facet wrap wraps things round in multiple columns/rows, facet_grid forces things 
# onto single rows/columns

# You can even do some fancy things with keeping the axes constant or not
p + facet_wrap( ~ drv, scales = 'free')
p + facet_wrap( ~ drv, scales = 'free_x') # x is free, but not y
# See ?facet for many more details

# Compare
p + facet_grid(cyl~drv)
p + facet_wrap(cyl~drv) 

# Saving ggplots - gets the file type from the extension
#ggsave(p, file = 'my_plot.pdf', width = 12, height = 8)

#------------------------------------------------------------------------------#
# Advanced customisation
#------------------------------------------------
# Video link: https://youtu.be/z3d2Wqdovgw
#------------------------------------------------------------------------------#

# Adding statistics

# Most commonly used is stat_smooth (also known as geom_smooth)
p <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()+
  xlab('Engine size') +
  ylab('Highway miles \n per gallon') +
  ggtitle('A scatter plot')

p + stat_smooth() # Default is loess for smaller data sets
# Also by default includes a 95% confidence interval
p + stat_smooth(method = 'lm') # Other options: glm, gam, ...
p + stat_smooth(method = 'gam')
# The smooth will automatically split by groups
p <- ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) + geom_point()
p + stat_smooth()

# Some geoms we've already met have equivalent stat versions, e.g. geom_bar = stat_bin

# Add a function to a density plot
p <- ggplot(mpg, aes(x = hwy)) + geom_density()
p + stat_function(fun = dnorm, args = list(mean = 25, sd = 5), colour = 'red')

## Jittering ##

# Video link: https://youtu.be/Rk_LwQ5qojw

# Avoid over plotting, compare
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()
# with
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point(position = 'jitter')
# with
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point() + geom_jitter(width = 0.2, height = 0.5)

# Add a line with geom_abline
p <- ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()
p + geom_abline(intercept = 30, slope = -1,  col = 'red')
p + geom_vline(xintercept = 4, col = 'blue')
p + geom_hline(yintercept = 30, col = 'green')+
  geom_vline(xintercept = 4, col = 'blue')

## Themes ##

# Video link: https://youtu.be/n3vyhWnOxfY

# A beautiful aspect of ggplot2 is the ability to completely change the look of the graph with just a single command. We do this via specifying different themes
p + theme_bw()
p + theme_minimal()
p + theme_dark()
p + theme_light() # Slightly lighter gridlines to theme_bw
p + theme_void() # Almost empty
# There is also a ggtheme package with way more - see https://cran.r-project.org/web/packages/ggthemes/

## Legends ##

# As soon as you start adding groups ggplot will automatically add a legend
p <- ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) + geom_point()
p
# You can use the theme command to do all kinds of edits to the plot; more on that 
# below, but here we'll focus on playing with the legend
# Move it to the top
p + theme(legend.position = 'top')
# Remove the legend
p + theme(legend.position = 'None')
# Put it somewhere deliberate
p + theme(legend.position = c(0.8, 0.8))# Note these are relative to the plot
# Make it bigger
p + theme(legend.key.size = unit(2.5, "cm"))
# Remove the legend title
p + theme(legend.title = element_blank())
# Changing the legend title for a continuous colour scheme
p + scale_colour_brewer(name = "A new title") # Note the change in colours
# Change the legend font
p + theme(legend.title = element_text(family = 'Courier'))
# Note that above we are using element_text and element_blank. 
# These are ggplot's special functions for setting text types (font, size, colour, etc). 
# element_blank removes everything

## Advanced colour scales ##

# Video link: https://youtu.be/fQQ-h7GKOHU

# scale_colour_brewer will give your data a nice colour scheme
p + scale_colour_brewer()
p + scale_colour_brewer(palette = "Greens", name="A new title")
p + scale_colour_brewer(palette = "Spectral")
# A cool list of the different palettes is available here: http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/

# ggplot will quite happily work with continuous legends but you need to use 
# scale_colour_gradientn instead
p <- ggplot(mpg, aes(x = displ, y = hwy, colour = cyl)) + geom_point()
p
p + scale_colour_gradientn(colours = heat.colors(5))

# Another palette comes from the viridis package
library(viridis)
# Gives a true representation of colour gradients when printed in black and white.
# Also works for people who are colourblind, they perceive colour in the same way that
# non-colourblind people would, i.e. light to dark (usually low to high)
# See https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
p + scale_color_viridis()
p + scale_color_viridis(option = 'A')

## Adding maths ##

# Another useful package is latex2exp which works with both base graphics and ggplot2 to add in proper equations using latex style commands
library(latex2exp)
p + xlab(TeX('$\\sin(x + 3y)$')) + ggtitle(TeX('$p(B|A) \\propto p(A|B) \\times p(B)$'))
# This is Latex code (something we'll meet in a bit more detail later in the course) where $ indicates the start/end of an equation and \\ is used to indicate a special equation structure

#------------------------------------------------------------------------------#
# Even more advanced customisation
#------------------------------------------------
# Video link: https://youtu.be/icwuyH5znJ0
#------------------------------------------------------------------------------#

# Common problems with ggplot2

# ggplot takes all the information from the data frame. So when you create the plot
ggplot(mpg, aes(x = displ, y = hwy, colour = drv)) + geom_point()
# you might think, 4 should be 4WD, f should be 'front wheel drive', and r should 
# be 'rear wheel drive'
# To change, simple re-label the factors, and create the same plot
mpg2 <- mpg
mpg2$drv <- factor(mpg2$drv, labels = c('4 wheel drive', 'Front wheel drive', 'Rear wheel drive'))
ggplot(mpg2, aes(x = displ, y = hwy, colour = drv)) + geom_point()

# What if you now want them in a different order?
mpg2$drv2 <- mpg2$drv
mpg2$drv2 <- factor(mpg2$drv2, levels = c('Front wheel drive', 'Rear wheel drive', '4 wheel drive'))
ggplot(mpg2, aes(x = displ, y = hwy, colour = drv2)) + geom_point()

# Remember how to change the legend title
ggplot(mpg2, aes(x = displ, y = hwy, colour = drv2)) + geom_point() + 
  scale_colour_discrete(name = "Drive type")

# Often you have data in multiple columns.
# Consider
str(airquality)
# Suppose you wanted to plot Ozone and Temp against Day
# it's easy to do one of them:
p <- ggplot(airquality, aes(x = Day, y = Ozone)) + geom_point()
p
# How do I add Temp? - add as an extra aesthetic
p + geom_point(aes(x = Day, y = Temp), colour = 'red')
# Can even add in multiple data frames using this technique
# This has got the legend wrong though - how can we fix it?

# The usual way is to recast the data from wide format to long format
library(reshape2)
air2 <- melt(airquality, id = c('Day', 'Month')) # Now in long format
air3 <- subset(air2, variable %in% c('Ozone','Temp'))
p <- ggplot(air3, aes(x = Day, y = value, colour = variable)) + 
  geom_point() 
p
# Spot on

# Alternatively...
air4 <- melt(airquality, id = c('Day', 'Month'), measure.vars = c('Ozone','Temp'))
ggplot(air4, aes(x=Day, y=value, colour=variable)) + geom_point()

## Creating 3D plots ##

# Video link: https://youtu.be/pQ0ak-VWNNo

# Lots of beautiful ways to plot map and 3D data in ggplot
# Start with a basic contour plot
ggplot(faithfuld, aes(x = eruptions, y = waiting, z = density)) + geom_contour()
# These data have densities, but you can create from raw
ggplot(faithful, aes(x = waiting, y  = eruptions)) + geom_density_2d()

# In the background, ggplot creates some clever attributes which you can use to create nice colours
p <- ggplot(faithfuld, aes(x = eruptions, y = waiting, z = density))
p + geom_contour(aes(colour = ..level.. ))

# geom_raster (and geom_tile) is similar to R's base graphics image or filled.contour
p + geom_raster(aes(fill = density))

# Use viridis to do it properly
p + geom_raster(aes(fill = density)) + scale_fill_viridis(option = 'A')

# Use hexbin for cool hexagonal density plots
library(hexbin)
ggplot(faithful, aes(x = waiting, y  = eruptions)) +
  geom_hex(bins = 20) +
  scale_fill_viridis(option = 'A')

#------------------------------------------------------------------------------#
# Some examples for you to work through 
#------------------------------------------------------------------------------#

# Please work through these examples, and at the end of the week I'll post videos
# explaining what the code is doing.
# Try them on your own first.  This is a good way to become familiar with 
# new functions/packages in R now that you know the basics from the code above.

# Video link: https://youtu.be/0OpRY5ENkCk

#------------------------------------------------------------------------------#
# Example 1
#------------------------------------------------
# Video link: https://youtu.be/sEUqZFsGIvo
#------------------------------------------------------------------------------#

# A time series plot with error bars

# Read in the data, remove first row, identify variable types, and missing values
glob_temp <- read.csv('https://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.csv',
                     skip = 1,
                     colClasses = 'numeric',
                     na.strings = '***')
# Add in the yearly standard deviation
glob_temp$J.D.sd <- apply(glob_temp[,2:13], 1, 'sd', na.rm = TRUE)
# Add in lower and upper CIs
glob_temp$lower <- with(glob_temp, J.D - 2 * J.D.sd)
glob_temp$upper <- with(glob_temp, J.D + 2 * J.D.sd)
# Create a new data frame with a smooth
smooth <- data.frame(with(glob_temp, ksmooth(Year, J.D, bandwidth = 15)))

# Missing one obs - full 2016 data
ggplot(glob_temp, aes(x = Year, y = J.D, colour = J.D)) +
  geom_line(size = 1) + # Add thicker line
  theme_bw() + # Nicer theme
  scale_x_continuous(breaks = seq(1880, 2020, by = 10)) + # Better x-axis every 10 years
  scale_color_viridis(option = "A") + # Viridis colour palette
  ylab(TeX('Temperature anomaly in ^oC')) + # Proper axis label with tex
  ggtitle(TeX('NASA global surface temperature data (mean $\\pm$ 2 $\\sigma$)')) +
  theme(legend.position="none") + # Remove legend
  geom_errorbar(aes(ymin = lower, ymax = upper)) + # Add in vertical error bars
  geom_line(data = smooth, aes(x = x, y = y, colour = y)) # Add in new data frame with smooth

#------------------------------------------------------------------------------#
# Example 2
#------------------------------------------------
# Video link: https://youtu.be/6d9gd40DG8g
#------------------------------------------------------------------------------#

library(maps)
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimesm <- melt(crimes, id = 1)
crimesm$variable2 <- factor(crimesm$variable, labels = c('Murder arrests (per 100,000 people)', 'Assault arrests (per 100,000)', 'Percent urban population', 'Rape arrests (per 100,000)'))

states_map <- map_data("state")

ggplot(crimesm, aes(map_id = state)) +
  geom_map(aes(fill = value), map = states_map) +
  theme_void() +
  scale_fill_viridis(option = 'B') +
  ylab("Latitidue") + xlab('Longitude') +
  expand_limits(x = states_map$long, y = states_map$lat) +
  facet_wrap( ~ variable2)

# If you want a different legend for each one see the gridExtra package

