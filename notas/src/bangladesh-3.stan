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
  vector[N_d] z_alpha;
  vector[N_d] z_beta;
  real <lower=0> sigma_alpha;
  real <lower=0> sigma_beta;
}

transformed parameters {
  vector[N_d] alpha;
  vector[N_d] beta;

  alpha = alpha_bar + sigma_alpha * z_alpha;
  beta = beta_bar + sigma_beta * z_beta;
}

model {
  // partes no determinísticas
  ac_uso ~ bernoulli_logit(alpha[distrito] + beta[distrito] .* urbano);
  z_alpha ~ normal(0, 1);
  z_beta ~ normal(0, 1);
  // parámetros poblacionales
  alpha_bar ~ normal(0, 1);
  beta_bar ~ normal(0, 1);
  sigma_alpha ~ normal(0, 1);
  sigma_beta ~ normal(0, 1);
}

generated quantities {
  vector[N_d] prob_distrito_urbano;
  vector[N_d] prob_distrito_rural;

  for (i in 1:N_d) {
    prob_distrito_urbano[i] = inv_logit(alpha[i] + beta[i]);
    prob_distrito_rural[i] = inv_logit(alpha[i]);
  }
  // Simular de a priori poblacional
  vector[2] beta_sim;
  beta_sim[1] = normal_rng(alpha_bar, sigma_alpha);
  beta_sim[2] = normal_rng(beta_bar, sigma_beta);
}
