functions{
  real nice_curve(real x) {
    return 25*(x^3) - 62.5*(x^4);
  }
  
  real smoothed_ramp(real x) {
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
  
  real scalar_reduce_magnitude(real x, real delta) {
    return smoothed_ramp(x - delta) - smoothed_ramp(-x - delta);
  }
  
  vector reduce_value(vector x, real delta) {
    int N = num_elements(x);
    vector[N] out;
    for(n in 1:N) {
      out[n] = scalar_reduce_magnitude(x[n], delta);
    }
    return out;
  }
}
data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  vector[N] theta;
  real<lower=0,upper=25> delta;
}
transformed parameters{
  vector[N] mu = reduce_value(theta, delta);
}
model {
  theta ~ uniform(-20, 20);
  delta ~ uniform(-20, 20);
  y ~ normal(mu, 1);
}

