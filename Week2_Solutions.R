# Week 2 Solutions #

# EX 1 --------------------------------------------------------------------

# 1. For an n by m matrix X, and an m by 1 matrix y, how many flops is X%*%y? 
# Answer: 2mn
# 2. For an n by m matrix X, how many operations is t(X) %*% X? 2m^2 
# Answer: n
# 3. If n is much bigger than m, t(X)%*%X has fewer flops than X%*%t(X). True or False? 
# Answer: If n>>m then 2m^2n << 2n^2m so t(X)%*%X quicker - TRUE
# 4. How many flops is sum(X*X) in the fastest version of the trace calculation? 
# Answer: 2mn

# EX 2 --------------------------------------------------------------------

## EXERCISE

# Below is some code to produce a grid search of all the likelihood:
grid_size = 20
tau_sq_grid = seq(0.1, 5, length = grid_size)
sig_sq_grid = seq(0.1, 5, length = grid_size)
rho_sq_grid = seq(0.1, 5, length = grid_size)
all_grid = expand.grid(sig_sq_grid, tau_sq_grid, rho_sq_grid)
sig_ll = rep(NA, grid_size^3)
for(i in 1:length(sig_ll)) sig_ll[i] = GP_ll(as.numeric(all_grid[i,]))
all_out = cbind(all_grid, sig_ll)
colnames(all_out) = c('sig_sq_grid', 'tau_sq_grid', 'rho_sq_grid', '-ll')

# 1 Which row of all_out contains the smallest log likelihood?
# Answer: 684
# Got via which.min(all_out$`-ll`)

# 2 What are the values of sig_sq, tau_sq and rho_sq respectively that minimise the log-likelihood?
all_out[684,]
# Answer = 0.8736842    3.710526   0.3578947
# 0.874 3.711 0.358

# 3 The below function finds the minimum value of tau_sq across all values of sig_sq and rho_sq
# Fill in the missing values marked A and B
# tau_sq_mins = aggregate(all_out$`-ll`, by = [A](all_out$tau_sq_grid), '[B]')
tau_sq_mins = aggregate(all_out$`-ll`, by = list(all_out$tau_sq_grid), 'min')
plot(tau_sq_grid, tau_sq_mins$x, type = 'l')


# EX 3 --------------------------------------------------------------------

## EXERCISE

# In the previous exercise we created profile likelihoods by varying one parameter and optimising the other two over a grid of values. We're now in a position to write some code which, for every value on a grid for one parameter, optimises the remaining parameters.

# Write some code (using optim or nlminb) which for the following grid:
tau_sq_grid = seq(0.1, 2, length = 500)
# a) optimises the values of sig_sq and tau_sq for every value on the grid
# b) plots the tau_sq_grid values against the log likelihood
# Hint 1: you'll need to re-write the GP_ll2 (or GP_ll) function to hold the tau_sq values constant
# Hint 2: use the <<- to globally assign the current value of tau_sq_grid
# What's the value of tau_sq that provides the minimum value (to 3 d.p.)?

GP_ll2_fix = function(p) {
  sig_sq = exp(p[1])
  rho_sq = exp(p[2])
  #tau_sq = exp(p[3])
  Mu = rep(0, length(x))
  Sigma = sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + curr_val * diag(length(x))
  ll = dmvnorm(y, Mu, Sigma, log = TRUE)
  return(-ll)
}

tau_sq_prof_lik = rep(NA, 500)
for(i in 1:500) {
  print(i)
  curr_val <<- tau_sq_grid[i]
  tau_sq_prof_lik[i] = nlminb(start = c(0,0), GP_ll2_fix)$objective
}
plot(tau_sq_grid, tau_sq_prof_lik, type = 'l')

tau_sq_grid[which.min(tau_sq_prof_lik)]
# 0.188

