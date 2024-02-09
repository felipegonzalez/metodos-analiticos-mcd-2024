data {
  int n;
  vector[n] a;
  vector[n] f;
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

model {
  for(i in 1:n){
    f[i] ~ normal(alpha + beta * a[i], sigma);
  }
  alpha ~ normal(0, 0.2);
  beta ~ normal(0, 0.5);
  sigma ~ normal(0, 1);
}
