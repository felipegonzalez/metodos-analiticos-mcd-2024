data {
  int<lower=0> N;
  array[N] int trata;
  array[N] int res;
  array[N] real peso;
  array[N] int nse;

}

transformed data {
  real media_peso;

  // centrar
  media_peso = mean(peso);
}

parameters {
  real gamma_0;
  real gamma_1;
  real gamma_2;
  real delta_0;
  real delta_1;
  real alpha_0;
  real alpha_1;
  real<lower=0> sigma_peso;
  real<lower=0, upper=1> p_nse;
}

transformed parameters {
  vector[N] p_logit_res;
  vector[N] p_logit_trata;
  vector[N] mu_peso;
  vector[N] peso_c;
  
  for(i in 1:N){
    peso_c[i] = peso[i] - mean(peso);
  }

  
  p_logit_res = gamma_0 + gamma_1 * to_vector(trata) + gamma_2 * peso_c;
  p_logit_trata = delta_0 + delta_1 * to_vector(nse);
  mu_peso = alpha_0 + alpha_1 * to_vector(nse);
  
}

model {
  // modelo de resultado
  // bernoulli_logit transforma p_logit_res a una probabilidad:
  nse ~ bernoulli(p_nse);
  peso ~ normal(mu_peso, sigma_peso);
  trata ~ bernoulli_logit(p_logit_trata);
  res ~ bernoulli_logit(p_logit_res);
  gamma_0 ~ normal(0, 2);
  gamma_1 ~ normal(0, 0.5);
  delta_0 ~ normal(0, 2);
  delta_1 ~ normal(0, 0.5);
  gamma_2 ~ normal(0, 0.5);
  alpha_0 ~ normal(0, 20);
  alpha_1 ~ normal(0, 10);
  sigma_peso ~ normal(0, 20);


}
generated quantities {
  real dif_trata;
  real p_trata;
  real p_no_trata;
  vector[N] probs;

  // Ahora hacemos simulaciones para comparar una
  // población de tratados vs una de no tratados
  // marginalizamos sobre peso tomando en cada simulación
  // un peso de la población.
  for(i in 1:N){
    probs[i] = 1.0 / N;
  }
  
  {
    array[2000] int res_trata;
    array[2000] int res_no_trata;
    for(k in 1:2000){
      // simulamos según el modelo gráfico
      real nse_sim = bernoulli_rng(p_nse);
      real peso_c_sim = normal_rng(alpha_0 + alpha_1 * nse_sim, sigma_peso);
      // pero no incluimos la ecuación de tratamiento, pues lo queremos
      // manipular
      res_trata[k] = bernoulli_rng(
        inv_logit(gamma_0 + gamma_1 * 1 +
              gamma_2 * peso_c_sim));
      res_no_trata[k] = bernoulli_rng(
        inv_logit(gamma_0 + gamma_1 * 0 +
              gamma_2 * peso_c_sim));
    }
    p_trata = mean(res_trata);
    p_no_trata = mean(res_no_trata);
  }
  dif_trata = p_trata - p_no_trata;
}
