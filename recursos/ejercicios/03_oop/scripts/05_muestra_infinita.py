class Muestra:
    def __init__(self, iterable):
        self._datos = list(iterable) # guardo el iterable en una lista

    def agregar(self, x):
        self._datos.append(x)

    def n(self):
        return len(self._datos)

    def suma(self):
        return sum(self._datos)

    def media(self):
        n = self.n()
        return self.suma() / n

    def varianza(self, muestral=False):
        """Varianza de la muestra

        - Poblacional (por defecto): sum((xi - μ)^2) / n
        - Muestral (muestral=True):   sum((xi - x̄)^2) / (n - 1)
        """

        n = self.n()
        mu = self.media()
        ssd = sum((x - mu) ** 2 for x in self._datos)  # suma de cuadrados

        if muestral:
            denom = n - 1
        else:
            denom = n

        # otra opción
        # denom = n - 1 if muestral else n

        return ssd / denom

    @property
    def valores(self):
        """Copia inmutable de los datos (evita exponer el interno)."""
        return tuple(self._datos)



if __name__ == "__main__":
    m = Muestra([10, 12, 13, 15])
    m.agregar(20)
    print(m.n()) # 5
    print(m.suma()) # 70
    print(m.media()) # 14.0
    print(m.varianza()) # 11.6
    print(m.varianza(muestral=True)) # 14.5
    print(m.valores)  # (10, 12, 13, 15, 20)
