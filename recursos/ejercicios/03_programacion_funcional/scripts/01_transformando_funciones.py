# 1
# * Usa variable global
# * Modifica variable global
# * El resultado no depende de los valores de entrada

def incrementar(contador):
    return contador + 1


# 2
# * El resultado no depende de la entrada, sino del momento de la llamada.
# Se puede obtener una función similar, pero no exactamente igual.
import datetime

def hora(dt):
    return dt.hour

hora(datetime.datetime.now())

# 3
# Acá no estoy tan seguro, supongo que lo que es no puro no es `add_time``, sino que es
# `increment_time`. Yo (tomi) propondría

def add_time(time, hours, minutes, seconds):
    return time + datetime.timedelta(hours=hours, minutes=minutes, seconds=seconds)

add_time(datetime.datetime(2025, 8, 12), 2, 12, 44)

# 4
# Modifica objeto global
# Salida sí depende de la entrada, eso está OK.
# Una alternativa posible
def registar_nombre(listado, nombre):
    return listado + [nombre]

historial_de_nombres = []
historial_de_nombres = registar_nombre(historial_de_nombres, "Mateo")
historial_de_nombres = registar_nombre(historial_de_nombres, "Camila")
historial_de_nombres = registar_nombre(historial_de_nombres, "Victoria")
historial_de_nombres

# 5
# No es pura, no signific que sea mala per se.
# El problema es que su salida no depende de sus valores
# Si cambia una variable fuera de ella, cammbia el resultado.
# Una alternativa
def verificar_limite(valor, limite):
    if valor > limite:
        return "Excede el límite"
    return "Dentro del límite"

LIMITE_MAXIMO = 100
verificar_limite(88, LIMITE_MAXIMO)
