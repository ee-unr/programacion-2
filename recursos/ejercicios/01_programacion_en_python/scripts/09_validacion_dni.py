def validar_dni(dni):
    # Si no 'dni' tiene puntos, es DNI válido cuando:
    # - todos los caracteres sean todos dígitos
    # - la longitud esté entre 7 y 8
    if dni.count(".") == 0:
        return dni.isdigit() and 7 <= len(dni) <= 8

    # Si 'dni' tiene puntos, debe tener exactamente 2 puntos.
    partes = dni.split(".")
    if len(partes) != 3:
        return False

    # Si alguna de las partes no contiene todos dígitos, no es un DNI válido.
    # Opcion 1
    for parte in partes:
        if not parte.isdigit():
            return False
    # Opcion 2
    # if not all(parte.isdigit() for parte in partes):
    #     return False

    longitudes_validas = (
        len(partes[0]) in (1, 2) and
        len(partes[1]) == 3 and
        len(partes[2]) == 3
    )

    return longitudes_validas


validar_dni("40.094.127")
validar_dni("19053512")
validar_dni("6.392.780")

validar_dni("40,094,127")
validar_dni("19-053-512")
validar_dni("123456")
validar_dni("40..094127")
validar_dni("40.09412.7")
