"""Implementación de los ejemplos del apunte de árboles."""

class Nodo:
    def __init__(self, valor):
        self.valor = valor
        self.izquierdo = None
        self.derecho = None


def buscar(raiz, valor):
    actual = raiz
    while actual is not None:

        # Si el valor buscado coincide con el del nodo, lo encontramos
        if valor == actual.valor:
            return actual

        if valor < actual.valor:
            # Si el valor buscado es menor, seguimos por el hijo izquierdo
            actual = actual.izquierdo
        else:
            # Si el valor buscado es mayor, seguimos por el hijo derecho
            actual = actual.derecho

    # Llegamos a una referencia vacía sin encontrar el valor
    return None


def insertar(raiz, valor):
    # Si llegamos a una referencia vacía, creamos el nuevo nodo
    if raiz is None:
        return Nodo(valor)

    if valor < raiz.valor:
        # Si el valor es menor, insertamos en el subárbol izquierdo
        raiz.izquierdo = insertar(raiz.izquierdo, valor)
    elif valor > raiz.valor:
        # Si el valor es mayor, insertamos en el subárbol derecho
        raiz.derecho = insertar(raiz.derecho, valor)

    # Devolvemos la raíz del subárbol para que la llamada anterior guarde el enlace
    # Si el valor ya existía, no agregamos otro nodo
    return raiz


def eliminar(raiz, valor):
    # Si llegamos a una referencia vacía, el valor no está en el árbol
    if raiz is None:
        return None

    if valor < raiz.valor:
        # Si el valor es menor, lo buscamos en el subárbol izquierdo
        raiz.izquierdo = eliminar(raiz.izquierdo, valor)
    elif valor > raiz.valor:
        # Si el valor es mayor, lo buscamos en el subárbol derecho
        raiz.derecho = eliminar(raiz.derecho, valor)
    else:
        # Encontramos el valor. Si es una hoja, quitamos el enlace
        if raiz.izquierdo is None and raiz.derecho is None:
            return None

        # Si tiene un solo hijo, ese hijo ocupa su lugar
        if raiz.izquierdo is None:
            return raiz.derecho
        if raiz.derecho is None:
            return raiz.izquierdo

        # Si tiene dos hijos, buscamos el menor valor del subárbol derecho
        sucesor = raiz.derecho
        while sucesor.izquierdo is not None:
            sucesor = sucesor.izquierdo

        # Copiamos el valor y quitamos el sucesor de su posición original
        raiz.valor = sucesor.valor
        raiz.derecho = eliminar(raiz.derecho, sucesor.valor)

    # Devolvemos la raíz del subárbol, con los cambios realizados
    return raiz


def preorden(nodo):
    # Un subárbol vacío no aporta valores
    if nodo is None:
        return []

    # Nodo actual, subárbol izquierdo y subárbol derecho
    return [nodo.valor] + preorden(nodo.izquierdo) + preorden(nodo.derecho)


def inorden(nodo):
    # Un subárbol vacío no aporta valores
    if nodo is None:
        return []

    # Subárbol izquierdo, nodo actual y subárbol derecho
    return inorden(nodo.izquierdo) + [nodo.valor] + inorden(nodo.derecho)


def postorden(nodo):
    # Un subárbol vacío no aporta valores
    if nodo is None:
        return []

    # Subárbol izquierdo, subárbol derecho y nodo actual
    return postorden(nodo.izquierdo) + postorden(nodo.derecho) + [nodo.valor]
