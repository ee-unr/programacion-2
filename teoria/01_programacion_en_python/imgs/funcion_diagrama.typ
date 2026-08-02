#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#set page(width: 170mm, height: 110mm, margin: 0mm)
#set text(font: "Noto Sans", size: 16pt)

#let data-fill = rgb("#fff2cc")
#let data-stroke = rgb("#d6b656")
#let meta-fill = rgb("#e1d5e7")
#let meta-stroke = rgb("#9673a6")
#let effect-fill = rgb("#dae8fc")
#let effect-stroke = rgb("#6c8ebf")

#let main-node(body, name, pos) = node(
  pos,
  body,
  name: name,
  width: 32mm,
  height: 16mm,
  fill: data-fill,
  stroke: data-stroke,
)

#let meta-node(body, name, pos) = node(
  pos,
  body,
  name: name,
  width: 40mm,
  height: 16mm,
  fill: meta-fill,
  stroke: meta-stroke,
  corner-radius: 0pt,
)

#align(center + horizon)[
  #diagram(
    // debug: true,
    node-stroke: 1.5pt,
    edge-stroke: 1.2pt,
    node-corner-radius: 3pt,
    node-outset: 3pt,

    meta-node([Parámetros\ de la función], <parametros>, (0, 0)),
    meta-node([Cuerpo de la\ función], <cuerpo>, (1, 0)),
    meta-node([Valores\ retornados], <retornos>, (2, 0)),

    main-node([Entrada], <entrada>, (0, 2)),
    main-node([Proceso], <proceso>, (1, 2)),
    main-node([Salida], <salida>, (2, 2)),

    node(
      (2, 3),
      [Efectos\ colaterales],
      name: <efectos>,
      width: 32mm,
      height: 16mm,
      fill: effect-fill,
      stroke: effect-stroke,
    ),
    edge(<entrada>, <proceso>, "-|>"),
    edge(<proceso>, <salida>, "-|>"),
    edge(<entrada.north>, <parametros.south>, "--", stroke: (dash: "dashed")),
    edge(<proceso.north>, <cuerpo.south>, "--", stroke: (dash: "dashed")),
    edge(<salida.north>, <retornos.south>, "--", stroke: (dash: "dashed")),
    edge(<proceso.south>, (1, 3), <efectos.west>, "--|>", stroke: (dash: "dashed")),
  )
]
