data {
  int<lower=0> N;
  int<lower=0> n_f;
  vector[N] f;
  vector[N]  a;
  array[N]  int<lower=0, upper=1> c;
  array[n_f] real do_f;

}

transformed data {
  real media_a;
  real media_f;

  media_a = mean(a);
  media_f = mean(f);
}

parameters {
  real<lower=0> alpha;
  real alpha_a;
  real<lower=0> alpha_f;
  real int_a;
  real beta_0;
  real<lower=0> beta_1;
  real<lower=0> beta;
  real<lower=0> a_f;
  real<lower=0> b_f;
  real<lower=0> sigma_a;
  real<lower=0> sigma_f;

}



transformed parameters {


}

model {
  f ~ gamma(a_f, b_f);
  a ~ normal(beta * f, sigma_a);
  c ~ bernoulli_logit(int_a + alpha_a * a + alpha_f * f);
  alpha_a ~ normal(0, 1);
  alpha_f ~ normal(0, 1);
  int_a ~ normal(0, 3);
  sigma_a ~ normal(0, 1);
  sigma_f ~ normal(0, 0.1);
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  beta_0 ~ normal(0, 3);
  beta_1 ~ normal(0, 1);

}
generated quantities {
  array[n_f] real mean_c;

  for(i in 1:n_f){
    array[2000] real res_sim;
    for(j in 1:2000){
      real a_sim = normal_rng(beta * (do_f[i]), sigma_a);
      real f_sim = gamma_rng(a_f, b_f);
      res_sim[j] = bernoulli_rng(inv_logit(int_a + alpha_a * a_sim + alpha_f * f_sim));
    }
    mean_c[i] = mean(res_sim);
  }

}
