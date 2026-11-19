#import "base.typ": *
#show: documento

// Los valores quedan pendientes hasta terminar ambos subárboles.
#let orden = (20, 45, 40, 30, 60, 80, 70, 50)
#let pasos = (
  (actual: 50, cantidad: 0, camino: (50,)),
  (actual: 30, cantidad: 0, camino: (50, 30)),
  (actual: 20, cantidad: 0, camino: (50, 30, 20)),
  (actual: 20, cantidad: 1, camino: (50, 30, 20)),
  (actual: 30, cantidad: 1, camino: (50, 30)),
  (actual: 40, cantidad: 1, camino: (50, 30, 40)),
  (actual: 45, cantidad: 1, camino: (50, 30, 40, 45)),
  (actual: 45, cantidad: 2, camino: (50, 30, 40, 45)),
  (actual: 40, cantidad: 3, camino: (50, 30, 40)),
  (actual: 30, cantidad: 4, camino: (50, 30)),
  (actual: 50, cantidad: 4, camino: (50,)),
  (actual: 70, cantidad: 4, camino: (50, 70)),
  (actual: 60, cantidad: 4, camino: (50, 70, 60)),
  (actual: 60, cantidad: 5, camino: (50, 70, 60)),
  (actual: 70, cantidad: 5, camino: (50, 70)),
  (actual: 80, cantidad: 5, camino: (50, 70, 80)),
  (actual: 80, cantidad: 6, camino: (50, 70, 80)),
  (actual: 70, cantidad: 7, camino: (50, 70)),
  (actual: 50, cantidad: 8, camino: (50,)),
)

#for (i, paso) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  dibujar-paso-recorrido(orden, paso)
}
