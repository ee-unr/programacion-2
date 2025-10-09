from math import log10

# Sin usar filter

def eliminar_nulos(datos):
	datos_sin_nulos = []
	for fila in datos:
		if None not in fila.values():
			datos_sin_nulos.append(fila.copy())
	return datos_sin_nulos

def calcular_log(datos, variable):
	datos_log = []
	for fila in datos:
		copia_fila = fila.copy()
		valor = copia_fila[variable]
		copia_fila[variable] = round(log10(valor), 3) if (valor is not None) else None
		datos_log.append(copia_fila)
	return datos_log

def filtrar(datos, variable, funcion):
	datos_filtrados = []
	for fila in datos:
		if fila[variable] is not None and funcion(fila[variable]):
			datos_filtrados.append(fila.copy())
	return datos_filtrados


# Usando filter

def eliminar_nulos(datos):
	return list(filter(lambda fila: None not in fila.values(), datos))

def filtrar(datos, variable, funcion):
	return list(filter(lambda fila: fila[variable] is not None and funcion(fila[variable]), datos))

