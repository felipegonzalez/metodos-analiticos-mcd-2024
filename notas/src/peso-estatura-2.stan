data {
  int<lower=0> N;
  vector[N]  w;
  array[N] int s;
}

parameters {
  array[2] real alpha;
  real <lower=0> sigma;
}

transformed parameters {

}

model {
  // modelo para peso
  w ~ normal(alpha[s], sigma);
  // también se puede escribir como
  // for (i in 1:N) {
  //   w[i] ~ normal(alpha[s[i]], sigma);
  // }
  // iniciales
  alpha ~ normal(60, 10);
  sigma ~ normal(0, 20);
}

