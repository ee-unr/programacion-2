#import "estilo.typ": diagrama

#set page(width: auto, height: auto, margin: 8pt)
#set text(font: "Cascadia Code", size: 10pt)

#diagrama(
  (
    "Exception": ("LookupError", "ValueError"),
    "LookupError": ("IndexError", "KeyError"),
    "ValueError": (),
    "IndexError": (),
    "KeyError": (),
  ),
  (
    "Exception": (0, 0),
    "LookupError": (-2.5, -1.6),
    "ValueError": (2.5, -1.6),
    "IndexError": (-4.1, -3.2),
    "KeyError": (-0.9, -3.2),
  ),
)
