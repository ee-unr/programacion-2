#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: ellipse

#set page(width: 170mm, height: 300mm, margin: 8mm)
#set text(font: "Noto Sans", size: 18pt)

#let edge-label(body) = text(size: 20pt, raw(body))

#let condition-fill = rgb("#efe4bf")
#let condition-stroke = rgb("#d0aa43")
#let block-fill = rgb("#d9d0e2")
#let block-stroke = rgb("#8f73a8")
#let terminal-fill = rgb("#dcefd8")
#let terminal-stroke = rgb("#6aa84f")

#fletcher.diagram(
  spacing: (12mm, 12mm),
  node-stroke: 2pt,
  edge-stroke: 1.5pt,
  node-corner-radius: 4pt,
  node-outset: 5pt,

  node((0pt, 750pt), [Inicio], name: <inicio>, width: 38mm, height: 20mm, fill: terminal-fill, stroke: terminal-stroke),
  edge(<inicio.south>, <condicion-1.north>, "-|>"),

  node((0pt, 600pt), [Condición 1], name: <condicion-1>, width: 50mm, height: 25mm, fill: condition-fill, stroke: condition-stroke, shape: ellipse),
  node((240pt, 600pt), [Ejecutar bloque\ if], name: <bloque-if>, width: 56mm, height: 22mm, fill: block-fill, stroke: block-stroke),

  node((0pt, 450pt), [Condición 2], name: <condicion-2>, width: 50mm, height: 25mm, fill: condition-fill, stroke: condition-stroke, shape: ellipse),
  node((240pt, 450pt), [Ejecutar bloque\ elif 1], name: <bloque-elif-1>, width: 56mm, height: 22mm, fill: block-fill, stroke: block-stroke),

  node((0pt, 300pt), [Condición 3], name: <condicion-3>, width: 50mm, height: 25mm, fill: condition-fill, stroke: condition-stroke, shape: ellipse),
  node((240pt, 300pt), [Ejecutar bloque\ elif 2], name: <bloque-elif-2>, width: 56mm, height: 22mm, fill: block-fill, stroke: block-stroke),

  node((0pt, 150pt), [Condición 4], name: <condicion-4>, width: 50mm, height: 25mm, fill: condition-fill, stroke: condition-stroke, shape: ellipse),
  node((240pt, 150pt), [Ejecutar bloque\ elif 3], name: <bloque-elif-3>, width: 56mm, height: 22mm, fill: block-fill, stroke: block-stroke),

  node((0pt, 0pt), [Fin], name: <fin>, width: 38mm, height: 20mm, fill: terminal-fill, stroke: terminal-stroke),

  edge(<condicion-1.east>, <bloque-if.west>, "-|>", edge-label("True")),
  edge(<condicion-1.south>, <condicion-2.north>, "-|>", edge-label("False"), label-side: right),
  edge(<condicion-2.east>, <bloque-elif-1.west>, "-|>", edge-label("True")),
  edge(<condicion-2.south>, <condicion-3.north>, "-|>", edge-label("False"), label-side: right),
  edge(<condicion-3.east>, <bloque-elif-2.west>, "-|>", edge-label("True")),
  edge(<condicion-3.south>, <condicion-4.north>, "-|>", edge-label("False"), label-side: right),
  edge(<condicion-4.east>, <bloque-elif-3.west>, "-|>", edge-label("True")),
  edge(<condicion-4.south>, <fin.north>, "-|>", edge-label("False"), label-side: right),
  edge(<bloque-if.east>, (360pt, 600pt), (360pt, 0pt), <fin.east>, "-|>"),
  edge(<bloque-elif-1.east>, (360pt, 450pt), (360pt, 0pt), <fin.east>, "-|>"),
  edge(<bloque-elif-2.east>, (360pt, 300pt), (360pt, 0pt), <fin.east>, "-|>"),
  edge(<bloque-elif-3.east>, (360pt, 150pt), (360pt, 0pt), <fin.east>, "-|>"),
)
