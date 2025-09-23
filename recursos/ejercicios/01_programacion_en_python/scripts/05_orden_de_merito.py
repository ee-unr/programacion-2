# Orden de mérito
notas = [
    ("Escalada", 9),
    ("Alonso", 7),
    ("Pérez", 8),
    ("Castro", 8),
    ("Rossini", 10),
    ("Martínez", 9),
    ("Pérez", 6),
    ("Riquelme", 5),
]

# Parte 1
notas_dict = {}
for registro in notas:
    # Opcion 1:
     notas_dict[registro[0]] = registro[1]

    # Opcion 2:
    # apellido = registro[0]
    # nota = registro[1]
    # notas_dict[apellido] = nota

    # apellido, nota = registro
    # notas_dict[apellido] = nota

# Pregunta: ¿Que pasa si hay dos personas con el mismo apellido?

# Parte 2
notas_dict = {}
for registro in notas:
    apellido = registro[0]
    nota = registro[1]
    if nota not in notas_dict:
        notas_dict[nota] = [apellido]
    else:
        notas_dict[nota].append(apellido)
        # Otras opciones:
        # notas_dict[nota] = notas_dict[nota] + [apellido]
        # notas_dict[nota] = notas_dict[nota].extend([apellido])