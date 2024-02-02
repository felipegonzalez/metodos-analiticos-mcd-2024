data {
  int<lower=0> N;
  vector[N]  h;
  vector[N]  w;
}

parameters {
  real alpha;
  real <lower=0> beta;
  real <lower=0> sigma;
}

transformed parameters {

}

model {
  // partes no determinísticas
  for(i in 1:N){
      w[i] ~ normal(alpha + beta * h[i], sigma);
  }
  alpha ~ normal(20, 20);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 20);
}

generated quantities {
  real peso_medio_150;
  
  peso_medio_150 = alpha + beta * 150; 
}
