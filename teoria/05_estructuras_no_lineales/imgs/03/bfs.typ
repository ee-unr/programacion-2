#import "base.typ": *
#show: documento

// Cada cuadro muestra la cola después de revisar todos los vecinos del actual.
// Los nodos verdes ya están registrados, aunque sigan esperando en la cola.
#let pasos = (
  (actual: none, orden: (), cola: ("Rosario",), vistos: ("Rosario",)),
  (actual: "Rosario", orden: ("Rosario",), cola: ("San Pablo", "Salta",), vistos: ("Rosario", "San Pablo", "Salta",)),
  (actual: "San Pablo", orden: ("Rosario", "San Pablo",), cola: ("Salta", "Ushuaia", "Córdoba", "Mendoza",), vistos: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba", "Mendoza",)),
  (actual: "Salta", orden: ("Rosario", "San Pablo", "Salta",), cola: ("Ushuaia", "Córdoba", "Mendoza",), vistos: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba", "Mendoza",)),
  (actual: "Ushuaia", orden: ("Rosario", "San Pablo", "Salta", "Ushuaia",), cola: ("Córdoba", "Mendoza",), vistos: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba", "Mendoza",)),
  (actual: "Córdoba", orden: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba",), cola: ("Mendoza",), vistos: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba", "Mendoza",)),
  (actual: "Mendoza", orden: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba", "Mendoza",), cola: (), vistos: ("Rosario", "San Pablo", "Salta", "Ushuaia", "Córdoba", "Mendoza",)),
)

#for (i, estado) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  paso(estado.vistos, estado.orden, estado.cola, "Cola (sale arriba)", actual: estado.actual)
}
