#import "@preview/typed-dsa:0.7.0": graph
#import "estilo.typ": estilo

#set page(width: auto, height: auto, margin: 8pt)
#set text(font: "Cascadia Code", size: 10pt)

#let etiqueta(icono, nombre) = grid(
  columns: (auto, auto),
  column-gutter: 4pt,
  align: horizon,
  text(font: "Noto Color Emoji", size: 15pt, icono),
  nombre,
)

#graph(
  (
    "proyecto/": ("documentos/", "imagenes/", "README.md"),
    "documentos/": ("informe.pdf",),
    "imagenes/": (),
    "README.md": (),
    "informe.pdf": (),
  ),
  layout: "manual",
  positions: (
    "proyecto/": (0, 0),
    "documentos/": (-3.8, -1.8),
    "imagenes/": (0, -1.8),
    "README.md": (3.8, -1.8),
    "informe.pdf": (-3.8, -3.6),
  ),
  labels: (
    "proyecto/": etiqueta("📁", "proyecto/"),
    "documentos/": etiqueta("📁", "documentos/"),
    "imagenes/": etiqueta("📁", "imagenes/"),
    "README.md": etiqueta("📄", "README.md"),
    "informe.pdf": etiqueta("📄", "informe.pdf"),
  ),
  style: (..estilo, node-radius: 0.44),
).diagram
