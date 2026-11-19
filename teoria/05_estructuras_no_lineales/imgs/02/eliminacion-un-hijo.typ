#import "base.typ": *
#show: documento

// Buscar 40 y enlazar su único hijo, 45, directamente con 30.
#for paso in range(5) {
  if paso > 0 { pagebreak() }
  let adyacencias = arbol-base
  let marcas = (destacar(50),)
  let enlaces = ()
  if paso >= 1 {
    marcas.push(destacar(30))
    enlaces.push(("50", "30", (stroke: trazo-recorrido)))
  }
  if paso >= 2 and paso < 4 {
    marcas.push(eliminado(40))
    enlaces.push(("30", "40", (stroke: trazo-recorrido)))
  }
  if paso >= 3 { marcas.push(encontrado(45)) }
  if paso == 3 {
    enlaces.push(("40", "45", (stroke: trazo-recorrido)))
  }
  if paso == 4 {
    adyacencias.at("30") = ("20", "45")
    adyacencias.at("40") = ()
    marcas.push(("40", invisible))
    enlaces.push(("30", "45", (stroke: trazo-recorrido)))
  }
  dibujar(
    adyacencias: adyacencias, marcas: marcas, enlaces: enlaces,
    secuencia: "eliminacion",
  )
}
