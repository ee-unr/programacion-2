#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: diamond, ellipse

#set page(width: 150mm, height: 220mm, margin: 0mm)
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
      [Condición 1],
      name: <condicion-1>,
      width: 30mm,
      height: 25mm,
      fill: condition-fill,
      stroke: condition-stroke,
      shape: diamond,
    ),
    edge(<inicio.south>, <condicion-1.north>, "-|>"),
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
      [Condición 2],
      name: <condicion-2>,
      width: 30mm,
      height: 25mm,
      fill: condition-fill,
      stroke: condition-stroke,
      shape: diamond,
    ),
    node(
      (2, 3),
      [Ejecutar\ bloque `elif`],
      name: <bloque-elif>,
      width: 40mm,
      height: 20mm,
      fill: block-fill,
      stroke: block-stroke,
    ),
    node(
      (0, 5),
      [Ejecutar\ bloque `else`],
      name: <bloque-else>,
      width: 40mm,
      height: 20mm,
      fill: block-fill,
      stroke: block-stroke,
    ),
    node(
      (0, 6),
      [Fin],
      name: <fin>,
      width: 35mm,
      height: 15mm,
      fill: terminal-fill,
      stroke: terminal-stroke,
    ),
    edge(<condicion-1.east>, <bloque-if.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
    edge(<condicion-1.south>, <condicion-2.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
    edge(<condicion-2.east>, <bloque-elif.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
    edge(<condicion-2.south>, <bloque-else.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
    edge(<bloque-if.east>, (3, 1), (3, 6), <fin.east>, "-|>"),
    edge(<bloque-elif.east>, (3, 3), (3, 6), <fin.east>, "-|>"),
    edge(<bloque-else.south>, <fin.north>, "-|>"),
  )
]
