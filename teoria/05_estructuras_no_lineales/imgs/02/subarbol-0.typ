#import "base.typ": *
#show: documento

#let marcas = (30, 20, 40, 45).map(valor => destacar(valor))
#let enlaces = (
  ("30", "20", (stroke: trazo-recorrido)),
  ("30", "40", (stroke: trazo-recorrido)),
  ("40", "45", (stroke: trazo-recorrido)),
)
#dibujar(marcas: marcas, enlaces: enlaces)
