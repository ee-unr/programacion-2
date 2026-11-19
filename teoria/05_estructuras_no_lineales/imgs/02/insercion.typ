#import "base.typ": *
#show: documento

// Primeros tres pasos: seguir el camino. Último paso: agregar el nodo 35.
#let caminos = ((50,), (50, 30), (50, 30, 40), (50, 30, 40))

#for (paso, camino) in caminos.enumerate() {
  if paso > 0 { pagebreak() }
  let adyacencias = arbol-base
  let posiciones = posiciones-base
  let marcas = camino.map(valor => destacar(valor))
  if paso == 3 {
    adyacencias.at("40") = ("35", "45")
    adyacencias.insert("35", ())
    posiciones.insert("35", (-2.2, -4.8))
    marcas.push(encontrado(35))
  }
  dibujar(
    adyacencias: adyacencias, posiciones: posiciones,
    marcas: marcas, secuencia: "insercion",
  )
}
