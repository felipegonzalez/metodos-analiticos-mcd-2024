data {
  int<lower=0> N;
  vector[N] trata;
  array[N] int res;
  vector[N] peso;

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
}

transformed parameters {
  vector[N] p_logit_res;

  p_logit_res = gamma_0 + gamma_1 * trata + gamma_2 * (peso - media_peso);

}

model {
  // modelo de resultado
  // bernoulli_logit transforma p_logit_res a una probabilidad:
  res ~ bernoulli_logit(p_logit_res);
  gamma_0 ~ normal(0, 2);
  gamma_1 ~ normal(0, 0.5);
  gamma_2 ~ normal(0, 0.5);


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
      real peso_sim = peso[categorical_rng(probs)];
      res_trata[k] = bernoulli_rng(
        inv_logit(gamma_0 + gamma_1 * 1 +
              gamma_2 * (peso_sim - media_peso)));
      res_no_trata[k] = bernoulli_rng(
        inv_logit(gamma_0 + gamma_1 * 0 +
              gamma_2 * (peso_sim - media_peso)));
    }
    p_trata = mean(res_trata);
    p_no_trata = mean(res_no_trata);
  }
  dif_trata = p_trata - p_no_trata;

}