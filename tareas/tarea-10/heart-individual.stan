data {
  int<lower=0> N;
  array[N]  int e;
  array[N]  int y;
}

parameters {
  vector<lower=0>[N] lambda;
}

transformed parameters {
  vector[N] media_hospital;
  // lambda es por cada 1000 expuestos:
  for (i in 1:N){
    media_hospital[i] = lambda[i] * e[i] / 1000;
  }
}

model {
  // partes no determinísticas
  y ~ poisson(media_hospital);
  lambda ~ exponential(1);
}

generated quantities {
  array[N] int y_sim;
  for (i in 1:N){
    y_sim[i] = poisson_rng(media_hospital[i]);
  }
}
