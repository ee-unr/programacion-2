#import "base.typ": *
#show: documento

// La nueva raíz, 42, deja a 45 en el subárbol incorrecto.
#dibujar(nombres: ("50": [42]), marcas: (eliminado(45),))
