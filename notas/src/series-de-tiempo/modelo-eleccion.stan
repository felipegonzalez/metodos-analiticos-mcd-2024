data {
  int<lower=0> N; //num encuestas
  int<lower=0> T; //num dias
  int<lower=0> K; //num candidatos
  int<lower=0> S; //num casas
  array[N, K] int n_obs;   //preferencias
  array[N] int num_casa_enc;
  array[N] int dia_enc;
}

parameters {

  cholesky_factor_corr[K] L_Omega;
  vector<lower=0>[K] sigma;
  array[T] vector[K] eta;
  vector[K] alpha_1;
  array[S] vector[K] d_casa;
  vector[K] b;

}

transformed parameters {
  array[N] simplex[K] mu;
  array[T] vector[K] alpha;
  array[S] vector[K] d_casa_c;

  alpha[1] = alpha_1;
  // nivel local
  for(t in 2:T){
    alpha[t] = alpha[t-1] +  diag_pre_multiply(sigma, L_Omega) *  eta[t];
  }
  // modelo para la media
  for(s in 1:S){
    d_casa_c[s] = d_casa[s] - mean(d_casa[s]);
  }
  for(i in 1:N){
    mu[i] = softmax(alpha[dia_enc[i]] + d_casa_c[num_casa_enc[i]] + b);
  }
}

model {
  for(i in 1:N){
    n_obs[i] ~ multinomial(mu[i]);
  }

  alpha_1 ~ normal(0, 2);
  for(t in 1:T) {
    eta[t] ~ std_normal();
  }
  b ~ normal(0, 0.07);
  for(s in 1:S){
    d_casa[s] ~ normal(0, 0.25);
  }
  L_Omega ~ lkj_corr_cholesky(2);
  sigma ~ normal(0, 0.05);
}

generated quantities{
  corr_matrix[K] Omega;

  Omega = multiply_lower_tri_self_transpose(L_Omega);

}

