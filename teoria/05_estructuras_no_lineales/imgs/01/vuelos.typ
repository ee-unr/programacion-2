#import "estilo.typ": diagrama

#set page(width: auto, height: auto, margin: 8pt)
#set text(font: "Cascadia Code", size: 10pt)

// Conexiones directas consultadas el 18 de noviembre de 2026.
// Buenos Aires agrupa Aeroparque y Ezeiza; San Pablo representa Guarulhos.
// Fuentes y fecha de consulta en 01_introduccion.qmd.
#diagrama(
  (
    "Rosario": ("Buenos Aires", "Salta", "San Pablo", "Lima"),
    "Buenos Aires": ("Córdoba", "Mendoza", "Salta", "San Pablo", "Lima", "Ushuaia"),
    "Córdoba": ("Mendoza", "Salta", "San Pablo", "Lima"),
    "Mendoza": ("Salta", "San Pablo", "Lima"),
    "Salta": ("Lima",),
    "San Pablo": ("Lima", "Ushuaia"),
    "Lima": (),
    "Ushuaia": (),
  ),
  (
    "Rosario": (-4.6, 0),
    "Buenos Aires": (-2.9, -3.6),
    "Córdoba": (1.0, -4.5),
    "Mendoza": (4.1, -2.0),
    "Salta": (4.1, 2.0),
    "San Pablo": (1.0, 4.5),
    "Lima": (-2.9, 3.6),
    "Ushuaia": (-6.9, -4.8),
  ),
  dirigido: false,
)
