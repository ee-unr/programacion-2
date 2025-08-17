import random

print(" ======================== Adivina el número! ======================== ")

numero_secreto = random.randint(0, 100)

mensaje = "Ingresa un numero entero: "
conteo = 0
while True:
    numero = int(input(mensaje))
    conteo += 1
    if numero < numero_secreto:
        mensaje = f"Ups! El numero secreto es mayor a {numero}. Prueba de nuevo: "
    elif numero > numero_secreto:
        mensaje = f"Ups! El numero secreto es menor a {numero}. Prueba de nuevo: "
    else:
        print(f"Has ganado, felicitaciones! Te llevó tan solo {conteo} intentos.")
        break
