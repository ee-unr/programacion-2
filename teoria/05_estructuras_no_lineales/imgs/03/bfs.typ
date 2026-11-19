#import "base.typ": *
#show: documento

// Cada cuadro muestra la cola después de revisar todos los vecinos del actual.
// Los nodos verdes ya están registrados, aunque algunos sigan esperando en la cola.
#let pasos = (
  (actual: none, orden: (), cola: ("Rosario",), vistos: ("Rosario",)),
  (actual: "Rosario", orden: ("Rosario",), cola: ("Salta", "San Pablo",), vistos: ("Rosario", "Salta", "San Pablo",)),
  (actual: "Salta", orden: ("Rosario", "Salta",), cola: ("San Pablo", "Córdoba", "Mendoza",), vistos: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza",)),
  (actual: "San Pablo", orden: ("Rosario", "Salta", "San Pablo",), cola: ("Córdoba", "Mendoza", "Ushuaia",), vistos: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza", "Ushuaia",)),
  (actual: "Córdoba", orden: ("Rosario", "Salta", "San Pablo", "Córdoba",), cola: ("Mendoza", "Ushuaia",), vistos: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza", "Ushuaia",)),
  (actual: "Mendoza", orden: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza",), cola: ("Ushuaia",), vistos: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza", "Ushuaia",)),
  (actual: "Ushuaia", orden: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza", "Ushuaia",), cola: (), vistos: ("Rosario", "Salta", "San Pablo", "Córdoba", "Mendoza", "Ushuaia",)),
)

#for (i, estado) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  paso(estado.vistos, estado.orden, estado.cola, "Cola (sale arriba)", actual: estado.actual)
}
