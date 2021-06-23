# Week 4 Solutions #

# EX 1 --------------------------------------------------------------

runif(1000) %>% qnorm %>% hist(breaks = 30)

## EX 2 --------------------------------------------------------------

iris %>% subset(Sepal.Width > 3) %>%
  within(., Petal.area <- pi * Petal.Length / 2 * Petal.Width / 2) %>%
  aggregate(Petal.area ~ Species, data = ., FUN = 'median')

## EX 3 --------------------------------------------------------------

# All cars with disp < 200 or wt > 3.3
mtcars %>% subset(or(disp %>% is_less_than(200), wt %>% is_greater_than(3.3)))
# All cars with gear greater than or equal to 4 and cylinders equal to 6
mtcars %>% subset(and(gear %>% is_weakly_greater_than(4), cyl %>% equals(6)))

## EX 4 --------------------------------------------------------------

nll = . %>% dnorm %>% log %>% sum %>% multiply_by(-1)
nll(rnorm(10))
