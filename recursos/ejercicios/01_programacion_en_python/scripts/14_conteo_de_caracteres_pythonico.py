def contar_caracteres(texto):
    texto = texto.lower() # Pasa a minuscula al principio
    caracteres = {}
    for caracter  in texto:
        # Solo considerar letras del alfabeto
        if not caracter.isalpha():
            continue

        # Si el caracter no esta en el diccionario, devuelve 0
        # Si está, devuelve su conteo.
        # En ambos casos, le suma 1.
        caracteres[caracter] = caracteres.get(caracter, 0) + 1

    return caracteres

contar_caracteres("Ahora es mejor que nunca")
contar_caracteres("Ahora es mejor que nunca!!   +_")
contar_caracteres("Ahora es mejor que nunca!!   +_") == contar_caracteres("Ahora es mejor que nunca")

