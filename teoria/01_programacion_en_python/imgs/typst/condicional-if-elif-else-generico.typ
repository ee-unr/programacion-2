#import "code-highlight.typ": code-highlight

#set page(width: 140mm, height: 90mm, margin: 0pt)
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
      if <condición A>:
          <cuerpo bloque if>
      elif <condición B>:
          <cuerpo bloque elif>
      else:
          <cuerpo bloque else>
      ```
    ]
  ]
]

#paso()
#paso(highlights: ((line: 1, start: 0, end: 1),))
#paso(highlights: ((line: 1, start: 3, end: 16),))
#paso(highlights: ((line: 1, start: 17, end: 17),))
#paso(highlights: ((line: 2, start: 4, end: 21),))
#paso(highlights: ((line: 3, start: 0, end: 3),))
#paso(highlights: ((line: 3, start: 5, end: 18),))
#paso(highlights: ((line: 3, start: 19, end: 19),))
#paso(highlights: ((line: 4, start: 4, end: 23),))
#paso(highlights: ((line: 5, start: 0, end: 3),))
#paso(highlights: ((line: 5, start: 4, end: 4),))
#paso(highlights: ((line: 6, start: 4, end: 23),))
