import random

def cajita_musical(versos):
    versos = versos[:] # Para hacer una copia

    while versos: # Mientras la lista no esté vacía
        # Generar un índice al azar
        i = random.randint(0, len(versos) - 1)

        # Sacar y devolver el valor del índice al azar
        yield versos.pop(i)


versos = [
    "Tengo que confesar que a veces no me gusta tu forma de ser",
    "Luego te me desapareces y no entiendo muy bien por qué",

    "No dices nada romántico cuando llega el atardecer",
    "Te pones de un humor extraño con cada luna llena al mes",

    "Pero a todo lo demás le gana lo bueno que me das",
    "Sólo tenerte cerca, siento que vuelvo a empezar"
]

for verso in cajita_musical(versos):
    print(verso)