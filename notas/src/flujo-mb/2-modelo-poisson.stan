data {
  int N;
  array[N] int y;
}

parameters {
  real<lower=0> lambda;
}

model {
  lambda ~ normal(0, 6);
  y ~ poisson(lambda);
}

generated quantities {
  array[N] int y_sim;

  for (n in 1:N) {
    y_sim[n] = poisson_rng(lambda);
  }
}
