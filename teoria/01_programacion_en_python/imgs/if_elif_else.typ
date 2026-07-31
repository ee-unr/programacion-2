#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: ellipse

#set page(width: 170mm, height: 250mm, margin: 8mm)
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

  node((0pt, 600pt), [Inicio], name: <inicio>, width: 38mm, height: 20mm, fill: terminal-fill, stroke: terminal-stroke),
  edge(<inicio.south>, <condicion-1.north>, "-|>"),

  node((0pt, 450pt), [Condición 1], name: <condicion-1>, width: 50mm, height: 25mm, fill: condition-fill, stroke: condition-stroke, shape: ellipse),
  node((240pt, 450pt), [Ejecutar bloque\ if], name: <bloque-if>, width: 56mm, height: 22mm, fill: block-fill, stroke: block-stroke),

  node((0pt, 300pt), [Condición 2], name: <condicion-2>, width: 50mm, height: 25mm, fill: condition-fill, stroke: condition-stroke, shape: ellipse),
  node((240pt, 300pt), [Ejecutar bloque\ elif], name: <bloque-elif>, width: 56mm, height: 22mm, fill: block-fill, stroke: block-stroke),

  node((0pt, 150pt), [Ejecutar\ bloque else], name: <bloque-else>, width: 52mm, height: 22mm, fill: block-fill, stroke: block-stroke),
  node((0pt, 0pt), [Fin], name: <fin>, width: 38mm, height: 20mm, fill: terminal-fill, stroke: terminal-stroke),

  edge(<condicion-1.east>, <bloque-if.west>, "-|>", edge-label("True")),
  edge(<condicion-1.south>, <condicion-2.north>, "-|>", edge-label("False"), label-side: right),
  edge(<condicion-2.east>, <bloque-elif.west>, "-|>", edge-label("True")),
  edge(<condicion-2.south>, <bloque-else.north>, "-|>", edge-label("False"), label-side: right),
  edge(<bloque-if.east>, (360pt, 450pt), (360pt, 0pt), <fin.east>, "-|>"),
  edge(<bloque-elif.east>, (360pt, 300pt), (360pt, 0pt), <fin.east>, "-|>"),
  edge(<bloque-else.south>, <fin.north>, "-|>"),
)
