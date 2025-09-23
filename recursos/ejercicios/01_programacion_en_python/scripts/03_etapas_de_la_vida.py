# Etapas de la vida
def obtener_etapa(edad):
    if edad < 2:
        etapa = "bebé"
    elif edad < 4:
        etapa = "infante"
    elif edad < 13:
        etapa = "niño/a"
    elif edad < 20:
        etapa = "adolescente"
    elif edad < 65:
        etapa = "adulto/a"
    else:
        etapa = "persona mayor"

    mensaje = f"La persona es un/a {etapa}"
    print(mensaje)

    return None

obtener_etapa(67)

# Comentarios:
# 1. Un posible problema con esta implementación es que asume que la edad es positiva.
#    También admite edades irrealmente altas.

