# Área y perímetro de un círculo
def calcular_area(radio):
    pi = 3.14159
    area = pi * radio ** 2
    return area

def calcular_perimetro(radio):
    pi = 3.14159
    perimetro = 2 * pi * radio
    return perimetro

def calcular_area_y_perimetro(radio):
    area = calcular_area(radio)
    perimetro = calcular_perimetro(radio)
    return area, perimetro

calcular_area(radio=2.5)
calcular_perimetro(radio=2.5)

area, perimetro = calcular_area_y_perimetro(radio=2.5)
resultados = calcular_area_y_perimetro(radio=2.5)

print(type(area))
print(type(perimetro))
print(type(resultados))
print(type(resultados[0]))
print(type(resultados[1]))