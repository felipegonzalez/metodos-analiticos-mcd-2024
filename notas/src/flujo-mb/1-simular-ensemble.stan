data {
  int N;
}

generated quantities {
  real<lower=0> lambda;
  array[N] int y;

  // Simular configuracion del modelo a partir de inicial
  lambda = abs(normal_rng(0, 6));
  // Simular datos del modelo observacional
  for (n in 1:N){
      y[n] = poisson_rng(lambda);
  }
}
