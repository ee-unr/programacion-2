class ManoDeTruco:
    def __init__(self, cartas):
        self.cartas = cartas

    def comparar_con(self, other):
        if self.puntos() >= other.puntos():
            return self
        return other

    def puntos(self):
        n_altas = len([carta for carta in self.cartas if carta >= 10])
        if n_altas == 3:
            # Si solo se tienen cartas altas, los puntos son 20.
            return 20
        elif n_altas == 2:
            # Si se tienen 2 cartas altas los puntos son 20 + la carta que no esta en ese conjunto.
            return 20 + min(self.cartas)
        elif n_altas == 1:
            # Si 1 cartas alta, los puntos son 20 + la suma de las dos cartas bajas
            return 20 + sum(sorted(self.cartas)[:2])
        # Caso contrario, es la suma de las dos cartas mas altas + 20
        return 20 + sum(sorted(self.cartas)[-2:])


mano1 = ManoDeTruco([7, 5, 6])
mano2 = ManoDeTruco([4, 11, 2])

mano1.comparar_con(mano2)

mano1.puntos()
mano2.puntos()
