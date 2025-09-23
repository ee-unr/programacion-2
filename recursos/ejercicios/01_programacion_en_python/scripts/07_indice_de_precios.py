ipc_2024 = [20.6, 13.2, 11.0, 8.8, 4.2, 4.6, 4.0, 4.2, 3.5, 2.7, 2.4, 2.7]

# Menor y mayor valor
min(ipc_2024)
max(ipc_2024)

# IPC promedio mensual
sum(ipc_2024) / len(ipc_2024)

# Mes de mayor inflación
ipc_2024.index(max(ipc_2024)) # 0 + 1 -> enero

# Inflación mediana
ipc_ordenado = sorted(ipc_2024)

# Opcion 1:
(ipc_ordenado[5] + ipc_ordenado[6]) * 0.5

# Opcion 2:
sum(ipc_ordenado[5:7]) * 0.5

# Opcion 3:
n_inicio = (len(ipc_ordenado) // 2) - 1 # Resto 1 porque Python indexa desde 0
n_fin = (len(ipc_ordenado) // 2 + 1) -1   # Resto 1 porque Python indexa desde 0

# Sumo 1 porque el slicing no es inclusivo por derecha
sum(ipc_ordenado[n_inicio:(n_fin + 1)]) * 0.5

# Rango de IPC sin min y max
ipc_ordenado[-1] - ipc_ordenado[0]
