data {
  int N;
  array[N] int y;
  vector[N] x;
}

parameters {
  real alpha;
  real beta;
}

model {
  y ~ poisson_log(alpha + beta * x);
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
}
