library(climr)
ans<-load_clim("NH")
gp_fit<-function(obj,method=c("BFGS","Nelder-Mead","SANN","Brent"))
{
  # Create global variables to avoid annoying CRAN notes
  DJF = Dec = `J-D` = Jan = SON = Year = month = pred = quarter = temp = x = year = NULL
  #obj=ans
  #method="BFGS"
  method_arg<-match.arg(method)
  
  y<-scale(obj$clim_year %$% temp)
  y<-y[,]
  x<-obj$clim_year %$% year
  x_g<-pretty(x, n = 100)
  
  
  p1=rep(0, 3)
  p=1
  
  gp_criterion = function(p1,x,y) {
    sig_sq = exp(p1[1])
    rho_sq = exp(p1[2])
    tau_sq = exp(p1[3])
    Mu = rep(0, length(y))
    Sigma = sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))
    ll = dmvnorm(y, Mu, Sigma, log = TRUE)
    return(-ll)
  }
  
  # Create design matrices
  x_rep = matrix(rep(x, p+1), ncol = (p+1), nrow = length(x))
  X = sweep(x_rep, 2, 0:p, '^')
  X_g_rep = matrix(rep(x_g, p+1), ncol = (p+1), nrow = length(x_g))
  X_g = sweep(X_g_rep, 2, 0:p, '^')
  # Calculate predicted values
  pred_lm  = X_g %*% solve(t(X)%*%X, t(X)%*%y)
  
  # Find best hyperparameters
  if(method_arg=="BFGS")
  {
    optim_res = optim(rep(0, 3), gp_criterion, x = x, y = y, method = "BFGS")
  }
  else if(method_arg=="Nelder-Mead")
  {
    optim_res = optim(rep(0, 3), gp_criterion, x = x, y = y, method = "Nelder-Mead")
  }
  else if(method_arg=="SANN"){
    optim_res = optim(rep(0, 3), gp_criterion, x = x, y = y, method = "SANN")
  }
  else if(method_arg=="Brent"){
    optim_res = optim(rep(0, 3), gp_criterion, x = x, y = y, method = "Brent")
  }
  else
  {
    optim_res = optim(rep(0, 3), gp_criterion, x = x, y = y, method = method_arg)
  }
  
  
  # Extract the results
  sig_sq = exp(optim_res$par[1])
  rho_sq = exp(optim_res$par[2])
  tau_sq = exp(optim_res$par[3])
  
  # Create covariance matrices
  C = sig_sq * exp( - rho_sq * outer(x_g, x, '-')^2 )
  Sigma = sig_sq * exp( - rho_sq * outer(x, x, '-')^2 ) + tau_sq * diag(length(x))
  
  # Create predictions
  pred_gp = C %*% solve(Sigma, y)
  sdt<- sd(obj$clim_year$temp)
  meant<- mean(obj$clim_year$temp)
  pred_gp = (pred_gp)*sdt
  pred_gp = pred_gp + meant
  out1<-list(pred=pred_gp,data=obj$clim_year)
  class(out1) <- 'climr_gp_fit'
  return(out1)
  
}

ans2<-gp_fit(ans,method = "BFGS")

time_grid = pretty(ans2$data$year, n = 100)
tub<-data.frame(time_grid,ans2$pred)

ggplot(data=ans2$data,aes(year,temp))+geom_point(aes(colour = temp)) +
  theme_bw() +
  xlab('Year') +
  ylab('Temperature anomaly')  +
  scale_color_viridis()+
  geom_line(tub,mapping=aes(x=time_grid,y=ans2.pred,colour=ans2$data$temp))
 