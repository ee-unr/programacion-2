def promo_dia_semana(compra):
  """Aplica un 15% de descuento si la compra se realiza un lunes o miércoles."""
  if compra["dia"] in ("lunes", "miércoles"):
    return 0.85
  return 1

def promo_monto_grande(compra):
  """Aplica un 10% de descuento si la compra tiene un monto superior a $50.000."""
  if compra["monto"] > 50_000:
    return 0.9
  return 1

def promo_edad(compra):
  """Aplica un 20% de descuento si el cliente tiene 65 años o más."""
  if compra["edad_cliente"] >= 65:
    return 0.8
  return 1

promos = [promo_dia_semana, promo_monto_grande, promo_edad]

def mejor_promo(compra):
  """Ordena los descuentos de mayor a menor y aplica el mejor disponible."""
  multiplicador = sorted([promo(compra) for promo in promos])[0]

  return {
    "monto_original": compra["monto"],
    "monto_final": compra["monto"] * multiplicador,
    "descuento": f"{round((1 - multiplicador) * 100)}%"
  }

ejemplo_compra = {"dia": "miércoles", "edad_cliente": 42, "monto": 66420}
mejor_promo(ejemplo_compra)

# Solucion (no se si esto es lo que Joaco tenia en mente)
PROMOS = [] # mayusculas para indicar que es global, una convencion
def promo(fun):
    def envoltura(*args, **kwargs):
        return fun(*args, **kwargs)
    PROMOS.append(envoltura)
    return envoltura

@promo
def promo_dia_semana(compra):
    if compra["dia"] in ("lunes", "miércoles"):
        return 0.85
    return 1

@promo
def promo_monto_grande(compra):
    if compra["monto"] > 50_000:
        return 0.9
    return 1

@promo
def promo_edad(compra):
    if compra["edad_cliente"] >= 65:
        return 0.8
    return 1

PROMOS # ahora contiene a las funciones

def mejor_promo(compra):
    multiplicador = sorted([promo(compra) for promo in PROMOS])[0]
    return {
        "monto_original": compra["monto"],
        "monto_final": compra["monto"] * multiplicador,
        "descuento": f"{round((1 - multiplicador) * 100)}%"
    }

ejemplo_compra = {"dia": "miércoles", "edad_cliente": 42, "monto": 66420}
mejor_promo(ejemplo_compra)

ejemplo_compra = {"dia": "jueves", "edad_cliente": 42, "monto": 28000}
mejor_promo(ejemplo_compra)

ejemplo_compra = {"dia": "jueves", "edad_cliente": 67, "monto": 28000}
mejor_promo(ejemplo_compra)
