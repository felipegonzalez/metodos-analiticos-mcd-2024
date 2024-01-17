data {
  int<lower=0> N;
  int<lower=0> n;
  int<lower=0> kit_pos;
  int<lower=0> n_kit_pos;
  int<lower=0> kit_neg;
  int<lower=0> n_kit_neg;
}

parameters {
  real<lower=0, upper=1> theta; //seroprevalencia
  real<lower=0, upper=1> sens; //sensibilidad
  real<lower=0, upper=1> esp; //especificidad
}

transformed parameters {
  real<lower=0, upper=1> prob_pos;

  prob_pos = theta * sens + (1 - theta) * (1 - esp);

}
model {
  // modelo de número de positivos
  n ~ binomial(N, prob_pos);
  // modelos para resultados del kit
  kit_pos ~ binomial(n_kit_pos, sens);
  kit_neg ~ binomial(n_kit_neg, esp);
  // iniciales para cantidades no medidas
  theta ~ beta(1.0, 10.0);
  sens ~ beta(2.0, 1.0);
  esp ~ beta(2.0, 1.0);
}
