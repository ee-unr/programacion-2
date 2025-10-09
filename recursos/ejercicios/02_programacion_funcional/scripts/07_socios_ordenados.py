datos_socios = [
    {"nombre": "Bautista Carrara", "edad": 22, "altura_cm": 178, "record_100m": 13.4},
    {"nombre": "Valentina Lucci",  "edad": 23, "altura_cm": 163, "record_100m": 14.2},
    {"nombre": "Gerónimo Cuesta",  "edad": 26, "altura_cm": 170, "record_100m": 14.0},
    {"nombre": "Lucio Borga",      "edad": 28, "altura_cm": 186, "record_100m": 13.8},
    {"nombre": "Julia Spoglia",    "edad": 21, "altura_cm": 163, "record_100m": 11.9},
    {"nombre": "Soledad Colombo",  "edad": 22, "altura_cm": 170, "record_100m": 13.5}
]

sorted(datos_socios, key=lambda datum: datum["record_100m"])

# Punto extra
def ordenar_diccionario(data, key):
    if key == "nombre":
        return sorted(data, key=lambda datum: datum["nombre"].split(" ")[1])
    return sorted(data, key=lambda datum: datum[key])

ordenar_diccionario(datos_socios, "record_100m")
ordenar_diccionario(datos_socios, "edad")
ordenar_diccionario(datos_socios, "altura_cm")
ordenar_diccionario(datos_socios, "nombre")
