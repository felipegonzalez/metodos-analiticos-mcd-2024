library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

graf_bif <- grViz("
digraph {
  graph [ranksep = 0.2]
  node [shape=plaintext]
    X
    Y
    Z
  edge [minlen = 3]
   Z -> X
   Z -> Y
}
" ) 
exportar_graf(graf_bif, "./diagramas/bifurcacion.png")

graf_cadena <- grViz("
digraph {
  graph [ranksep = 0.2, rankdir = 'LR']
  node [shape=plaintext]
    X
    Y
    Z
  edge [minlen = 3]
   X -> Z
   Z -> Y
}
" ) 
exportar_graf(graf_cadena, "./diagramas/cadena.png")

graf_colisionador <- grViz("
digraph {
  graph [ranksep = 0.2]
  node [shape=plaintext]
    X
    Y
    Z
  edge [minlen = 3]
   X -> Z
   Y -> Z
}
" ) 
exportar_graf(graf_colisionador, "./diagramas/colisionador.png")