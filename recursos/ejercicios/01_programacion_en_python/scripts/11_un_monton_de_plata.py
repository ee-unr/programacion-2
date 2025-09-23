billete_grosor = 0.11 * 0.001  # grosor de un billete en metros
altura_monumento = 70          # altura en metros

dias = 1
billetes_n = 1
while billetes_n * billete_grosor <= altura_monumento:
    billetes_n = billetes_n * 2
    dias = dias + 1

print("Se necesitan", dias, "dias.")
print("La altura de la pila es", billetes_n * billete_grosor, "metros.")
print("Se colocaron", billetes_n, "billetes.")


# Punto extra
def calcular_dias(altura_objetivo):
    billete_grosor = 0.11 * 0.001
    dias = 1
    billetes_n = 1
    while billetes_n * billete_grosor <= altura_objetivo:
        billetes_n = billetes_n * 2
        dias = dias + 1
    return dias

calcular_dias(0.1)
