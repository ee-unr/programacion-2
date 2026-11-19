#import "base.typ": *

// El árbol fija el alto de la fila, sin reservar espacio adicional debajo.
#let escena(titulo, arbol, salida, alinear-salida: top, ancho-salida: 5cm, ancho-arbol: 9.5cm, separacion: 10pt) = {
  show raw: set text(font: "Cascadia Code", size: 10pt)
  grid(
    columns: (ancho-arbol, ancho-salida), column-gutter: separacion,
    align: (columna, fila) => left + if columna == 1 { alinear-salida } else { top },
    block(width: ancho-arbol, [
      #if titulo != none {
        text(size: 10pt, weight: "bold", titulo)
        v(10pt)
      }
      #align(center, arbol)
    ]),
    block(width: ancho-salida, salida),
  )
}

// La última línea incorporada se distingue de las anteriores.
#let lineas-salida(lineas, cantidad) = {
  stack(dir: ttb, spacing: 7pt,
    ..lineas.slice(0, cantidad).enumerate().map(((i, linea)) =>
      text(fill: rgb("#333333"), weight: if i == cantidad - 1 { "bold" } else { "regular" },
        raw(linea),
      )
    ),
  )
}

// Nodos transparentes que fijan los límites, sin alterar las posiciones del árbol.
#let reservar-limites(adyacencias, posiciones, marcas, izquierda, derecha) = {
  adyacencias.insert("limite-izquierdo", ())
  adyacencias.insert("limite-derecho", ())
  posiciones.insert("limite-izquierdo", izquierda)
  posiciones.insert("limite-derecho", derecha)
  marcas.push(("limite-izquierdo", invisible))
  marcas.push(("limite-derecho", invisible))
  (adyacencias, posiciones, marcas)
}
