# Parte 1:
def crear_promocion(medio):
    if medio == "efectivo":
        multiplicador = 1
    elif medio == "débito":
        multiplicador = (1 - 0.1)
    elif medio == "crédito":
        multiplicador = (1 + 0.05)
    else:
        print(f"El medio {medio} es desconocido.")
        multiplicador = 1

    def f(x):
        return x * multiplicador

    return f

promo_debito = crear_promocion("débito")
print(promo_debito(1000))
print(promo_debito(2700))


# Parte 2
def crear_promocion_personalizada(medio, descuento=None):
    if descuento is None:
        if medio == "efectivo":
            multiplicador = 1
        elif medio == "débito":
            multiplicador = (1 - 0.1)
        elif medio == "crédito":
            multiplicador = (1 + 0.05)
        else:
            print(f"El medio {medio} es desconocido.")
            multiplicador = 1
    else:
        multiplicador = 1 - descuento / 100

    def f(x):
        return x * multiplicador

    return f

promo_debito = crear_promocion_personalizada("débito", 15)
promo_debito(1000)

promo_debito = crear_promocion_personalizada("débito")
promo_debito(1000)
