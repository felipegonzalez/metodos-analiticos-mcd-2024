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
  real<lower=0> sigma_ang;
  }
transformed parameters {
  real sigma = sigma_ang * pi() / 180;
  vector[N] p = 2 * Phi(angulo_maximo / sigma) - 1;
}
model {
  y ~ binomial_logit(n, p);
  sigma_ang ~ gamma(4, 2);
}
