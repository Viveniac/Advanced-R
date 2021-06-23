# Question 2
# Student Number: 19200231

# Clean up the current environment
rm(list=ls())

# Make results reproducible
set.seed(12345)

# We will be using data from the nycflights13 package.
library(nycflights13)
head(flights)
library(magrittr)
library(ggplot2)

#------------------------------------------------
# Q2.a)
#------------------------------------------------

flights = nycflights13::flights

# Create a new dataset 'flights_2' that contains only the flights from 'EWR' to 'LAX'.
# Recast the 'carrier' variable as a factor, with levels in the following order:
# 'UA', 'VX', 'AA'.
# Solution 
flights_2<-flights %>%subset(origin=='EWR' & dest=='LAX')
flights_2$carrier<-factor(flights_2$carrier,levels = c( "UA", "VX","AA"))
levels(flights_2$carrier)

#------------------------------------------------
# Q2.b)
#------------------------------------------------

# Create a barplot where the bars show the number of flights from 'EWR' to 'LAX' for 
# each of the carriers.  Save the plot as 'plot_1.pdf".

# Solution
pdf(file ="V:/Study/Semester 3/AdvancedR/Assignment 1/plot_1.pdf",height=4,width = 4)
ggplot(data = flights_2, aes(x = carrier,fill=carrier)) +
  geom_bar()+geom_text(stat = 'count',aes(label=stat(count),vjust=-0.2))+ggtitle("No. of flights from 'EWR' to 'LAX' for each carrier")+ xlab("Carriers")+ylab("Number of flights")
dev.off()

#------------------------------------------------
# Q2.c)
#------------------------------------------------

# Calculate the average air time for each carrier for flights from 'EWR' to 'LAX'.
# Plot the estimated densities for each of the underlying empirical distributions 
# (i.e. 1 figure with 3 continuous lines, each corresponding to a different carrier).
# Save the plot as "plot_2.pdf".

# Solution
set_names(aggregate(flights_2$air_time,list(flights_2$carrier),FUN=function(x) { my.mean = mean(x, na.rm = TRUE)}),cols=c('Month','Avg Speed'))


pdf(file ="V:/Study/Semester 3/AdvancedR/Assignment 1/plot_2.pdf",height=4,width = 4)
ggplot(flights_2, aes(x=air_time, colour=carrier)) +
  geom_density()+ ggtitle("Plot of estimated densities vs Air time")+xlab(" Air Time")+ylab(" Densities")
dev.off()


#------------------------------------------------
# Q2.d)
#------------------------------------------------

# When producing the plot for Q2.c) the following warning message appears:
# "Removed 45 rows containing non-finite values (stat_density)."

# Why did we get this warning message?  
# Answer:
# This error is due to the NA values present in the air time

# What could be done to avoid this message?
# Answer:
# Hence removing NA values during the density plot will eliminate this error
# geom_density(na.rm = TRUE)

#------------------------------------------------
# Q2.e)
#------------------------------------------------

# Using the magrittr format, define a function called 'speed' that takes a flights 
# data.frame and adds a new column with value equal to the average speed in miles 
# per hour.
# Plot bloxplots for the speed by month, for all flights from 'EWR' to 'LAX'.
# Save the plot as "plot_3.pdf".

# using magrittr a function speed is created that creates a new column avg_speed
speed<-.%>% transform(avg_speed=(distance/air_time)*60)

# function is called for the data use the original initial flight data itsself
newflight<-flights
newflight<-speed(newflight)

# New data with with avg speed and flights from EWR to LAX
data1<-newflight %>%subset(origin=='EWR' & dest=='LAX')

# plot of avg_speed versus month 
data1$month<-factor(data1$month)
pdf(file ="V:/Study/Semester 3/AdvancedR/Assignment 1/plot_3.pdf",height=4,width = 4)
ggplot(data1,aes(x=month,y=avg_speed,col=month))+geom_boxplot(na.rm = TRUE)+
  ggtitle("Average Speed vs Month")+xlab("Month")
dev.off()


#------------------------------------------------
# Q2.f)
#------------------------------------------------

# Create multiple scatterplots to visually explore how delay at departure affects 
# delay at arrival by carriers ('EWR' to 'LAX' only).
# The scatterplots share the same y-axis but have different x-axes and different points 
# colours.
# Save the plot as "plot_4.pdf".

# Solution
ua<- subset(data1, carrier=="UA") 
vx<-subset(data1, carrier=="VX")
aa<-subset(data1, carrier=="AA")

pdf(file ="V:/Study/Semester 3/AdvancedR/Assignment 1/plot_4.pdf",height=9,width = 9)
library(gridExtra)

carrierua<-ggplot(ua,aes(x=dep_delay,y=arr_delay,col))+geom_point(shape=18,color="blue",na.rm = TRUE)+
  theme(plot.margin = unit(c(0,0,0,0), "lines"),plot.background = element_blank()) +ggtitle("UA")

carriervx<-ggplot(vx,aes(x=dep_delay,y=arr_delay,col))+geom_point(shape=18,color="red",na.rm = TRUE)+
  theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.title.y = element_blank(),
        plot.margin = unit(c(0,0,0,0), "lines"),
        plot.background = element_blank()) +
  ggtitle("VX")

carrieraa<-ggplot(aa,aes(x=dep_delay,y=arr_delay,col))+geom_point(shape=18,color="orange",na.rm = TRUE)+
  theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.title.y = element_blank(),
        plot.margin = unit(c(0,0,0,0), "lines"),
        plot.background = element_blank()) +
  ggtitle("AA")

grid.arrange(carrierua,carriervx,carrieraa,ncol=3)
dev.off()

