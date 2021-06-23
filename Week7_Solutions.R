# Week 7 Solutions #

## EX 1 --------------------------------------------------------------

# See if you can combine the gganimate and ggmap packages to create an animated map 
# of violent crimes (from Week 7 material).
# Start with the point version of the data.
library(ggplot2)
library(ggmap)
library(ggiraph)
library(gganimate)
library(dplyr)

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

ggmap(map) + geom_point(data = violent_crimes, aes(x = lon, y = lat, col = offense)) + transition_time(as.numeric(month))

## EX 2 --------------------------------------------------------------

# Which of the offenses has the smallest number of points?
# Murder



