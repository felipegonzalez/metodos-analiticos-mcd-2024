data {
  int<lower=0> N;
  vector[N]  d_est;
  vector[N]  m_est;
  vector[N]  edad_est;
}

parameters {
  real alpha;
  real  beta_M;
  real  beta_E;
  real <lower=0> sigma;
}

transformed parameters {
  vector[N] w_media;
  // determinístico dado parámetros
  w_media = alpha + beta_M * m_est + beta_E * edad_est;
}

model {
  // partes no determinísticas
  d_est ~ normal(w_media, sigma);
  alpha ~ normal(0, 1);
  beta_M ~ normal(0, 0.5);
  beta_E ~ normal(0, 0.5);
  sigma ~ normal(0, 1);
}

generated quantities {
  real dif;
  {
    //simulamos 50 estados
    int M = 50;
    array[M] real dif_sim;
    for(i in 1:M){
      real edad_sim_est = normal_rng(0, 1);
      // fijamos el valor de M en 0 y 1 para el modelo con do(M)
      real M_sim_0 = normal_rng(alpha * beta_M * 0 + beta_E * edad_sim_est, sigma);
      real M_sim_1 = normal_rng(alpha * beta_M * 1 + beta_E * edad_sim_est, sigma);
      dif_sim[i] = M_sim_1 - M_sim_0;
    }
    dif = mean(dif_sim);
  }

}
