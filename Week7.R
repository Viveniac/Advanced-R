## Week 7 - Interactive visualisations and extensions to ggplot2 ###

#------------------------------------------------
# Video link: https://youtu.be/6uWoy_24QV0
#------------------------------------------------

# ggplot2 extensions. We will cover:
# ggmap - https://github.com/dkahle/ggmap
# gganimate - https://github.com/dgrtwo/gganimate 
# ggiraph - https://davidgohel.github.io/ggiraph/
#
# Some remarks about installing these packages:
#
# a) Before starting, make sure that all your installed packages are up to date. 
#    (Tools -> Check for Package Updates)
#
# b) The 3 packages above are available on CRAN, although Github versions may be 
#    available and are the most recent up to date version (at the development stage).
#
# c) You can install a package from Github with
#    library(devtools)
#    install_github('user_name/pkg_name')
#    Specific commands are given below
#
# d) Parts of the code used in this lecture may soon become deprecated, or may not work 
#    well on specific machines/operative systems.
#
# e) During installation you may be asked to install additional software, based on which 
#    machine/OS you are using.
#
# f) These additional softwares are generally perfectly safe, however note that I do not 
#    take any responsibility for any malfunctioning or unexpected behaviour.
#
# g) If you have trouble installing the packages, please use the online discussion board 
#    to explain the problem, and we will find a viable solution together
#
# h) Also, keep in mind that downgrading packages may help sometimes, because clashes 
#    between new package versions generally take some time to be fixed.
#    To install a specific version of a package you can use:
#     devtools::install_version("ggplot2", version = "3.1.0")
#    Use this as a last resort solution.

#------------------------------------------------------------------------------#
# ggmap
#------------------------------------------------
# Video link: https://youtu.be/Hip18xC858c
#------------------------------------------------------------------------------#

# install.packages('ggmap')
# devtools::install_github('dkahle/ggmap') - need the devtools version more stable
library(ggmap)

# Create a a simple map of Ireland - specify long/lat ranges
ei <- c(left = -11, bottom = 51, right = -5, top = 56)
# Get the map. zoom controls the level of detail
# Will download maps on the fly
map <- get_stamenmap(ei, zoom = 7, maptype = "toner-lite")
ggmap(map, extent = 'device') # Bit ugly

# Can change the maptype but beware not all types are supported at each zoom level
# See ?get_stamenmap
map <- get_stamenmap(ei, zoom = 6)
ggmap(map, extent = 'device') # Nicer

# Or something more artistic
map <- get_stamenmap(ei, zoom = 8, maptype = "watercolor")
ggmap(map, extent = 'device') # Excellent

# Can do all of Europe and use pipes
europe <- c(left = -12, bottom = 35, right = 30, top = 63)
library(dplyr)
get_stamenmap(europe, zoom = 5) %>% ggmap(extent = 'device')

# Adding layers to maps 

# The fun starts when you add stuff to the plot
# crime data comes with ggmap
str(crime)

# Plot the locations of violent crimes
library(readr)
violent_crimes <- crime %>%
  filter(offense != "auto theft",
         offense != "theft",
         offense != "burglary") %>%
  mutate(offense = parse_factor(offense %>% as.character,
                                levels = c("robbery", "aggravated assault", "rape", "murder"))) %>%
  filter(-95.39681 <= lon & lon <= -95.34188,
         29.73631 <= lat & lat <=  29.78400)

# Create the area and get the map
area <- c(left = -95.39615, bottom = 29.73646, right = -95.34190, top = 29.78391)
map <- get_stamenmap(area, zoom = 14, maptype = "toner-lite")

# Now plot, just replace the ggplot call with ggmap
ggmap(map) + geom_point(data = violent_crimes, aes(x = lon, y = lat, colour = offense))

# Make fancier
ggmap(map) + geom_density2d(data = violent_crimes, aes(x = lon, y = lat, colour = ..level..))
# Or try hexagonal
ggmap(map) + coord_cartesian() +
  geom_hex(data = violent_crimes, aes(x = lon, y = lat), bins = 20)

# Or even fancier - highlight robberies
library(viridis)
robberies <- violent_crimes %>% filter(offense == "robbery")
map <- get_stamenmap(area, zoom = 15, maptype = "toner-lite")
ggmap(map) + stat_density_2d(data = robberies,
                             aes(x = lon, y = lat, fill = ..level..),
                             geom = 'polygon',
                             alpha = 0.5,
                             colour = NA) +
  scale_fill_viridis(option = 'B')+
  theme_void()

#------------------------------------------------------------------------------#
# gganimate
#------------------------------------------------
# Video link: https://youtu.be/nTJbsP5YTqA
#------------------------------------------------------------------------------#

# Combines the animate package with ggplot2
# devtools::install_github('dgrtwo/gganimate')

# Use the gapminder data
# See https://www.youtube.com/watch?v=jbkSRLYSojo in case you haven't already seen it

library(gapminder) # install.packages("gapminder")
library(gganimate)
library(gifski)
library(transformr)
str(gapminder)
p <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  theme(legend.position = 'none') +
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

# If you need to install imageMagick: 
# For Mac from http://cactuslab.com/imagemagick/
# For Windows https://imagemagick.org/index.php

animation <- animate(p, renderer = gifski_renderer(loop = T)) # check out docs for more options
animation

# Save in a load of different formats
# anim_save("output.gif", animation)
# anim_save("output.mp4", animation)
# anim_save("output.html", animation)

# More ideas: https://github.com/thomasp85/gganimate/wiki

#------------------------------------------------------------------------------#
# ggiraph
#------------------------------------------------
# Video link: https://youtu.be/6MJ0vbuKdMw
#------------------------------------------------------------------------------#

# install.packages('ggiraph')
# needed libcairo2-dev
# or devtools::install_github('davidgohel/ggiraph')
library(ggiraph)

# Recall the first plot we created in Week 3
p <- ggplot(mpg, aes(x = displ, y = hwy, colour = as.factor(cyl))) +
  xlab('Engine size') +
  ylab('Highway miles per gallon') +
  stat_smooth() +
  scale_color_discrete(name="Number of\ncylinders")

# The standard plot was
p + geom_point()

# Simply change geom_point to geom_point interactive and add in a tool tip
p2 <- p + geom_point_interactive(aes(tooltip = model),
                                size = 2)
ggiraph(code = print(p2), width = 0.9)
# Click on open in browser icon to get full picture

# Make fancier - colours the points when you hover
p3 <- p + geom_point_interactive(aes(tooltip = model,
                                    data_id = model),
                                size = 2)
ggiraph(code = print(p3), width = 0.9)

# A cool example from the vignette
# Convert everything to lower case
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
# create an 'onclick' column - window.open is javascript
crimes$onclick <- sprintf("window.open(\"%s%s\")",
                         "http://en.wikipedia.org/wiki/",
                         as.character(crimes$state))

gg_crime <- ggplot(crimes,
                  aes(x = Murder,
                      y = Assault,
                      color = UrbanPop,
                      size = UrbanPop)) +
  geom_point_interactive(aes(data_id = state,
                             tooltip = state,
                             onclick = onclick)) +
  scale_color_viridis() +
  theme_bw()

ggiraph(code = print(gg_crime),
        width = 0.6)

# Full list of new geoms
# geom_bar_interactive
# geom_point_interactive
# geom_line_interactive
# geom_polygon_interactive
# geom_map_interactive
# geom_path_interactive
# geom_rect_interactive
# geom_segment_interactive
# geom_text_interactive
# geom_boxplot_interactive
# All allow tooltips, onclicks and data_id
