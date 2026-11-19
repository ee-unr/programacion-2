#import "base.typ": *
#show: documento

// Buscar 30, copiar su sucesor 40 y quitar el nodo original de ese sucesor.
// Las identidades de los nodos se conservan aunque cambie el valor mostrado.
#for paso in range(6) {
  if paso > 0 { pagebreak() }
  let adyacencias = arbol-base
  let nombres = (:)
  let marcas = (destacar(50),)
  let enlaces = ()
  if paso >= 1 {
    marcas.push(if paso < 4 { eliminado(30) } else { encontrado(30) })
    enlaces.push(("50", "30", (stroke: trazo-recorrido)))
  }
  if paso == 2 {
    marcas.push(destacar(40))
    enlaces.push(("30", "40", (stroke: trazo-recorrido)))
  }
  if paso == 3 {
    marcas.push(encontrado(40))
    enlaces.push(("30", "40", (stroke: trazo-recorrido)))
  }
  if paso >= 4 { nombres.insert("30", [40]) }
  if paso == 4 {
    marcas.push(eliminado(40))
    enlaces.push(("30", "40", (stroke: trazo-recorrido)))
  }
  if paso == 5 {
    adyacencias.at("30") = ("20", "45")
    adyacencias.at("40") = ()
    marcas.push(("40", invisible))
    marcas.push(encontrado(45))
    enlaces.push(("30", "45", (stroke: trazo-recorrido)))
  }
  dibujar(
    adyacencias: adyacencias, nombres: nombres, marcas: marcas,
    enlaces: enlaces, secuencia: "eliminacion",
  )
}
