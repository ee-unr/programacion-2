// #let code-fill = rgb("#f7f7f7")
#let code-fill = rgb("#ffffff")
#let code-stroke = stroke(thickness: 0pt, paint: rgb("#d6d6d6"))
#let default-highlight-fill = rgb(0, 0, 255, 50)
#let default-highlight-pad = (
  left: 0pt,
  right: 0pt,
  top: 0pt,
  bottom: 0pt,
)
#let default-highlight-radius = 2pt
#let default-highlight-stroke = 0pt

#let normalize-pad(pad) = {
  if type(pad) == length {
    (
      left: pad,
      right: pad,
      top: pad,
      bottom: pad,
    )
  } else if type(pad) == dictionary {
    let x = pad.at("x", default: 0pt)
    let y = pad.at("y", default: 0pt)

    (
      left: pad.at("left", default: x),
      right: pad.at("right", default: x),
      top: pad.at("top", default: y),
      bottom: pad.at("bottom", default: y),
    )
  } else {
    default-highlight-pad
  }
}

#let clean-lines(text) = {
  let lines = text.split("\n")

  if lines.len() > 0 and lines.first() == "" {
    lines = lines.slice(1)
  }

  if lines.len() > 0 and lines.last() == "" {
    lines = lines.slice(0, lines.len() - 1)
  }

  lines
}

#let body-text(body) = {
  if "text" in body.fields() {
    body.text
  } else if "children" in body.fields() {
    for child in body.children {
      if "text" in child.fields() {
        return child.text
      }
    }

    panic("code-highlight necesita un bloque raw, por ejemplo: #code-highlight(...)[```python ... ```].")
  } else {
    panic("code-highlight necesita un bloque raw, por ejemplo: #code-highlight(...)[```python ... ```].")
  }
}

#let line-segments(line-number, highlights) = {
  let segments = ()

  for highlight in highlights {
    if type(highlight) == dictionary and highlight.at("line", default: none) == line-number {
      segments.push(highlight)
    }
  }

  segments
}

#let validate-highlight(highlight, lines) = {
  if type(highlight) != dictionary {
    panic("code-highlight: cada resaltado debe ser un diccionario.")
  }

  for key in ("line", "start", "end") {
    if not (key in highlight) {
      panic("code-highlight: falta la clave `" + key + "` en un resaltado.")
    }
  }

  let line-number = highlight.line
  let start = highlight.start
  let end = highlight.end

  if type(line-number) != int or line-number < 1 or line-number > lines.len() {
    panic("code-highlight: `line` debe estar entre 1 y " + str(lines.len()) + ".")
  }

  let line = lines.at(line-number - 1)

  if type(start) != int or type(end) != int {
    panic("code-highlight: `start` y `end` deben ser enteros.")
  }

  if start < 0 or end < start or end >= line.len() {
    panic(
      "code-highlight: rango invalido en linea "
        + str(line-number)
        + "; use 0 <= start <= end < "
        + str(line.len())
        + ".",
    )
  }
}

#let next-segment(segments, after) = {
  let next = none

  for segment in segments {
    if segment.start >= after and (next == none or segment.start < next.start) {
      next = segment
    }
  }

  next
}

#let code-fragment(text, lang) = raw(text, lang: lang, block: false)

#let highlighted-code-fragment(text, highlight, lang) = {
  let pad = normalize-pad(highlight.pad)

  box(
    fill: highlight.fill,
    radius: highlight.radius,
    stroke: highlight.stroke,
    inset: (
      left: pad.left,
      right: pad.right,
      top: pad.top,
      bottom: pad.bottom,
    ),
  )[
    #code-fragment(text, lang)
  ]
}

#let code-line(line-number, line, highlights, lang, line-height, inner-x) = {
  let segments = line-segments(line-number, highlights)

  box(
    width: 100%,
    height: line-height,
    inset: (x: inner-x, y: 0pt),
  )[
    #set align(left + horizon)

    #context {
      for segment in segments {
        let pad = normalize-pad(segment.pad)
        let start = segment.start
        let exclusive-end = calc.min(segment.end + 1, line.len())

        let before = code-fragment(line.slice(0, start), lang)
        let selected = code-fragment(line.slice(start, exclusive-end), lang)

        let before-size = measure(before)
        let selected-size = measure(selected)

        place(
          left + horizon,
          dx: before-size.width - pad.left,
          dy: (pad.bottom - pad.top) / 2,
        )[
          #rect(
            width: selected-size.width + pad.left + pad.right,
            height: selected-size.height + pad.top + pad.bottom,
            fill: segment.fill,
            radius: segment.radius,
            stroke: segment.stroke,
          )
        ]
      }

      code-fragment(line, lang)
    }
  ]
}


#let code-highlight(
  highlights: (),
  fill: default-highlight-fill,
  pad: default-highlight-pad,
  radius: default-highlight-radius,
  highlight-stroke: default-highlight-stroke,
  lang: "python",
  width: 78%,
  size: 22pt,
  line-height: 1.35em,
  inset: (x: 10pt, y: 8pt),
  body,
) = {
  let lines = clean-lines(body-text(body))

  for highlight in highlights {
    validate-highlight(highlight, lines)
  }

  let highlights = highlights.map(highlight => {
    highlight + (
      fill: highlight.at("fill", default: fill),
      pad: highlight.at("pad", default: pad),
      radius: highlight.at("radius", default: radius),
      stroke: highlight.at("stroke", default: highlight-stroke),
    )
  })

  box(
    width: width,
    fill: code-fill,
    stroke: code-stroke,
    inset: (x: 0pt, y: inset.y),
    radius: 3pt,
  )[
    #set text(font: "Fira Mono", size: size)
    #stack(
      dir: ttb,
      spacing: 0pt,
      ..range(lines.len()).map(i => code-line(
        i + 1,
        lines.at(i),
        highlights,
        lang,
        line-height,
        inset.x,
      )),
    )
  ]
}
