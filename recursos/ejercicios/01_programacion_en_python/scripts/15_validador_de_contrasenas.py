CARACTERES_ESPECIALES = "@#$%^&*()"

def contiene_letra(texto):
    # True si al menos un caracter es una letra
    for caracter in texto:
        if caracter.isalpha():
            return True
    return False


def contiene_numero(texto):
    # True si al menos un caracter es un numero (del sistema decimal)
    for caracter in texto:
        if caracter.isdecimal():
            return True
    return False


def contiene_especial(texto):
    # True si al menos un caracter es un numero
    for caracter in texto:
        if caracter in CARACTERES_ESPECIALES:
            return True
    return False

def validar_pwd(pwd):
    errores = []

    if not (8 <= len(pwd) <= 24):
        errores.append("Debe tener entre 8 y 24 caracteres.")

    if not contiene_letra(pwd):
        errores.append("Debe contener al menos una letra.")
    if not contiene_numero(pwd):
        errores.append("Debe contener al menos un número.")
    if not contiene_especial(pwd):
        errores.append("Debe contener al menos un carácter especial '@#$%^&*()'.")

    caracteres_desconocidos = []
    for caracter in pwd:
        # Hablar sobre si es posible simplificar esto
        if (not caracter.isdecimal()) and (not caracter.isalpha()) and (caracter not in CARACTERES_ESPECIALES):
            caracteres_desconocidos.append(caracter)

    # Equivale a len(caracteres_desconocidos) > 0
    if caracteres_desconocidos:
        errores.append(
            f"La contraseña contiene los siguientes caracteres desconocidos {caracteres_desconocidos}"
        )

    if errores == []:
        return True

    return errores


while True:
    password = input("Ingrese una contraseña (o ENTER para salir): ")
    if password == "":
        print("Operación cancelada.")
        break

    resultado = validar_pwd(password)

    # Acá NO se puede usar 'if es_valida'.
    if resultado is True:
        print("Contraseña válida.")
        break

    print("La contraseña no es válida:")
    for error in resultado:
        print("-", error)
