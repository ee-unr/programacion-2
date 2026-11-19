#import "base.typ": *
#show: documento

#let niveles = ((50,), (30, 70), (20, 40, 60, 80), (45,))

#for (paso, nivel) in niveles.enumerate() {
  if paso > 0 { pagebreak() }
  dibujar(marcas: nivel.map(valor => destacar(valor)), secuencia: "niveles")
}
