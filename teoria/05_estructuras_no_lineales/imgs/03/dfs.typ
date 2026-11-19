#import "base.typ": *
#show: documento

// Al entrar registramos la ciudad. Al volver se conserva el resultado.
#let orden = ("Rosario", "San Pablo", "Ushuaia", "Córdoba", "Salta", "Mendoza",)
#let pasos = (
  (cantidad: 0, camino: ()),
  (cantidad: 1, camino: ("Rosario",)),
  (cantidad: 2, camino: ("Rosario", "San Pablo",)),
  (cantidad: 3, camino: ("Rosario", "San Pablo", "Ushuaia",)),
  (cantidad: 3, camino: ("Rosario", "San Pablo",)),
  (cantidad: 4, camino: ("Rosario", "San Pablo", "Córdoba",)),
  (cantidad: 5, camino: ("Rosario", "San Pablo", "Córdoba", "Salta",)),
  (cantidad: 6, camino: ("Rosario", "San Pablo", "Córdoba", "Salta", "Mendoza",)),
  (cantidad: 6, camino: ("Rosario", "San Pablo", "Córdoba", "Salta",)),
  (cantidad: 6, camino: ("Rosario", "San Pablo", "Córdoba",)),
  (cantidad: 6, camino: ("Rosario", "San Pablo",)),
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
