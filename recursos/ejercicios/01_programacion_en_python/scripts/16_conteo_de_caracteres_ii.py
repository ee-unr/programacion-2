def contar_caracteres(texto, orden="aparicion"):
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

    if orden == "aparicion":
        salida = caracteres
    elif orden == "alfabetico":
        salida = {}
        claves = sorted(caracteres.keys()) # No hace falta el .keys() en realidad
        for clave in claves:
            salida[clave] = caracteres[clave]
    elif orden == "frecuencia":
        salida = {}
        claves = list(caracteres.keys()) # No hace falta el .keys() en realidad
        claves_ordenadas = sorted(claves, key=lambda k: caracteres[k], reverse=True)
        for clave in claves_ordenadas:
            salida[clave] = caracteres[clave]

    return salida

contar_caracteres("Ahora es mejor que nunca", "aparicion")
contar_caracteres("Ahora es mejor que nunca", "alfabetico")
contar_caracteres("Ahora es mejor que nunca", "frecuencia")


