#import "base.typ": *
#show: documento

// Al entrar a una llamada, agregamos la ciudad a visitados y al resultado.
// Al volver, el camino pierde su último elemento y el resultado se conserva.
#let orden = ("Rosario", "Salta", "Córdoba", "Mendoza", "San Pablo", "Ushuaia",)
#let pasos = (
  (cantidad: 0, camino: ()),
  (cantidad: 1, camino: ("Rosario",)),
  (cantidad: 2, camino: ("Rosario", "Salta",)),
  (cantidad: 3, camino: ("Rosario", "Salta", "Córdoba",)),
  (cantidad: 4, camino: ("Rosario", "Salta", "Córdoba", "Mendoza",)),
  (cantidad: 5, camino: ("Rosario", "Salta", "Córdoba", "Mendoza", "San Pablo",)),
  (cantidad: 6, camino: ("Rosario", "Salta", "Córdoba", "Mendoza", "San Pablo", "Ushuaia",)),
  (cantidad: 6, camino: ("Rosario", "Salta", "Córdoba", "Mendoza", "San Pablo",)),
  (cantidad: 6, camino: ("Rosario", "Salta", "Córdoba", "Mendoza",)),
  (cantidad: 6, camino: ("Rosario", "Salta", "Córdoba",)),
  (cantidad: 6, camino: ("Rosario", "Salta",)),
  (cantidad: 6, camino: ("Rosario",)),
  (cantidad: 6, camino: ()),
)

#for (i, estado) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  let vistos = orden.slice(0, estado.cantidad)
  paso(vistos, vistos, estado.camino, "Llamadas activas",
    actual: if estado.camino.len() == 0 { none } else { estado.camino.last() },
    camino: estado.camino,
  )
}
