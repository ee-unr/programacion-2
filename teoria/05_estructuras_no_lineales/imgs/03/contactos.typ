#import "@preview/typed-dsa:0.7.0": graph
#import "base.typ": documento, estilo-grafo
#show: documento

#graph(
  (
    "Ana": ("Bruno", "Carla"),
    "Bruno": ("Diego",),
    "Carla": ("Diego", "Elena"),
    "Diego": (), "Elena": (),
  ),
  directed: false, layout: "manual",
  positions: (
    "Ana": (0, 2.5), "Bruno": (-2.5, 0), "Carla": (2.5, 0),
    "Diego": (-2.5, -2.5), "Elena": (2.5, -2.5),
  ),
  style: estilo-grafo,
).diagram
