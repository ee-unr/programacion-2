#import "@preview/typed-dsa:0.7.0": graph

#let estilo = (
  node-shape: "square",
  node-fit: true,
  node-radius: 0.34,
  node-fill: rgb("#DFEAF2"),
  node-stroke: 0.8pt + rgb("#333333"),
  node-text: (font: "Cascadia Code", size: 10pt, color: rgb("#333333")),
  edge-stroke: 0.8pt + rgb("#333333"),
  edge-arrow-fill: rgb("#333333"),
)

#let diagrama(adyacencias, posiciones, dirigido: true) = graph(
  adyacencias,
  directed: dirigido,
  layout: "manual",
  positions: posiciones,
  style: estilo,
).diagram
