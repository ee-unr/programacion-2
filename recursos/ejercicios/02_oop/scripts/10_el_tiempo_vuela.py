import time

def crear_cronometro():
    t_creacion = time.time()
    def fun():
        t_ejecucion = time.time()
        return t_ejecucion - t_creacion
    return fun

cronometro1 = crear_cronometro()

for i in range(10**4):
    i ** 2 # Calcula el cuadrado de un número pero no lo devuelve

print(f"El bloque entero tardó {cronometro1()} segundos en ejecutarse.")


cronometro2 = crear_cronometro()

for j in range(10**6):
    j // 2 # Calcula la división entera por 2 pero no la devuelve

print(f"El segundo bucle tardó {cronometro2()} segundos en ejecutarse.")

# Punto extra: ¿cache?
def crear_cronometro():
    t_creacion = time.time()
    tiempos = [t_creacion]
    def fun():
        t_ejecucion = time.time()
        t_anterior = tiempos[-1]
        tiempos.append(t_ejecucion)
        return t_ejecucion - t_anterior
    return fun

g = crear_cronometro()

g()
g()
g()
