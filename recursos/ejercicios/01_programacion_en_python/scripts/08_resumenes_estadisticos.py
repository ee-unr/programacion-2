def media(x):
    return sum(x) / len(x)


def rango(x):
    return max(x) - min(x)


# Opcion 1.
def varianza(x):
    x_media = media(x)
    suma = 0
    for x_i in x:
        suma += (x_i - x_media) ** 2
    return suma / len(x)


# Opcion 2. Se podría usar un list-comprehension también.
def varianza2(x):
    x_media = media(x)
    distancias = []
    for x_i in x:
        distancias.append((x_i - x_media) ** 2)
    return media(distancias)

def desvio_estandar(x):
    return varianza(x) ** 0.5


def mediana(x):
    x_ordenado = sorted(x)
    n = len(x)
    mitad = n // 2

    if n % 2 == 1:
        # Cantidad impar: se toma el elemento del medio
        mediana = x_ordenado[mitad]
    else:
        # Cantidad par: se promedian los dos del medio
        mediana = (x_ordenado[   - 1] + x_ordenado[mitad]) * 0.5

    return mediana