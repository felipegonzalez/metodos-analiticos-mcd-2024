data {
  int n;
  vector[n] w;
  vector[n] g;
  vector[n] f;
}

parameters {
  real alpha;
  real beta_g;
  real beta_f;
  real<lower=0> sigma;
}

model {
  for(i in 1:n){
    w[i] ~ normal(alpha + beta_g * g[i] + beta_f * f[i],
                  sigma);
  }
  alpha ~ normal(0, 0.2);
  beta_g ~ normal(0, 0.5);
  beta_f ~ normal(0, 0.5);
  sigma ~ normal(0, 1);
}
