data {
  int<lower=0> N;
  int<lower=0> N_d;
  array[N]  int ac_uso;
  array[N]  int distrito;
  vector[N] urbano;
}

parameters {
  real alpha_bar;
  real beta_bar;
  vector[N_d] alpha;
  vector[N_d] beta;
  real <lower=0> sigma_alpha;
  real <lower=0> sigma_beta;
}

transformed parameters {

}

model {
  // partes no determinísticas
  ac_uso ~ bernoulli_logit(alpha[distrito] + beta[distrito] .* urbano);
  alpha ~ normal(alpha_bar, sigma_alpha);
  beta ~ normal(beta_bar, sigma_beta);
  // parámetros poblacionales
  alpha_bar ~ normal(0, 1);
  beta_bar ~ normal(0, 1);
  sigma_alpha ~ normal(0, 1);
  sigma_beta ~ normal(0, 1);
}

