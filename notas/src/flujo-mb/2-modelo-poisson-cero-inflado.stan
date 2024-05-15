data {
  int N;
  array[N] int y;
}

parameters {
  real<lower=0> lambda;
  real<lower=0, upper=1> p;
}

model {
  lambda ~ normal(0, 6);
  p ~ beta(1, 1);
  for(n in 1:N){
    real lpdf = poisson_lpmf(y[n] | lambda);
    if(y[n] == 0){
      target += log_mix(p, 0, lpdf);
    } else {
      target += log(1-p) + lpdf;
    }
  }
}

generated quantities {
  array[N] int y_sim;

  for (n in 1:N) {
    real zero = bernoulli_rng(p);
    if (zero == 1) {
      y_sim[n] = 0;
    } else {
      y_sim[n] = poisson_rng(lambda);
    }
  }
}
