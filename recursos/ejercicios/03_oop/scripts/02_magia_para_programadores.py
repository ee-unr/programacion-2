import math

class Pocion:
    def __init__(self, color, volumen):
        self.color = color
        self.volumen = volumen

    def mezclar(self, other):
        # NOTE: Se puede hacer de manera más sencilla
        volumen_total = self.volumen + other.volumen
        w1 = self.volumen / volumen_total
        w2 = other.volumen / volumen_total

        color = [math.ceil(c1 * w1 + c2 * w2) for c1, c2 in zip(self.color, other.color)]
        return Pocion(color=color, volumen=volumen_total)



felix_felicis = Pocion([255, 255, 255],  7)
pocion_multijugos = Pocion([51, 102, 51], 12)
nueva_pocion = felix_felicis.mezclar(pocion_multijugos)

nueva_pocion.color # Devuelve [127, 159, 127]
nueva_pocion.volumen # Devuelve 19
