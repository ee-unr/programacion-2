def media(x):
    """Calcula la media de los numeros en una lista."""
    if x:
        return sum(x) / len(x)

def filtrar_cadenas(lista):
    """Conserva los elementos de una lista que son de tipo 'str'"""
    salida = []
    for elemento in lista:
        # 'isinstance()' sirve para preguntar si un elemento es de un tipo determinado
        # en este caso, isinstance(elemento, str) pregunta si 'elemento' es de tipo 'str'.
        if isinstance(elemento, str):
            salida.append(elemento)
    return salida