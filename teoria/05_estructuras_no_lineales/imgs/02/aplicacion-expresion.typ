#import "base.typ": *
#import "aplicaciones-base.typ": *
#show: documento

// La identidad del nodo no cambia cuando su etiqueta pasa a ser un resultado.
#let arbol = (
  "division": ("a", "resta"), "a": (),
  "resta": ("producto", "c"), "producto": ("dos", "b"),
  "dos": (), "b": (), "c": (),
)
#let posiciones = (
  "division": (0, 0), "a": (-1.7, -1.5), "resta": (1.7, -1.5),
  "producto": (0.2, -3), "c": (3.2, -3),
  "dos": (-1, -4.5), "b": (1.4, -4.5),
)
#let etiquetas = ("division": [/], "resta": [-], "producto": "*", "a": [a], "b": [b], "c": [c], "dos": [2])
#let pasos = (
  (actual: "division", etapa: 0, camino: ("division",)),
  (actual: "a", etapa: 0, camino: ("division", "a")),
  (actual: "a", etapa: 1, camino: ("division", "a")),
  (actual: "resta", etapa: 1, camino: ("division", "resta")),
  (actual: "producto", etapa: 1, camino: ("division", "resta", "producto")),
  (actual: "dos", etapa: 1, camino: ("division", "resta", "producto", "dos")),
  (actual: "dos", etapa: 2, camino: ("division", "resta", "producto", "dos")),
  (actual: "b", etapa: 2, camino: ("division", "resta", "producto", "b")),
  (actual: "b", etapa: 3, camino: ("division", "resta", "producto", "b")),
  (actual: "producto", etapa: 4, camino: ("division", "resta", "producto")),
  (actual: "c", etapa: 4, camino: ("division", "resta", "c")),
  (actual: "c", etapa: 5, camino: ("division", "resta", "c")),
  (actual: "resta", etapa: 6, camino: ("division", "resta")),
  (actual: "division", etapa: 7, camino: ("division",)),
)
#let expresiones = (
  "a / (2 * b - c)",
  "15 / (2 * b - c)",
  "15 / (2 * b - c)",
  "15 / (2 * 27 - c)",
  "15 / (54 - c)",
  "15 / (54 - 2.5)",
  "15 / 51.5",
  "0.2912621359223301",
)

#for (i, paso) in pasos.enumerate() {
  if i > 0 { pagebreak() }
  let datos = arbol
  let nombres = etiquetas
  let visitados = ()
  let ocultos = ()
  if paso.etapa >= 1 { nombres.at("a") = [15]; visitados.push("a") }
  if paso.etapa >= 2 { visitados.push("dos") }
  if paso.etapa >= 3 { nombres.at("b") = [27]; visitados.push("b") }
  if paso.etapa >= 4 {
    nombres.at("producto") = [54]
    datos.at("producto") = ()
    visitados.push("producto")
    ocultos += ("dos", "b")
  }
  if paso.etapa >= 5 { nombres.at("c") = [2.5]; visitados.push("c") }
  if paso.etapa >= 6 {
    nombres.at("resta") = [51.5]
    datos.at("resta") = ()
    visitados.push("resta")
    ocultos += ("producto", "c")
  }
  if paso.etapa >= 7 {
    nombres.at("division") = [0.291262…]
    datos.at("division") = ()
    visitados.push("division")
    ocultos += ("a", "resta")
  }
  // Los nodos absorbidos por un resultado siguen reservando su posición.
  for nodo in ocultos { datos.at(nodo) = () }
  let marcas = ()
  for nodo in arbol.keys() {
    if nodo in ocultos { marcas.push((nodo, invisible)) }
    else if nodo == paso.actual {
      marcas.push(destacar(nodo, fill: if nodo in visitados { rgb("#D5E8D4") } else { none }))
    } else if nodo in visitados { marcas.push(encontrado(nodo)) }
  }
  let enlaces = ()
  for j in range(paso.camino.len() - 1) {
    enlaces.push((paso.camino.at(j), paso.camino.at(j + 1), (stroke: trazo-recorrido)))
  }
  let (datos, puntos, marcas) = reservar-limites(datos, posiciones, marcas, (-1.8, 0.05), (3.4, -4.55))
  escena(none, dibujar(
    adyacencias: datos, posiciones: puntos, marcas: marcas, nombres: nombres, enlaces: enlaces,
  ), align(right, raw(expresiones.at(paso.etapa))), alinear-salida: horizon,
    ancho-arbol: 6cm, ancho-salida: 3.85cm, separacion: 20pt)
}
