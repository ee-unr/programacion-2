altura_inicial = 100 # metros
rebote = 3 / 5

# Parte 1 (no es necesario el uso de una variable adicional)
altura_actual = altura_inicial
for i in range(10):
    altura_actual = altura_actual * rebote
    print("Rebote", i + 1, "| Altura:", round(altura_actual, 4))

# Parte 2
def calcular_rebotes(altura_inicial, rebotes_n):
    alturas = []
    altura_actual = altura_inicial
    for _ in range(rebotes_n): # '_' es una convencion cuando la variable de iteración no se usa
        altura_actual = altura_actual * rebote
        alturas.append(altura_actual)

    return alturas

calcular_rebotes(100, 10)


# Parte 3
def calcular_rebotes(altura_inicial, rebotes_n):
    alturas = []
    altura_actual = altura_inicial
    for _ in range(rebotes_n): # '_' es una convencion cuando la variable de iteración no se usa
        altura_actual = altura_actual * rebote
        alturas.append(altura_actual)

        if altura_actual < 0.01:
            break

    return alturas

calcular_rebotes(100, 50)
len(calcular_rebotes(100, 50)) # Solo devuelve 19 rebotes

# Se podria conversar si es necesario crear 'altura_actual'
# Para el caso de las listas una opción, un poco más rebuscada, es:

def calcular_rebotes(altura_inicial, rebotes_n):
    alturas = [altura_inicial * rebote]
    for i in range(rebotes_n):
        alturas.append(alturas[i] * rebote)

        if alturas[-1] < 0.01:
            break

    return alturas

calcular_rebotes(100, 50)
len(calcular_rebotes(100, 50)) # Solo devuelve 19 rebotes
