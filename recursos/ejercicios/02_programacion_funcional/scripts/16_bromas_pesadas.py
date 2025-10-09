def romper_cada(n):
	def decorador(func):

		if type(n) is not int or n < 1: # Chequea que "n" sea un argumento válido
			return func

		contador = 0  # Cuántas veces se llamó a la función

		def envoltura(*args, **kwargs):
			nonlocal contador
			contador += 1

			if contador % n == 0: # Cada n veces...
				return None       # ...se rompe

			return func(*args, **kwargs)

		return envoltura
	return decorador

# Ejemplo de uso
@romper_cada(3)
def saludar(nombre):
	print(f"¡Hola, {nombre}!")

saludar("Carlos")     # "¡Hola, Carlos!"
saludar("María Luz")  # "¡Hola, María Luz!"
saludar("Mirna")      # Nada (la función devuelve None)
saludar("Diego")      # "¡Hola, Diego!"
