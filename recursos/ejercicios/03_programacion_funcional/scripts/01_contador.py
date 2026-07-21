class Contador:
    def __init__(self, valor_inicial=0):
        self._inicial = valor_inicial   # se guarda para poder reiniciar
        self._valor = valor_inicial     # estado actual del contador

    def incrementar(self, paso=1):
        self._valor += paso
        return self._valor

    def decrementar(self, paso=1):
        self._valor -= paso
        return self._valor

    def valor(self):
        return self._valor

    def reiniciar(self):
        self._valor = self._inicial
        return self._valor

    def __str__(self):
        return f"Contador(valor={self._valor})"


c = Contador()
c.incrementar(5)    # 5
c.decrementar(2)    # 3
c.reiniciar()
print(c.valor())

