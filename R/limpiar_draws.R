limpiar_draws <- function(draws, vars){
  draws |>  pivot_longer(contains(vars), names_to = "variable", values_to = "valores") |>
    separate(variable, into = c("variable", "t", "indice"), sep = "[\\[,\\]]", convert = TRUE, extra = "drop")
}
