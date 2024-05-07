data {
  int<lower=0> N;
  int<lower=0> N_obs;
  vector[N] y;
  real s_obs;
  int<lower=0> n_h; //numero de periodos de pronóstico
  array[N_obs] int ii_obs;
  real q_nivel;
  real q_tend;

}


parameters {

  real alpha_1;
  real nu_1;
  real<lower=0, upper= s_obs> sigma_nivel;
  real<lower=0, upper=s_obs> sigma_tend;
  real<lower=0, upper=s_obs> sigma_obs;
  vector[N + n_h] z_nivel;
  vector[N + n_h] z_tend;

}

transformed parameters {
  vector[N + n_h] mu;
  vector[N + n_h] alpha;
  vector[N + n_h] nu;


  alpha[1] = alpha_1;
  nu[1] = nu_1;
  mu[1] = alpha[1];
  // evolucion estado
  for(t in 2:(N + n_h)){
    alpha[t] = alpha[t-1] + nu[t-1] + z_nivel[t] * sigma_nivel;
    nu[t] = nu[t-1] + z_tend[t] * sigma_tend;
    mu[t] = alpha[t];
  }
}

model {
  // modelo de observaciones
  y[ii_obs] ~ normal(mu[ii_obs], sigma_obs);
  // iniciales
  alpha_1 ~ normal(y[1], s_obs);
  nu_1 ~ normal(0, s_obs);
  z_nivel ~ normal(0, 1);
  z_tend ~ normal(0, 1);
  sigma_nivel ~ normal(0, q_nivel * s_obs);
  sigma_tend ~ normal(0, q_tend * s_obs);
  sigma_obs ~ normal(0, s_obs);

}

generated quantities{
  vector[N] y_rep;
  vector[n_h] y_f;


  for(t in 1:N){
    y_rep[t] = normal_rng(mu[t], sigma_obs);
  }
  for(h in 1:n_h){
    y_f[h] = normal_rng(mu[N + h], sigma_obs);
  }
}
