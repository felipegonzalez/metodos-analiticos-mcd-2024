data {
  int<lower=0> N;
  array[N] int n;
  vector[N] d;
  array[N] int y;
}
parameters {
  real alpha;
  real<upper = 0> beta;
}
model {
  y ~ binomial_logit(n, alpha + beta * d);
  alpha ~ normal(6, 2);
  beta ~ normal(0, 0.025);
}
