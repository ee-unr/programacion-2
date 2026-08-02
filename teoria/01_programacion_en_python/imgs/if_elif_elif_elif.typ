#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: diamond, ellipse

#set page(width: 150mm, height: 300mm, margin: 0mm)
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
        text(size: 15pt)[Ejecutar\ bloque `if`],
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
        text(size: 15pt)[Ejecutar\ bloque `elif 1`],
        name: <bloque-elif-1>,
        width: 40mm,
        height: 20mm,
        fill: block-fill,
        stroke: block-stroke,
      ),
      node(
        (0, 5),
        [Condición 3],
        name: <condicion-3>,
        width: 30mm,
        height: 25mm,
        fill: condition-fill,
        stroke: condition-stroke,
        shape: diamond,
      ),
      node(
        (2, 5),
        text(size: 15pt)[Ejecutar\ bloque `elif 2`],
        name: <bloque-elif-2>,
        width: 40mm,
        height: 20mm,
        fill: block-fill,
        stroke: block-stroke,
      ),
      node(
        (0, 7),
        [Condición 4],
        name: <condicion-4>,
        width: 30mm,
        height: 25mm,
        fill: condition-fill,
        stroke: condition-stroke,
        shape: diamond,
      ),
      node(
        (2, 7),
        text(size: 15pt)[Ejecutar\ bloque `elif 3`],
        name: <bloque-elif-3>,
        width: 40mm,
        height: 20mm,
        fill: block-fill,
        stroke: block-stroke,
      ),
      node(
        (0, 8.5),
        [Fin],
        name: <fin>,
        width: 35mm,
        height: 15mm,
        fill: terminal-fill,
        stroke: terminal-stroke,
      ),
      edge(<condicion-1.east>, <bloque-if.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
      edge(<condicion-1.south>, <condicion-2.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
      edge(<condicion-2.east>, <bloque-elif-1.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
      edge(<condicion-2.south>, <condicion-3.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
      edge(<condicion-3.east>, <bloque-elif-2.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
      edge(<condicion-3.south>, <condicion-4.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
      edge(<condicion-4.east>, <bloque-elif-3.west>, "-|>", `True`, label-pos: 0.45, label-side: center),
      edge(<condicion-4.south>, <fin.north>, "-|>", `False`, label-pos: 0.45, label-side: center),
      edge(<bloque-if.east>, (3, 1), (3, 8.5), <fin.east>, "-|>"),
      edge(<bloque-elif-1.east>, (3, 3), (3, 8.5), <fin.east>, "-|>"),
      edge(<bloque-elif-2.east>, (3, 5), (3, 8.5), <fin.east>, "-|>"),
      edge(<bloque-elif-3.east>, (3, 7), (3, 8.5), <fin.east>, "-|>"),
    )
]
