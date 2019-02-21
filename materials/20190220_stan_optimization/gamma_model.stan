data {
  // sample size; a non-negative integer
  int<lower=0> n;
  
  // vector of n observations; rainfall amounts
  vector[n] x;
}

parameters {
  // the shape parameter for the Gamma distribution; a non-negative real number
  real<lower=0> alpha;
  
  // the scale parameter for the Gamma distribution; a non-negative real number
  real<lower=0> beta;
}

model {
  // each element of the vector x is modeled as following a Gamma(alpha, beta) distribution
  x ~ gamma(alpha, beta);
}
