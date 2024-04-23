data {
  int N;
  int n_base;
  vector[N] y;
  vector[N] x;
  vector[N] trata;
  matrix[n_base, N] B;
}

parameters {
  row_vector[n_base] a_raw;
  real a0;
  real delta;
  real<lower=0> sigma;
  real<lower=0> tau;
}

transformed parameters {
  row_vector[n_base] a;
  vector[N] y_media;
  a = a_raw * tau;
  y_media = a0 * x + to_vector(a * B) + trata * delta;
}

model {
  a_raw ~ normal(0, 1);
  tau ~ normal(0, 1);
  sigma ~ normal(0, 10);
  delta ~ normal(0, 10);
  y ~ normal(y_media, sigma);
}

generated quantities {

}

