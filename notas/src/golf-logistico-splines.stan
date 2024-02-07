data {
  int<lower=0> N;
  int<lower=0> p;
  array[N] int n;
  vector[N] d;
  matrix[N, p] x;
  array[N] int y;
}
parameters {
  real alpha;
  array[p] real<upper=0> beta;
}
model {
  for(i in 1:N){
    y[i] ~ binomial_logit(n[i], alpha + dot_product(x[i,], to_vector(beta)));
  }
  alpha ~ normal(4, 2);
  beta ~ normal(0, 1.5);
}
