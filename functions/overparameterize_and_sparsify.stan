//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

functions{
  real nice_curve(real x) {
    return 25*(x^3) - 62.5*(x^4);
  }
  
  real smooth_ramp(real x) {
    if(x < -0.1) {
      return 0;
    }
    if(x > 0.1) {
      return x;
    }
    if(x < 0) {
      return nice_curve(0.1 + x);
    }
    return x + nice_curve(0.1 - x);
  }
  
  real scalar_reduce_magnitude(real x, real d) {
    return smooth_ramp(x - d) - smooth_ramp(-d - x);
  }
  
  vector reduce_value(vector x, real d) {
    int N = num_elements(x);
    vector[N] out;
    for(n in 1:N) {
      out[n] = scalar_reduce_magnitude(x[n], d);
    }
    return out;
  }
}
// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  vector[N] theta;
  // real<lower=-25,upper=25> t;
}
transformed parameters{
  // vector[N] mu = reduce_value(theta, t, N);
  vector[N] mu = theta;
}
model {
  theta ~ uniform(-20, 20);
  // t ~ uniform(-20, 20);
  y ~ normal(mu, 1);
}

