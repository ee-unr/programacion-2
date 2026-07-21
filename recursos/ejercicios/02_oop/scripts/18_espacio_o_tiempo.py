# 1 - PREPARACION DE DATOS

import random

CATEGORIAS = ("electrónica", "hogar", "accesorios", "deportes")

def generar_ventas(n=100_000, seed=None):
    rng = random.Random(seed)
    return [
        {
            "id": f"P{i+1:06d}",
            "precio": round(rng.uniform(5.0, 500.0), 2),
            "categoria": CATEGORIAS[i % len(CATEGORIAS)],
        }
        for i in range(1, n + 1)
    ]

ventas = generar_ventas(n=100_000, seed=1234)

# 2- Precios con IVA (21%)

# Versión A - List comprehension (ejecuta y guarda todo):
precios_con_iva_1 = [venta["precio"] * 1.21 for venta in ventas]
# Versión B - Generador (define la operación pero no la ejecuta):
precios_con_iva_2 = (venta["precio"] * 1.21 for venta in ventas)

# 3 - Filtrar ventas de electrónica

# Versión A - List comprehension:
electronica_1 = [venta for venta in ventas if venta["categoria"] == "electrónica"]
#Versión B - Generador:
electronica_2 = (venta for venta in ventas if venta["categoria"] == "electrónica")

# 4 - Análisis y comparación (tiempo y memoria)

import time
import sys

# A - Lista materializada
t1 = time.time()
total_1 = sum(venta["precio"] for venta in electronica_1)
t2 = time.time()
mem_1 = sys.getsizeof(electronica_1)
print(f"electronica_1 → total: {total_1:.2f}, tiempo: {t2 - t1:.4f}s, memoria: {mem_1} bytes")

# B - Generador (se consume al usar sum)
t3 = time.time()
total_2 = sum(venta["precio"] for venta in electronica_2)
t4 = time.time()
mem_2 = sys.getsizeof(electronica_2)
print(f"electronica_2 → total: {total_2:.2f}, tiempo: {t4 - t3:.4f}s, memoria: {mem_2} bytes")


# 5- Reutilización del objeto

# Lista: se puede usar de nuevo
print(sum(venta["precio"] for venta in electronica_1))  # OK

# Generador: ya fue consumido, no devuelve nada
print(sum(venta["precio"] for venta in electronica_2))  # 0.0

# 6 - Reflexión final (resumen corto)

# List comprehension (Versión A): usa más memoria, pero permite reutilizar los datos.
# Ideal si vas a recorrer los resultados varias veces.

# Generadores (Versión B): consumen poca memoria, pero solo pueden recorrerse una vez.
# Son más eficientes si solo necesitás un recorrido rápido.

# En problemas donde el dataset es enorme o se usa solo una vez → mejor un generador.
# Si necesitás acceder varias veces al resultado o compartirlo entre funciones → mejor una lista.