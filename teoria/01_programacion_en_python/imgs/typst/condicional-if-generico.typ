#import "code-highlight.typ": code-highlight

#set page(width: 140mm, height: 60mm, margin: 0pt)
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
      width: 90%,
    )[
      ```python
      if <expresión condicional>:
          <cuerpo bloque if>
      ```
    ]
  ]
]

#paso()
#paso(highlights: ((line: 1, start: 0, end: 1),))
#paso(highlights: ((line: 1, start: 3, end: 26),))
#paso(highlights: ((line: 1, start: 27, end: 27),))
#paso(highlights: ((line: 2, start: 4, end: 21),))
