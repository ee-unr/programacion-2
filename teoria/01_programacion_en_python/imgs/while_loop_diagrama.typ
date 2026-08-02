#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: diamond

#set page(width: 170mm, height: 140mm, margin: 0mm)
#set text(font: "Noto Sans", size: 18pt)
#show raw: set text(size: 12pt)

#let condition-fill = rgb("#efe4bf")
#let condition-stroke = rgb("#d0aa43")
#let block-fill = rgb("#d9d0e2")
#let block-stroke = rgb("#8f73a8")
#let terminal-fill = rgb("#dcefd8")
#let terminal-stroke = rgb("#6aa84f")


#align(center + horizon)[
  #diagram(
    // debug: true,
    node-stroke: 2pt,
    edge-stroke: 1.2pt,
    node-corner-radius: 4pt,
    node-outset: 5pt,
    node(
      (0, 0),
      [Inicio],
      name: <inicio>,
      width: 35mm,
      height: 15mm,
      fill: terminal-fill,
      stroke: terminal-stroke,
    ),
    node(
      (0, 1),
      [#raw("numero < 5", lang: "python")],
      name: <condicion>,
      width: 30mm,
      height: 25mm,
      fill: condition-fill,
      stroke: condition-stroke,
      shape: diamond,
    ),
    node(
      (2, 1),
      [#raw("numero += 1", lang: "python")],
      name: <incremento>,
      width: 40mm,
      height: 15mm,
      fill: block-fill,
      stroke: block-stroke,
    ),
    node(
      (2, 2),
      [#raw("print(f'El número es {numero}')", lang: "python")],
      name: <imprimir>,
      width: 85mm,
      height: 15mm,
      fill: block-fill,
      stroke: block-stroke,
    ),
    node(
      (0, 3),
      [Fin],
      name: <fin>,
      width: 35mm,
      height: 15mm,
      fill: terminal-fill,
      stroke: terminal-stroke,
    ),
    edge(<inicio.south>, <condicion.north>, "-|>"),
    edge(<condicion.east>, <incremento.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
    edge(<condicion.south>, <fin.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
    edge(<incremento.south>, <imprimir.north>, "-|>"),
    edge(<imprimir.west>,  (0, 1), "-|>"),
  )
]
