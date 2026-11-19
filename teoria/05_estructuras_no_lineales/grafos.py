"""Ejemplos del apunte de grafos: red no dirigida y sin pesos."""

def agregar_vertice(grafo, vertice):
    # Un vértice nuevo empieza sin vecinos
    if vertice not in grafo:
        grafo[vertice] = []


def agregar_arista(grafo, origen, destino):
    # Los dos vértices deben existir. Guardamos la conexión en ambos sentidos
    if destino not in grafo[origen]:
        grafo[origen].append(destino)
    if origen not in grafo[destino]:
        grafo[destino].append(origen)


def quitar_arista(grafo, origen, destino):
    # Quitamos las dos referencias de una conexión no dirigida
    if destino in grafo[origen]:
        grafo[origen].remove(destino)
    if origen in grafo[destino]:
        grafo[destino].remove(origen)


def quitar_vertice(grafo, vertice):
    # Antes de borrar la clave, lo quitamos de las listas de sus vecinos
    for vecino in grafo[vertice]:
        grafo[vecino].remove(vertice)
    del grafo[vertice]


def dfs(grafo, origen):
    visitados = set()
    orden = []

    def visitar(actual):
        # Registramos el vértice antes de seguir sus conexiones
        visitados.add(actual)
        orden.append(actual)

        for vecino in grafo[actual]:
            if vecino not in visitados:
                visitar(vecino)

    visitar(origen)
    return orden


def bfs(grafo, origen):
    # Registramos cada vértice al agregarlo a la cola
    visitados = {origen}
    cola = [origen]
    siguiente = 0
    orden = []

    while siguiente < len(cola):
        actual = cola[siguiente]
        siguiente += 1
        orden.append(actual)

        for vecino in grafo[actual]:
            if vecino not in visitados:
                visitados.add(vecino)
                cola.append(vecino)

    return orden


def crear_red():
    """Devuelve una copia nueva de la selección de seis ciudades del apunte."""
    return {
        "Rosario": ["Salta", "San Pablo"],
        "Salta": ["Rosario", "Córdoba", "Mendoza"],
        "Córdoba": ["Salta", "Mendoza", "San Pablo"],
        "Mendoza": ["Salta", "Córdoba", "San Pablo"],
        "San Pablo": ["Rosario", "Córdoba", "Mendoza", "Ushuaia"],
        "Ushuaia": ["San Pablo"],
    }


if __name__ == "__main__":
    grafo = crear_red()
    print("DFS:", dfs(grafo, "Rosario"))
    print("BFS:", bfs(grafo, "Rosario"))
    print("¿Mendoza es alcanzable?", "Mendoza" in bfs(grafo, "Rosario"))
