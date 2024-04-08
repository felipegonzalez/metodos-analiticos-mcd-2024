data {
  int N;
  array[N] int y;
  vector[N] x;
  vector[N] z;
}

parameters {
  real alpha;
  real gamma;
  real beta;
}

model {
  y ~ poisson_log(alpha + gamma * z + beta * x);
}
