data {
  int<lower=0> N;
  vector[N]  d;
  vector[N]  m;
  vector[N]  edad;
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
  w_media = alpha + beta_M * m + beta_E * edad;
}

model {
  // partes no determinísticas
  d ~ normal(w_media, sigma);
  alpha ~ normal(0, 1);
  beta_M ~ normal(0, 0.5);
  beta_E ~ normal(0, 0.5);
  sigma ~ normal(0, 1);
}

generated quantities {
  real dif;
  {
    int M = 1000;
    array[M] real dif_sim;
    for(i in 1:M){
      real edad_sim = normal_rng(0, 1);
      real M_sim_0 = normal_rng(alpha * beta_M * 0 + beta_E * edad_sim, sigma);
      real M_sim_1 = normal_rng(alpha * beta_M * 1 + beta_E * edad_sim, sigma);
      dif_sim[i] = M_sim_1 - M_sim_0;
    }
    dif = mean(dif_sim);
  }

}
