data {
  int<lower=0> N; //número de calificaciones
  int<lower=0> n_vinos; //número de vinos
  int<lower=0> n_jueces; //número de jueces
  int<lower=0> n_origen; //número de jueces
  vector[N]  S;
  array[N]  int juez;
  array[N]  int vino;
  array[N]  int origen;
}

parameters {
  vector[n_vinos] Q;
  vector[n_origen] O;
  vector[n_jueces] H;
  vector<lower=0>[n_jueces] D;

  real <lower=0> sigma;
}

transformed parameters {
  vector[N] media_score;
  // determinístico dado parámetros
  for (i in 1:N){
    media_score[i] = (Q[vino[i]] + O[origen[i]] - H[juez[i]]) * D[juez[i]];
  }
}

model {
  // partes no determinísticas
  S ~ normal(media_score, sigma);
  Q ~ std_normal();
  O ~ std_normal();
  H ~ std_normal();
  D ~ std_normal();
  sigma ~ exponential(1);
}

generated quantities {
  real dif_origen;
  dif_origen = O[1] - O[2];
}
