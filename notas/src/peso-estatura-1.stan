data {
  int<lower=0> N;
  vector[N]  h;
  vector[N]  w;
}

parameters {
  real alpha;
  real <lower=0> beta;
  real <lower=0> sigma;
}

transformed parameters {
  vector[N] w_media;
  // determinístico dado parámetros
  w_media = alpha + beta * (h - 160);
}

model {
  // partes no determinísticas
  w ~ normal(w_media, sigma);
  alpha ~ normal(60, 10);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 20);
}
