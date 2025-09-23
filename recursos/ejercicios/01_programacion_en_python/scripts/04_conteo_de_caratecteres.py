# Conteo de caracteres
def contar_caracteres(texto):
    caracteres = {}
    for caracter  in texto:
        # No considerar espacios
        if caracter == " ":
            continue

        # Pasar el caracter a minuscula
        caracter_minuscula = caracter.lower()
        if caracter_minuscula not in caracteres:
            caracteres[caracter_minuscula] = 1
        else:
            caracteres[caracter_minuscula] += 1

    return caracteres

contar_caracteres("Ahora es mejor que nunca")

# Comentarios:
# 1. Implementacion usando 'in' vs 'not in'
# 2. ¿Podrían meter el .lower en otro lado? Si, se podría pasar el texto a minúsculas antes de empezar a iterar.
# 3. ¿En cuál implementación se realizaría menos trabajo?
# 4. ¿Podriamos eliminar el `continue`?

# Moraleja: no hay una única implementación correcta.