#import "@preview/typed-dsa:0.7.0": graph
#import "../01/estilo.typ": estilo

// Selección de la red de la introducción, sin Buenos Aires ni Lima.
// Cada arista se declara una vez para dibujarla. En Python aparece en ambos sentidos.
#let conexiones = (
  "Rosario": ("Salta", "San Pablo"),
  "Salta": ("Córdoba", "Mendoza"),
  "Córdoba": ("Mendoza", "San Pablo"),
  "Mendoza": ("San Pablo",),
  "San Pablo": ("Ushuaia",),
  "Ushuaia": (),
)
#let posiciones = (
  "Rosario": (-4, 2.7), "Salta": (1, 2.7),
  "Mendoza": (1, 0), "Córdoba": (5, 0),
  "San Pablo": (1, -2.7), "Ushuaia": (-4, -2.7),
)
#let estilo-grafo = (..estilo, edge-stroke: 1pt + black)
#let verde = rgb("#D5E8D4")
#let documento(body) = {
  set page(width: auto, height: auto, margin: 6pt)
  set text(font: "Cascadia Code", size: 10pt, fill: rgb("#333333"))
  body
}

#let dibujar(visitados: (), actual: none, camino: ()) = {
  let marcas = visitados.map(v => (v, (fill: verde, stroke: 1pt + rgb("#82B366"))))
  if actual != none {
    marcas = marcas.filter(m => m.at(0) != actual)
    marcas.push((actual, (
      fill: if actual in visitados { verde } else { rgb("#DFEAF2") },
      stroke: 1.6pt + if actual in visitados { rgb("#3D7A36") } else { rgb("#0066CC") },
    )))
  }
  let enlaces = ()
  if camino.len() > 1 {
    for i in range(camino.len() - 1) {
      enlaces.push((camino.at(i), camino.at(i + 1), (stroke: 1.4pt + black)))
    }
  }
  graph(
    conexiones, directed: false, layout: "manual", positions: posiciones,
    node-customizations: marcas, edge-customizations: enlaces, style: estilo-grafo,
  ).diagram
}

// Una ciudad por línea permite comparar la salida con la pila o con la cola.
#let lista(titulo, valores) = block([
  #text(weight: "bold", titulo)
  #v(4pt)
  #if valores.len() == 0 { raw("[]") } else {
    stack(dir: ttb, spacing: 3pt, ..valores.map(v => raw(v)))
  }
])

#let paso(visitados, orden, pendientes, titulo, actual: none, camino: ()) = grid(
  columns: (11.5cm, 4.5cm), column-gutter: 14pt,
  block(width: 11.5cm, height: 7cm, align(top + center,
    dibujar(visitados: visitados, actual: actual, camino: camino),
  )),
  block(width: 4.5cm, height: 7cm, [
    #lista("Resultado", orden)
    #v(14pt)
    #lista(titulo, pendientes)
  ]),
)
