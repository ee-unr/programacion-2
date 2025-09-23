# Rendimento académico
notas = {
    "Ana": [8, 9, 10],
    "Luis": [6, 7, 8, 3, 9],
    "Carla": [10, 9, 10],
    "Marcos": [5, 6],
    "Sofía": [7, 7, 8],
    "Pedro": [6, 4, 5, 6, 3, 8],
    "Lucía": [9, 8, 10, 9]
}

def resumir_notas(datos, modo):
    resultado = {}

    if modo == "promedio":
        for nombre, notas in datos.items():
            resultado[nombre] = sum(notas) / len(notas)
    elif modo == "proporcion":
        # NOTE: Esto tal vez sea un poco complicado
        for nombre, notas in datos.items():
            n_aprobado = 0
            for nota in notas:
                if nota >= 6:
                    n_aprobado += 1
            resultado[nombre] = n_aprobado / len(notas)

    else:
        print(f"El modo {modo} es desconocido")
        return None

    return resultado

resumir_notas(notas, "promedio")
resumir_notas(notas, "proporcion")

# ¿Cómo sería la implementación sin .items()?
# ¿Podría escribir un único for loop? ¿Qué cambiaría? ¿Pros y contras?
# ¿Hay algún conflicto entre la variable 'notas' del ambiente global y la del ambiente local de
# la función?
# El cálculo de la proporción se podría abstraer en una función.

# Podría usarse un "list comprehension"
# len([nota for nota in notas if nota >= 6])

# Podría usarse un generador:
# sum(nota >= 6 for nota in notas)
