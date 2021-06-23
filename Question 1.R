# Question 1
# Student Number: 19200231

# Clean up the current environment
rm(list=ls())

# Make results reproducible
set.seed(12345)

# For this question, load in the trees data set from the datasets package.
library(datasets)
head(trees)

# Implement your regression_fit function here.
with(trees, plot(Girth, Volume))

# Standardise the data first
x <- scale(trees$Girth)[,1]
y <- scale(trees$Height)[,1]

# Create a grid of new x-values
x_g <- pretty(x, n = 100)

library(mvtnorm)

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

# Function named regression fit to return to vectors.
regression_fit<- function(x_g, x,y,p=1,method='BGFS')
{ 
  # Optim function
  answer_GP= optim(rep(0, 3), gp_criterion, method, x=x, y=y)
  
  # To compare fit
  sig_sq <- exp(answer_GP$par[1])
  rho_sq <- exp(answer_GP$par[2])
  tau_sq <- exp(answer_GP$par[3])
  
  # Here C is the covariance between the grid points and the data points, 
  # Sigma is the variance matrix of the data, and y is the data vector
  # Create covariance matrices
  C <- sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
  Sigma <- sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))
  
  #Creating predictions
  pred <- C %*% solve(Sigma, y)
  
  #Fitting a Polynomial Regression model using lm function
  fitPoly = lm(y~x+I(x^2)+I(x^3)+I(x^4), data = trees)
  
  # List contains two vectors that contain the predicted values using the polynomial regression 
  # and Gaussian process regression, respectively
  twoVector=list()
  
  # Pred contains values of Gaussian Process Regression predicted height values
  twoVector$first=pred
  # predict(fitPoly) predict function is used to get predicted height values from Polynomial Regression
  twoVector$second=predict(fitPoly)
  
  # Returnning list of two vectors
  return (twoVector)
}

# Create your plot here.

# Calling the function regression_fit passing x_g, x,y and default p and method set
resVector=regression_fit(x_g, x,y)
resVector


# Plotting the data along with the fitted models values
pdf(file ="V:/Study/Semester 3/AdvancedR/Assignment 1/regression.pdf",height=4,width = 4)
plot(x,y,xlab="Girth",ylab="Height", main="Plotting trees predicted height values",
     xlim=c(-2,2.5), ylim=c(-2,2),cex = 0.75)
lines(x,resVector$second, col="red",lwd=2)
lines(x_g, resVector$first, col = 'blue',lwd=2)
legend("bottomright",
       c("Gausian Process Regression","Polynomial Regression"),
       fill=c("blue","red"),cex = 0.5
)
dev.off()
 