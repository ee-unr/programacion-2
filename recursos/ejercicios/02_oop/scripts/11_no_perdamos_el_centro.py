numeros = [
    2.05, 1.09, None, 2.31, 2.28, 0.97, 2.59, 2.72, 0.76, None, 1.88, 2.04, 3.25, 1.88, None
]

numeros_no_nulos = [n for n in numeros if n is not None]
media = sum(numeros_no_nulos) / len(numeros_no_nulos)

[n - media for n in numeros if n is not None]