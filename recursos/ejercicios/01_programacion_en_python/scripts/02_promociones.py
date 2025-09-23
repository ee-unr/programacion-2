# Promociones
def calcular_precio(monto, medio):
    if medio == "efectivo":
        monto_final = monto
    elif medio == "débito":
        monto_final = monto * (1 - 0.1)
    elif medio == "crédito":
        monto_final = monto * (1 + 0.05)
    else:
        print(f"El medio {medio} es desconocido.")
        monto_final = monto

    return monto_final

calcular_precio(80, "efectivo")
calcular_precio(80, "débito")
calcular_precio(80, "crédito")

# Extra:
# Usando valor por defecto 'efectivo'
def calcular_precio(monto, medio="efectivo"):
    if medio == "efectivo":
        monto_final = monto
    elif medio == "débito":
        monto_final = monto * (1 - 0.1)
    elif medio == "crédito":
        monto_final = monto * (1 + 0.05)
    else:
        print(f"El medio {medio} es desconocido.")
        monto_final = monto

    return monto_final

# Usando valor por defecto None
def calcular_precio(monto, medio=None):
    if medio is None:
        medio = "efectivo"

    if medio == "efectivo":
        monto_final = monto
    elif medio == "débito":
        monto_final = monto * (1 - 0.1)
    elif medio == "crédito":
        monto_final = monto * (1 + 0.05)
    else:
        print(f"El medio {medio} es desconocido.")
        monto_final = monto

    return monto_final