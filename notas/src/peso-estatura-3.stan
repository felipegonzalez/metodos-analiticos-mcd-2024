data {
  int<lower=0> N;
  vector[N]  w;
  vector[N]  h;
  array[N] int s;
}

transformed data {
  real h_media;
  h_media = mean(h);
}

parameters {
  array[2] real alpha;
  array[2] real<lower=0> beta;
  real <lower=0> sigma;
}

transformed parameters {
  array[N] real mu;
  for (i in 1:N) {
    mu[i] = alpha[s[i]] + beta[s[i]] * (h[i] - h_media);
  }
}

model {
  // modelo para peso
  w ~ normal(mu, sigma);
  // también se puede escribir:
  //for (i in 1:N) {
  //  w[i] ~ normal(mu[i], sigma);
  //}
  alpha ~ normal(60, 10);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 20);
}

generated quantities {

}
