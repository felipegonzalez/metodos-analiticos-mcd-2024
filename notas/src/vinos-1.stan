data {
  int<lower=0> N; //número de calificaciones
  int<lower=0> n_vinos; //número de vinos
  int<lower=0> n_jueces; //número de jueces
  vector[N]  S;
  array[N]  int juez;
  array[N]  int vino;
}

parameters {
  vector[n_vinos] Q;
  real <lower=0> sigma;
}

transformed parameters {
  vector[N] media_score;
  // determinístico dado parámetros
  for (i in 1:N){
    media_score[i] = Q[vino[i]];
  }
}

model {
  // partes no determinísticas
  S ~ normal(media_score, sigma);
  Q ~ std_normal();
  sigma ~ exponential(1);
}
