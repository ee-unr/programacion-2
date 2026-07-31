#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import fletcher.shapes: diamond, ellipse

#set page(width: 240mm, height: 160mm, margin: 8mm)

#set text(font: "Noto Sans", size: 16pt)

#fletcher.diagram(
  spacing: (12mm, 12mm),
  node-stroke: 2pt,
  edge-stroke: 1.5pt,
  node-corner-radius: 4pt,
  node-outset: 5pt,

  node(
    (-100pt, 340pt),
    [¿Aprobaste\ el parcial?],
    name: <parcial>,
    width: 50mm,
    height: 25mm,
    fill: rgb("#efe4bf"),
    stroke: rgb("#d0aa43"),
    shape: ellipse,
  ),

  edge(<parcial.south>, <recuperatorio.north>, "-|>", [No #emoji.face.sad], label-side: right),
  edge(<parcial.east>, <tp.west>, "-|>", [Sí #emoji.face.beam]),

  node(
    (-100pt, 180pt),
    [¿Aprobaste el\ recuperatorio?],
    name: <recuperatorio>,
    width: 60mm,
    height: 25mm,
    fill: rgb("#efe4bf"),
    stroke: rgb("#d0aa43"),
    shape: ellipse,
  ),

  edge(<recuperatorio.east>, <tp.south-west>, "-|>", [Sí #emoji.face.cover]),

  node(
    (-100pt, 0pt),
    [Libre],
    name: <libre>,
    width: 38mm,
    height: 20mm,
    fill: rgb("#d9d0e2"),
    stroke: rgb("#8f73a8"),
  ),
  edge(<recuperatorio.south>, <libre.north>, "-|>", [No #emoji.face.cry]),

  node(
    (150pt, 340pt),
    [¿Aprobaste\ el TP?],
    name: <tp>,
    width: 50mm,
    height: 25mm,
    fill: rgb("#efe4bf"),
    stroke: rgb("#d0aa43"),
    shape: ellipse,
  ),

  edge(<tp.east>, <promedio.north>, "-|>", [Sí #emoji.face.cool], corner: right),
  edge(<tp.south>, <libre.east>, "-|>", [No #emoji.face.fear.sweat], bend: 30deg, label-side: right),

  node(
    (300pt, 160pt),
    [¿Promedio\ mayor a 8?],
    name: <promedio>,
    width: 50mm,
    height: 25mm,
    fill: rgb("#efe4bf"),
    stroke: rgb("#d0aa43"),
    shape: ellipse,
  ),

  node(
    (200pt, 0pt),
    [Regular],
    name: <regular>,
    width: 38mm,
    height: 20mm,
    fill: rgb("#d9d0e2"),
    stroke: rgb("#8f73a8"),
  ),

  node(
    (400pt, 0pt),
    [Promovido],
    name: <promovido>,
    width: 38mm,
    height: 20mm,
    fill: rgb("#d9d0e2"),
    stroke: rgb("#8f73a8"),
  ),


  edge(<promedio.south>, <regular.north>, "-|>", [No #emoji.face.meh]),
  edge(<promedio.south>, <promovido.north>, "-|>", [Sí #emoji.face.stars]),
)
