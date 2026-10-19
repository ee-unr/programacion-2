// Adaptado de ee-unr/programacion-python/slides/template.typ.
// Paleta y tipografía de styles.scss. Formato 16:9.
#import "@preview/touying:0.8.0": *

#import "@preview/gentle-clues:1.3.1": clue

#let course-primary = rgb("#2e7d8a")
#let highlight-box(title: none, body) = clue(
  title: title,
  accent-color: course-primary,
  header-color: rgb("#e9ecef"),
  border-color: rgb("#d3d3d3"),
  body-color: rgb("#f8f9fa"),
  width: 100%,
  radius: 4pt,
  border-width: 0.5pt,
  stroke-width: 3pt,
  content-inset: (x: 12pt, y: 10pt),
  header-inset: (x: 12pt, y: 8pt),
  breakable: false,
  body,
)

#let page-stroke = stroke(thickness: 2pt, paint: course-primary, cap: "butt")
#let new-section-stroke = stroke(thickness: 3pt, paint: course-primary, cap: "butt")
#let margin-text-size = 0.6em

#let current-section-state = state("current-section-state", "")

#let slide-number = context counter("touying-slide-counter").display()
#let current-section = context current-section-state.get()
#let register-section(title) = current-section-state.update(title)

#let setup-template(
  title: none,
  subtitle: none,
  author: none,
  date: none,
  header-label: none,
  footer-label: none,
  institution: none,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-16-9",
      margin: (x: 1.5cm, top: 1.6cm, bottom: 1.3cm),
      footer: [
        #set text(size: margin-text-size)
        #set align(horizon)

        #footer-label #h(1fr) #slide-number
      ],
      header: box(stroke: (bottom: page-stroke), inset: (x: 0pt, y: 8pt))[
        #set text(size: margin-text-size)
        #set align(horizon)
        #h(1fr)
        #if header-label != none {
          [#header-label | #text(current-section, fill: course-primary)]
        } else {
          [#text(current-section, fill: course-primary)]
        }
      ],
    ),
    config-common(
      slide-fn: slide,
      zero-margin-header: false,
      zero-margin-footer: false,
    ),
  )

  set text(font: "Atkinson Hyperlegible", size: 21pt, fill: rgb("#343a40"))
  show link: set text(course-primary)
  show raw: set text(font: "Cascadia Code")
  show math.equation: set text(font: "DejaVu Math TeX Gyre")
  show heading: set block(below: 0.8em)
  show heading: set text(size: 1.2em)

  // Tamano de texto del codigo cuando esta en un parrafo
  show raw.where(block: false): set text(size: 1.1em)

  // Tamano de texto del codigo cuando esta en un bloque de codigo
  show raw.where(block: true): set text(size: 14pt)
  show raw.where(block: true): it => block(
    fill: rgb("#f5f5f5"),
    stroke: stroke(thickness: 1pt, paint: rgb("#d0d0d0")),
    inset: 8pt,
    radius: 4pt,
    width: 100%,
    it,
  )
  set list(spacing: 0.75em)

  slide(config: config-page(header: none, footer: none))[
    #set align(horizon)
    #stack(
      text(size: 2em, weight: "bold",  title),
      {
        if subtitle != none {
            v(1.2em)
            text(size: 1.4em, subtitle)
        }
      }
    )
    #line(stroke: new-section-stroke, length: 100%)
    #author

    #institution

    #date

  ]
  body
}

#let new-section-slide(title) = {
  slide(config: config-page(header: none, footer: none, fill: rgb("#1a4a52")))[
    #set align(horizon)
    #set align(center)
    #set text(size: 2em, fill: white)
    #strong(title)
    #register-section(title)
  ]
}

#let inverted-slide(top, bottom: none) = {
  slide(config: config-page(header: none, footer: none, fill: rgb("#1a4a52")))[
    #set align(horizon)
    #set text(size: 2em, fill: white)
    #set align(center)
    #strong(top)
    // #line(stroke: 3pt + white, length: 100%)

    #strong(bottom)
  ]
}
