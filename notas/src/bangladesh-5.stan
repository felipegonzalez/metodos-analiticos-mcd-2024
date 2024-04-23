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
  vector<lower=0>[2] sigma;
  cholesky_factor_corr[2] L_Omega;
  matrix[2, N_d] z;
}

transformed parameters {
  cov_matrix[2] Sigma;
  corr_matrix[2] Omega;
  matrix[2, N_d] beta;

  // parametrización no centrada:
  beta = rep_matrix(beta_bar, N_d) + diag_pre_multiply(sigma, L_Omega) * z;

  // Esto solo para recordar dónde están covarianzas y correlaciones:
  // no son necesarias
  Omega = L_Omega * L_Omega';
  Sigma = quad_form_diag(Omega, sigma);

}

model {
  for(n in 1:N){
      ac_uso[n] ~ bernoulli_logit( x[n] * beta[,distrito[n]]);
  }
  to_vector(z) ~ std_normal();
  // parámetros poblacionales
  beta_bar ~ normal(0, 1);
  sigma ~ normal(0, 1);
  // La siguente línea es para tener Omega ~ lkj_corr(4)
  L_Omega ~ lkj_corr_cholesky(4);
}

generated quantities {
  vector[N_d] prob_distrito_urbano;
  vector[N_d] prob_distrito_rural;

  for (i in 1:N_d) {
    prob_distrito_urbano[i] = inv_logit(beta[1,i] + beta[2,i]);
    prob_distrito_rural[i] = inv_logit(beta[1,i]);
  }

  // Simular de a priori poblacional
  vector[2] beta_sim;
  beta_sim = multi_normal_rng(beta_bar, Sigma);

}
