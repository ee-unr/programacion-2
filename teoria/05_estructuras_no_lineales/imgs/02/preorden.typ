#import "base.typ": *
#show: documento

// Al llegar a cada nodo, agregamos su valor antes de recorrer sus hijos.
#let orden = (50, 30, 20, 40, 45, 70, 60, 80)
#let pasos = (
  (actual: 50, cantidad: 0, camino: (50,)),
  (actual: 50, cantidad: 1, camino: (50,)),
  (actual: 30, cantidad: 1, camino: (50, 30)),
  (actual: 30, cantidad: 2, camino: (50, 30)),
  (actual: 20, cantidad: 2, camino: (50, 30, 20)),
  (actual: 20, cantidad: 3, camino: (50, 30, 20)),
  (actual: 40, cantidad: 3, camino: (50, 30, 40)),
  (actual: 40, cantidad: 4, camino: (50, 30, 40)),
  (actual: 45, cantidad: 4, camino: (50, 30, 40, 45)),
  (actual: 45, cantidad: 5, camino: (50, 30, 40, 45)),
  (actual: 70, cantidad: 5, camino: (50, 70)),
  (actual: 70, cantidad: 6, camino: (50, 70)),
  (actual: 60, cantidad: 6, camino: (50, 70, 60)),
  (actual: 60, cantidad: 7, camino: (50, 70, 60)),
  (actual: 80, cantidad: 7, camino: (50, 70, 80)),
  (actual: 80, cantidad: 8, camino: (50, 70, 80)),
)

#for (i, paso) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  dibujar-paso-recorrido(orden, paso)
}
