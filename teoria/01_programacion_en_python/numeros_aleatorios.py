import random

print(" ================= Inicio de ejecución del programa ================= ")

def main(cantidad):
    numeros_aleatorios = []
    for i in range(cantidad):
        numeros_aleatorios.append(round(random.random(), 4))
    maximo = max(numeros_aleatorios)
    minimo = min(numeros_aleatorios)

    return numeros_aleatorios, maximo, minimo

cantidad = int(input("Ingrese la cantidad de numeros a generar: "))
numeros, maximo, minimo = main(cantidad)

print("Se generaron los numeros aleatorios.")
print("Los numeros aleatorios son:")
print(numeros)
print("El valor mas bajo es:", minimo)
print("El valor mas alto es:", maximo)
print(" ========================= Fin del programa ========================= ")


