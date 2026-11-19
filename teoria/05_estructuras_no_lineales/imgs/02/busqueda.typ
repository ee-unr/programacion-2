#import "base.typ": *
#show: documento

// Una página por comparación, con los nodos ya recorridos.
#let caminos = ((50,), (50, 30), (50, 30, 40))

#for (paso, camino) in caminos.enumerate() {
  if paso > 0 { pagebreak() }
  let marcas = camino.map(valor => {
    if paso == 2 and valor == 40 { encontrado(valor) } else { destacar(valor) }
  })
  dibujar(marcas: marcas, secuencia: "busqueda")
}
