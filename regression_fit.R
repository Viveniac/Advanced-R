regression_fit = function(x_g, x, y, p = 1, method = 'BFGS')
{
  # Create design matrices
  x_rep = matrix(rep(x, p+1), ncol = (p+1), nrow = length(x))
  X = sweep(x_rep, 2, 0:p, '^')
  X_g_rep = matrix(rep(x_g, p+1), ncol = (p+1), nrow = length(x_g))
  X_g = sweep(X_g_rep, 2, 0:p, '^')
  
  # Calculate predicted values
  pred_lm  = X_g %*% solve(t(X)%*%X, t(X)%*%y)
  
  # Find best hyperparameters
  optim_res = optim(rep(0, 3), gp_criterion, x = x, y = y, method = method)
  
  # Extract the results
  sig_sq = exp(optim_res$par[1])
  rho_sq = exp(optim_res$par[2])
  tau_sq = exp(optim_res$par[3])
  
  # Create covariance matrices
  C = sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
  Sigma = sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))
  
  # Create predictions
  pred_gp = C %*% solve(Sigma, y)
  
  return(list(pred_lm = pred_lm, pred_gp = pred_gp))
}
