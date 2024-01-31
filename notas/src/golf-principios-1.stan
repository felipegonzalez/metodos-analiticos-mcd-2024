data {
  int<lower=0> N;
  array[N] int n;
  vector[N] d;
  array[N] int y;
}
transformed data {
  vector[N] angulo_maximo = atan(3.25 ./ d);
}
parameters {
  real<lower=0> sigma;
  }
transformed parameters {
  vector[N] p = 2 * Phi(angulo_maximo / sigma) - 1;
}
model {
  y ~ binomial_logit(n, p);
  sigma ~ normal(0, 5 * pi() / 180);
}
