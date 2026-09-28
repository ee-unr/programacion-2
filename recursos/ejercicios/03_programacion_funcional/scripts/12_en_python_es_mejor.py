numeros = [
    4.74346239e-01, -2.90877176e-01, -1.44377789e+00, -4.48680759e+01,
    -1.21249801e+00, -3.32729317e-01,  2.21676912e-01,  1.05599711e+00,
    -3.62372053e+00, -2.96441579e-01, -4.28304222e+00,  1.55908820e+02,
    9.00858234e-01, -1.09384173e+00, -1.51083571e+00, -5.38491167e-01,
    -3.84153084e-02,  1.20393395e+00,  1.82651406e-01,  2.05179405e+00
]

def media(x):
    return sum(x) / len(x)

def varianza(x):
    numerador = 0
    x_media = media(x)
    for x_i in x:
        numerador += (x_i - x_media) ** 2
    return numerador / len(x)

x_media = media(numeros)
x_desvio = varianza(numeros) ** 0.5

map_obj = map(lambda x: (x - x_media) / x_desvio, numeros)
list(filter(lambda x: abs(x) > 3, map_obj))

# Respuesta 1: si queremos el numero transformado
[(x - x_media) / x_desvio for x in numeros if abs((x - x_media) / x_desvio) > 3]

# Respuesta 2: si queremos el numero original
[x for x in numeros if abs((x - x_media) / x_desvio) > 3]

