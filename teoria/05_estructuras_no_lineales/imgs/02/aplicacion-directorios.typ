#import "base.typ": *
#import "aplicaciones-base.typ": *
#show: documento

#let arbol = (
  "proyecto/": ("documentos/", "imagenes/", "README.md"),
  "documentos/": ("informe.pdf",),
  "informe.pdf": (), "imagenes/": (), "README.md": (),
)
#let posiciones = (
  "proyecto/": (0, 0),
  "documentos/": (-3.1, -1.8), "imagenes/": (0, -1.8), "README.md": (3.1, -1.8),
  "informe.pdf": (-3.1, -3.6),
)
#let orden = ("proyecto/", "documentos/", "informe.pdf", "imagenes/", "README.md")
#let lineas = ("proyecto/", "  documentos/", "    informe.pdf", "  imagenes/", "  README.md")
#let pasos = (
  (actual: "proyecto/", cantidad: 0, camino: ("proyecto/",)),
  (actual: "proyecto/", cantidad: 1, camino: ("proyecto/",)),
  (actual: "documentos/", cantidad: 1, camino: ("proyecto/", "documentos/")),
  (actual: "documentos/", cantidad: 2, camino: ("proyecto/", "documentos/")),
  (actual: "informe.pdf", cantidad: 2, camino: ("proyecto/", "documentos/", "informe.pdf")),
  (actual: "informe.pdf", cantidad: 3, camino: ("proyecto/", "documentos/", "informe.pdf")),
  (actual: "imagenes/", cantidad: 3, camino: ("proyecto/", "imagenes/")),
  (actual: "imagenes/", cantidad: 4, camino: ("proyecto/", "imagenes/")),
  (actual: "README.md", cantidad: 4, camino: ("proyecto/", "README.md")),
  (actual: "README.md", cantidad: 5, camino: ("proyecto/", "README.md")),
)

#for (i, paso) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  let visitados = orden.slice(0, paso.cantidad)
  let marcas = visitados.filter(nodo => nodo != paso.actual).map(nodo => encontrado(nodo))
  marcas.push(destacar(paso.actual, fill: if paso.actual in visitados { rgb("#D5E8D4") } else { none }))
  let enlaces = ()
  for j in range(paso.camino.len() - 1) {
    enlaces.push((paso.camino.at(j), paso.camino.at(j + 1), (stroke: trazo-recorrido)))
  }
  let (datos, puntos, marcas) = reservar-limites(arbol, posiciones, marcas, (-4.4, 0.05), (4.4, -3.65))
  escena(none, dibujar(
    adyacencias: datos, posiciones: puntos, marcas: marcas, enlaces: enlaces,
  ), lineas-salida(lineas, paso.cantidad), ancho-salida: 3.3cm)
}
