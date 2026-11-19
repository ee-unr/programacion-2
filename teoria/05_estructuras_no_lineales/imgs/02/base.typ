#import "@preview/typed-dsa:0.7.0": graph
#import "../01/estilo.typ": estilo

// El nodo actual conserva el color de su estado y tiene un borde más intenso.
#let color-recorrido = rgb("#0066CC")
#let color-visitado-actual = rgb("#3D7A36")
#let trazo-recorrido = 1.4pt + black
#let estilo-arbol = (
  ..estilo,
  edge-stroke: 1pt + black,
  edge-arrow-fill: black,
)

// Árbol original y posiciones compartidas por todas las figuras.
#let posiciones-base = (
  "50": (0, 0),
  "30": (-2.7, -1.6), "70": (2.7, -1.6),
  "20": (-4.1, -3.2), "40": (-1.3, -3.2),
  "60": (1.3, -3.2), "80": (4.1, -3.2),
  "45": (-0.4, -4.8),
)
#let arbol-base = (
  "50": ("30", "70"), "30": ("20", "40"), "70": ("60", "80"),
  "20": (), "40": ("45",), "60": (), "80": (), "45": (),
)

#let destacar(valor, fill: none, stroke: none) = (
  str(valor),
  (
    fill: if fill == none { rgb("#DFEAF2") } else { fill },
    stroke: if stroke == none {
      1.6pt + if fill == rgb("#D5E8D4") { color-visitado-actual } else { color-recorrido }
    } else { stroke },
  ),
)
#let encontrado(valor) = destacar(
  valor, fill: rgb("#D5E8D4"), stroke: 1pt + rgb("#82B366"),
)
#let eliminado(valor) = destacar(
  valor, fill: rgb("#F8CECC"), stroke: 1pt + rgb("#B85450"),
)
#let invisible = (
  fill: rgb("#DFEAF200"), stroke: 0pt + rgb("#33333300"),
  text: (color: rgb("#33333300")),
)

// Configuración de página para los documentos individuales.
#let documento(body) = {
  set page(width: auto, height: auto, margin: 6pt)
  set text(font: "Cascadia Code", size: 10pt)
  body
}

// Cada documento decide qué modifica y qué resalta.
// Los cuadros de una secuencia comparten un tamaño ajustado a su contenido.
#let dibujar(
  adyacencias: arbol-base,
  posiciones: posiciones-base,
  marcas: (),
  etiquetas: (:),
  nombres: (:),
  enlaces: (),
  secuencia: none,
) = {
  let rotulos = nombres
  for limite in ("limite-izquierdo", "limite-derecho") {
    if limite in adyacencias { rotulos.insert(limite, []) }
  }
  let dibujo = graph(
    adyacencias, labels: rotulos,
    layout: "manual", positions: posiciones,
    node-customizations: marcas, node-labels: etiquetas,
    edge-customizations: enlaces, style: estilo-arbol,
  ).diagram
  if secuencia == none {
    dibujo
  } else {
    let alto = if secuencia == "inorden" { 6cm } else { 5.6cm }
    block(width: 9cm, height: alto, align(top + center, dibujo))
  }
}

// Misma representación para los pasos de preorden, inorden y postorden.
#let dibujar-paso-recorrido(orden, paso) = {
  let visitados = orden.slice(0, paso.cantidad)
  let marcas = arbol-base.keys().filter(valor => valor != str(paso.actual)).map(valor => {
    if int(valor) in visitados {
      encontrado(valor)
    } else {
      destacar(valor, stroke: 0.8pt + rgb("#333333"))
    }
  })
  marcas.push(destacar(
    paso.actual,
    fill: if paso.actual in visitados { rgb("#D5E8D4") } else { none },
  ))
  let enlaces = ()
  for j in range(paso.camino.len() - 1) {
    enlaces.push((
      str(paso.camino.at(j)), str(paso.camino.at(j + 1)),
      (stroke: trazo-recorrido),
    ))
  }
  dibujar(
    marcas: marcas, enlaces: enlaces,
    secuencia: "inorden",
  )
  parbreak()
  block(width: 9cm, align(left,
    text(size: 10pt, "[" + visitados.map(str).join(", ") + "]"),
  ))
}
