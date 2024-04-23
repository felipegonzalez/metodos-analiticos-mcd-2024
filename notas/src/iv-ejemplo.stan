data {
  int<lower=0> N;
  array[N] int compania;
  vector[N] colera;
  vector[N] pureza;
}

transformed data {
    array[N] vector[2] py;
    for(i in 1:N){
      py[i][1] = pureza[i];
      py[i][2] = colera[i];
    }
}

parameters {
  vector[6] alpha;
  real alpha_0;
  real beta_0;
  real beta_1;
  corr_matrix[2] Omega;
  vector<lower=0>[2] sigma;
}

transformed parameters{
  array[N] vector[2] media;
  cov_matrix[2] S;

  for(i in 1:N){
    media[i][2] = beta_0 + beta_1 * pureza[i];
    media[i][1] = alpha_0 + alpha[compania[i]];
  }

  S = quad_form_diag(Omega, sigma);
}

model {
  py ~ multi_normal(media, S);
  Omega ~ lkj_corr(2);
  sigma ~ normal(0, 10);
  alpha_0 ~ normal(0, 1);
  beta_0 ~ normal(0, 1);
  beta_1 ~ normal(0, 1);
  alpha ~ normal(0, 300);
}

generated quantities{

}
