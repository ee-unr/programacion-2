#import "code-highlight.typ": code-highlight

#set page(width: 150mm, height: 140mm, margin: 0pt)
#set text(size: 18pt)

#let highlight-fill = rgb(0, 0, 255, 50)
#let highlight-pad = (left: 2pt, right: 2pt, top: 5pt, bottom: 5pt)

#let paso(highlights: ()) = page[
  #place(center + horizon)[
    #code-highlight(
      highlights: highlights,
      fill: highlight-fill,
      pad: highlight-pad,
      size: 24pt,
      width: 95%,
    )[
      ```python
      parcial = 8
      tp_grupal = 7
      tp_individual = 5

      if parcial < 6 or tp_grupal < 6:
          condicion = "Libre"
      elif tp_individual >= 6:
          condicion = "Promovido"
      else:
          condicion = "Regular"
      print(condicion)
      ```
    ]
  ]
]

#paso()

#paso(highlights: ((line: 5, start: 0, end: 1),))
#paso(highlights: ((line: 5, start: 3, end: 30),))
#paso(highlights: ((line: 5, start: 31, end: 31),))
#paso(highlights: ((line: 6, start: 4, end: 22),))
#paso(highlights: ((line: 7, start: 0, end: 3),))
#paso(highlights: ((line: 7, start: 5, end: 22),))
#paso(highlights: ((line: 7, start: 23, end: 23),))
#paso(highlights: ((line: 8, start: 4, end: 26),))
#paso(highlights: ((line: 9, start: 0, end: 3),))
#paso(highlights: ((line: 9, start: 4, end: 4),))
#paso(highlights: ((line: 10, start: 4, end: 24),))
#paso(highlights: ((line: 11, start: 0, end: 15),))
