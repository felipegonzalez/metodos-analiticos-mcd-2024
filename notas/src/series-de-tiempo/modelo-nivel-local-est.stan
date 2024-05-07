data {
  int<lower=0> N;
  vector[N] y;
  int p;
}

parameters {

  real alpha_1;
  vector[p] est_1;
  real<lower=0> sigma_nivel;
  real<lower=0> sigma_irr;
  real<lower=0> sigma_est;
  vector[N] z_nivel;
  vector[N] z_innov;
  vector[N] z_est;

}

transformed parameters {
  vector[N] mu;
  vector[N] alpha;
  vector[N] est;

  alpha[1] = alpha_1;
  mu[1] = alpha[1];
  // nivel local
  for(t in 2:N){
    alpha[t] = alpha[t-1] + z_nivel[t] * sigma_nivel;
  }
  // estacionalidad
  est[1:p] = est_1;
  for(t in (p+1):N){
    est[t] = est[t - p] + z_est[t] * sigma_est;
  }
  // modelo para la media
  for(t in 1:N){
    mu[t] = alpha[t] + est[t];
  }
}

model {
  log(y) ~ normal(mu, sigma_irr);
  alpha_1 ~ normal(10, 5);
  z_nivel ~ normal(0, 1);
  z_innov ~ normal(0, 1);
  z_est ~ normal(0, 1);
  sigma_nivel ~ normal(0, 0.01);
  sigma_irr ~ normal(0, 0.5);
  sigma_est ~ normal(0, 0.01);

}

generated quantities{
  vector[N] residual;
  matrix[N, 10] y_rep;


  for(t in 1:N){
    residual[t] = y[t] - mu[t];
  }
  for(i in 1:10){
    for(t in 1:N){
      y_rep[t, i] = mu[t] + normal_rng(0, sigma_irr);
    }
  }
}
