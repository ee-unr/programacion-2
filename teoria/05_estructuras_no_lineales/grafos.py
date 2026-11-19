"""Ejemplos del apunte de grafos: vértices conectados por referencias."""

from collections import deque


class Vertice:
    def __init__(self, valor):
        self.valor = valor
        self.vecinos = []

    def conectar(self, otro):
        # La conexión se guarda en ambos sentidos
        if otro not in self.vecinos:
            self.vecinos.append(otro)
            otro.vecinos.append(self)

    def desconectar(self, otro):
        if otro in self.vecinos:
            self.vecinos.remove(otro)
            otro.vecinos.remove(self)

    def aislar(self):
        # Copiamos la lista porque desconectar modifica los vecinos
        for vecino in self.vecinos.copy():
            self.desconectar(vecino)


def dfs(origen):
    visitados = set()
    orden = []

    def visitar(actual):
        # Registramos el vértice antes de seguir sus conexiones
        visitados.add(actual)
        orden.append(actual)

        for vecino in actual.vecinos:
            if vecino not in visitados:
                visitar(vecino)

    visitar(origen)
    return orden


def bfs(origen):
    # Registramos cada vértice al agregarlo a la cola
    visitados = {origen}
    cola = deque([origen])
    orden = []

    while cola:
        actual = cola.popleft()
        orden.append(actual)

        for vecino in actual.vecinos:
            if vecino not in visitados:
                visitados.add(vecino)
                cola.append(vecino)

    return orden


def hay_camino(origen, destino):
    visitados = set()

    def visitar(actual):
        if actual is destino:
            return True

        visitados.add(actual)
        for vecino in actual.vecinos:
            if vecino not in visitados:
                if visitar(vecino):
                    return True

        return False

    return visitar(origen)


def crear_red():
    """Crea la red y devuelve el vértice Rosario como punto de entrada."""
    rosario = Vertice("Rosario")
    salta = Vertice("Salta")
    cordoba = Vertice("Córdoba")
    mendoza = Vertice("Mendoza")
    san_pablo = Vertice("San Pablo")
    ushuaia = Vertice("Ushuaia")

    rosario.conectar(san_pablo)
    rosario.conectar(salta)
    san_pablo.conectar(ushuaia)
    salta.conectar(cordoba)
    salta.conectar(mendoza)
    cordoba.conectar(mendoza)
    cordoba.conectar(san_pablo)
    mendoza.conectar(san_pablo)
    return rosario


if __name__ == "__main__":
    rosario = crear_red()
    print("DFS:", [vertice.valor for vertice in dfs(rosario)])
    print("BFS:", [vertice.valor for vertice in bfs(rosario)])
    ushuaia = rosario.vecinos[0].vecinos[1]
    print("¿Ushuaia es alcanzable?", hay_camino(rosario, ushuaia))
