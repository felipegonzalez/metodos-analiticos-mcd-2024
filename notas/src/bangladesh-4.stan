data {
  int<lower=0> N;
  int<lower=0> N_d;
  array[N]  int ac_uso;
  array[N]  int distrito;
  vector[N] urbano;
}

transformed data {
  matrix[N, 2] x;
  for (n in 1:N) {
    x[n,1] = 1;
    x[n,2] = urbano[n];
  }
}

parameters {
  vector[2] beta_bar;
  array[N_d] vector[2] beta;
  vector<lower=0>[2] sigma;
  corr_matrix[2] Omega;
}

transformed parameters {
  cov_matrix[2] Sigma;

  Sigma = quad_form_diag(Omega, sigma);
}

model {
  for(n in 1:N){
      ac_uso[n] ~ bernoulli_logit(x[n] * beta[distrito[n]]);
  }
  beta ~ multi_normal(beta_bar, Sigma);
  // parámetros poblacionales
  beta_bar ~ normal(0, 1);
  sigma ~ normal(0, 1);
  Omega ~ lkj_corr(4);
}

generated quantities {
  vector[N_d] prob_distrito_urbano;
  vector[N_d] prob_distrito_rural;

  for (i in 1:N_d) {
    prob_distrito_urbano[i] = inv_logit(beta[i][1] + beta[i][2]);
    prob_distrito_rural[i] = inv_logit(beta[i][1]);
  }
    // Simular de a priori poblacional
  vector[2] beta_sim;
  beta_sim = multi_normal_rng(beta_bar, Sigma);
}
