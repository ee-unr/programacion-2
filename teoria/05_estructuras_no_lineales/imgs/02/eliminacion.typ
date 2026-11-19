#import "base.typ": *
#show: documento

// Buscar 20 desde la raíz, comprobar que es hoja y quitar el enlace.
#for paso in range(4) {
  if paso > 0 { pagebreak() }
  let adyacencias = arbol-base
  let marcas = (destacar(50),)
  let enlaces = ()
  if paso >= 1 {
    marcas.push(destacar(30))
    enlaces.push(("50", "30", (stroke: trazo-recorrido)))
  }
  if paso == 2 {
    marcas.push(eliminado(20))
    enlaces.push(("30", "20", (stroke: trazo-recorrido)))
  }
  if paso == 3 {
    adyacencias.at("30") = ("40",)
    // Reservar el lugar de la hoja, sin mostrarla ni conectarla.
    marcas.push(("20", invisible))
  }
  dibujar(
    adyacencias: adyacencias, marcas: marcas, enlaces: enlaces,
    secuencia: "eliminacion",
  )
}
