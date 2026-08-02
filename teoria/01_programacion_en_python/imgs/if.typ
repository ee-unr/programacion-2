#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: diamond, ellipse

#set page(width: 140mm, height: 120mm, margin: 0mm)
#set text(font: "Noto Sans", size: 18pt)

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
        [Condición],
        name: <condicion>,
        width: 30mm,
        height: 25mm,
        fill: condition-fill,
        stroke: condition-stroke,
        shape: diamond,
      ),
      edge(<inicio.south>, <condicion.north>, "-|>"),
      node(
        (2, 1),
        [Ejecutar\ bloque `if`],
        name: <bloque-if>,
        width: 40mm,
        height: 20mm,
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
      edge(<condicion.east>, <bloque-if.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
      edge(<condicion.south>, <fin.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
      edge(<bloque-if.south>, (2, 3), <fin.east>, "-|>"),
    )
]

