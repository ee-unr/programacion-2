# Parte 2
def palindromo(x):
    if len(x) < 2:
        return True

    if x[0] == x[-1]:
        return palindromo(x[1:-1])

    return False

palindromo("hola amigo")
palindromo("somos")
palindromo("anilina")
palindromo("menem")
palindromo("neuquen")



# Parte 2
def _palindromo(x):
    # Identica a la anterior, pero ahora es una funcion interna
    if len(x) < 2:
        return True

    if x[0] == x[-1]:
        return palindromo(x[1:-1])

    return False

def palindromo(x):
    return _palindromo(x.lower().replace(" ", ""))

palindromo("Anita lava la tina")
palindromo("Luz azul")
palindromo("Cualquier cosa")
