#import "base.typ": *
#show: documento

#let etiquetas = (
    "50": (content: [raíz (interno)], position: "top"),
    "30": (content: [interno], position: "top"),
    "70": (content: [interno], position: "top"),
    "40": (content: [interno], position: "top", offset: (0.5, 0)),
    "20": (content: [hoja], position: "bottom"),
    "60": (content: [hoja], position: "bottom"),
    "80": (content: [hoja], position: "bottom"),
    "45": (content: [hoja], position: "bottom"),
  )

// Columna lateral de profundidades, sin recuadros ni conexiones.
#let columna = -5.2
#let etiqueta-lateral = (fill: rgb("#DFEAF200"), stroke: 0pt + rgb("#33333300"))
#let adyacencias = arbol-base
#let posiciones = posiciones-base
#let nombres = (:)
#let marcas = ()
#for nivel in range(4) {
  let id = "profundidad-" + str(nivel)
  adyacencias.insert(id, ())
  posiciones.insert(id, (columna, -1.6 * nivel))
  nombres.insert(id, [#nivel])
  marcas.push((id, etiqueta-lateral))
}
#adyacencias.insert("titulo-profundidad", ())
#posiciones.insert("titulo-profundidad", (columna, 1.0))
#nombres.insert("titulo-profundidad", text(size: 8pt)[Profundidad])
#marcas.push(("titulo-profundidad", etiqueta-lateral))

#dibujar(
  adyacencias: adyacencias, posiciones: posiciones,
  marcas: marcas, etiquetas: etiquetas, nombres: nombres,
)
