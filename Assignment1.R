### STAT40830 Assignment 1 ###

# Clean up the current environment
rm(list=ls())

# Make results reproducible
set.seed(12345)

#------------------------------------------------

# Question 1

# For this question, load in the trees data set from the datasets package.
library(datasets)
head(trees)

# This question is based on the materials of Weeks 1 & 2.  You should prepare your
# solution using only functions that have been introduced in these weeks.
# See the Assignment 1 document on Brightspace for details of the Question.

library(mvtnorm)
with(trees, plot(Girth, Height))

# Standardise the data first
x <- scale(trees$Girth)[,1]
y <- scale(trees$Height)[,1]

# Create a grid of new x-values
x_g <- pretty(x, n = 100)


# Define criterion to be minimised in Gaussian process regression
gp_criterion = function(p,x,y) {
  sig_sq = exp(p[1])
  rho_sq = exp(p[2])
  tau_sq = exp(p[3])
  Mu = rep(0, length(x))
  Sigma = sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))
  ll = dmvnorm(y, Mu, Sigma, log = TRUE)
  return(-ll)
}

answer_GP=optim(rep(0, 3), gp_criterion, method = 'BFGS', x=x, y=y)

# Let's compare fit!
sig_sq <- exp(answer_GP$par[1])
rho_sq <- exp(answer_GP$par[2])
tau_sq <- exp(answer_GP$par[3])

# Create covariance matrices
C <- sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
Sigma <- sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))

# Now create predictions
pred <- C %*% solve(Sigma, y)
plot(x, y)
lines(x_g, pred, col = 'blue')


# Polynomial Regression
model1 = lm(y~x+I(x^2)++I(x^3)+I(x^4), data = trees)

attributes(model1)
summary(model1)

# Some of the useful things in it
model1$coefficients
model1$residuals
model1$fitted.values


# model2=lm(trees$Volume ~ poly(trees$Girth,degree =2, raw=T))
# summary(model2)

plot(x,y)
lines(x,predict(model1), col="red",lwd=3)



 # Try sig_sq_grid
grid_size <- 50
sig_sq_grid <- seq(0.1, 20, length = grid_size)
sig_ll <- rep(NA, grid_size)
for(i in 1:grid_size){
  sig_ll[i] <- gp_criterion(c(sig_sq_grid[i], 0, 0),x,y)
} 
plot(sig_sq_grid, sig_ll, type = 'l') # Perhaps 5 isn't the best value?
# You could also try for other parameters

# What about two at the same time
rho_sq_grid <- seq(0.1, 20, length = grid_size)
both_grid <- expand.grid(sig_sq_grid, rho_sq_grid)
sig_ll <- rep(NA, grid_size^2)
for(i in 1:length(sig_ll)){
  sig_ll[i] = gp_criterion(c(both_grid[i,1], both_grid[i,2]),x,y)
} 
plot(both_grid[,1], both_grid[,2], pch = 19, xlab = 'sigma_sq', ylab = 'rho_sq',
     col = rgb(1, 0, 0, alpha = exp(-sig_ll)/max(exp(-sig_ll))))

GP_ll2 <- function(p) {
  sig_sq <- exp(p[1])
  rho_sq <- exp(p[2])
  tau_sq <- exp(p[3])
  Mu <- rep(0, length(x))
  Sigma <- sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))
  ll <- dmvnorm(y, Mu, Sigma, log = TRUE)
  return(-ll)
}
GP_ll2(log(c(5, 10, 2)))

grad_GP <- function(p, h = 1e-3) {
  grad <- rep(NA, 3)
  curr <- GP_ll2(p)
  grad[1] <- (1/h) * (GP_ll2(p+c(h,0,0)) - curr)
  grad[2] <- (1/h) * (GP_ll2(p+c(0,h,0)) - curr)
  grad[3] <- (1/h) * (GP_ll2(p+c(0,0,h)) - curr)
  return(grad)
}

grad_GP(log(c(5, 10, 2)))

# Now run the optimisation
SD_optim <- function(start, alpha = 1e-4, tol = 1e-4) {
  theta <- start
  err <- tol + 1
  while(err>tol) {
    theta_new <- theta - alpha * grad_GP(theta)
    err <- abs(GP_ll2(theta_new) - GP_ll2(theta))
    theta <- theta_new
    #print(theta)
    print(GP_ll2(theta))
  }
  return(theta)
}

answer <- SD_optim(start = rep(0, 3))
GP_ll2(answer)
exp(answer)


sig_sq <- exp(answer)[1]
rho_sq <- exp(answer)[2]
tau_sq <- exp(answer)[3]

# Create covariance matrices
C <- sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
Sigma <- sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))







# Did this work?
sig_sq <- exp(answer[1])
rho_sq <- exp(answer[2])
tau_sq <- exp(answer[3])

# Create covariance matrices
C <- sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
Sigma <- sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))

# Now create predictions
pred <- C %*% solve(Sigma, y)
plot(x, y)
lines(x_g, pred, col = 'blue') 

# 1) BFGS - a fancier Newton-type method
#         - can deal with constraints on your parameters
#         - used a lot in practice
#         - uses the second derivative as well, very efficient
answer_BFGS <- optim(rep(0, 3), GP_ll2, method = 'BFGS')
GP_ll2(answer_BFGS$par)


# Let's compare fit!
sig_sq <- exp(answer_BFGS$par[1])
rho_sq <- exp(answer_BFGS$par[2])
tau_sq <- exp(answer_BFGS$par[3])

# Create covariance matrices
C <- sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
Sigma <- sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))

# Now create predictions
pred <- C %*% solve(Sigma, y)
lines(x_g, pred, col = 'red') 



# Implement your regression_fit function here.


# Create your plot here.


#------------------------------------------------

# Question 2

# We will be using data from the nycflights13 package.
library(nycflights13)
head(flights)

library(magrittr)
library(ggplot2)

#------------------------------------------------
# Q2.a)
#------------------------------------------------

# Create a new dataset 'flights_2' that contains only the flights from 'EWR' to 'LAX'.
# Recast the 'carrier' variable as a factor, with levels in the following order:
# 'UA', 'VX', 'AA'.

# Solution 


#------------------------------------------------
# Q2.b)
#------------------------------------------------

# Create a barplot where the bars show the number of flights from 'EWR' to 'LAX' for 
# each of the carriers.  Save the plot as 'plot_1.pdf".

# Solution


#------------------------------------------------
# Q2.c)
#------------------------------------------------

# Calculate the average air time for each carrier for flights from 'EWR' to 'LAX'.
# Plot the estimated densities for each of the underlying empirical distributions 
# (i.e. 1 figure with 3 continuous lines, each corresponding to a different carrier).
# Save the plot as "plot_2.pdf".

# Solution


#------------------------------------------------
# Q2.d)
#------------------------------------------------

# When producing the plot for Q2.c) the following warning message appears:
# "Removed 45 rows containing non-finite values (stat_density)."

# Why did we get this warning message?  
# Answer:
# 

# What could be done to avoid this message?
# Answer:
# 

#------------------------------------------------
# Q2.e)
#------------------------------------------------

# Using the magrittr format, define a function called 'speed' that takes a flights 
# data.frame and adds a new column with value equal to the average speed in miles 
# per hour.
# Plot bloxplots for the speed by month, for all flights from 'EWR' to 'LAX'.
# Save the plot as "plot_3.pdf".

# Solution


#------------------------------------------------
# Q2.f)
#------------------------------------------------

# Create multiple scatterplots to visually explore how delay at departure affects 
# delay at arrival by carriers ('EWR' to 'LAX' only).
# The scatterplots share the same y-axis but have different x-axes and different points 
# colours.
# Save the plot as "plot_4.pdf".

# Solution


# End -------------------------------------------