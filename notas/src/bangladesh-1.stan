data {
  int<lower=0> N;
  int<lower=0> N_d;
  array[N]  int ac_uso;
  array[N]  int distrito;
}

parameters {
  real alpha_bar;
  vector[N_d] alpha;
  real <lower=0> sigma;
}

transformed parameters {

}

model {
  // partes no determinísticas
  ac_uso ~ bernoulli_logit(alpha[distrito]);
  alpha ~ normal(alpha_bar, sigma);
  // parámetros poblacionales
  alpha_bar ~ normal(0, 1);
  sigma ~ normal(0, 1);
}

generated quantities {
  vector[N_d] prob_distrito;
  for (i in 1:N_d) {
    prob_distrito[i] = inv_logit(alpha[i]);
  }

}
