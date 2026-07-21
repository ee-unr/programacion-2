temperaturas_celsius = [
    25.5, 28.0, 19.3, 31.5, 22.8, 17.0, 30.2, 35.6, 14.2,
    32.4, 22.7, 10.1, 29.5, 33.9, 22.1, 38.9, 18.4, 16.3
]

# Enfoque funcional
# 1
temperaturas_f = list(map(lambda c: c * 9 / 5 + 32, temperaturas_celsius))

# 2
# Opcion A:
list(filter(lambda f: f > 80, temperaturas_f))

# Opcion B --> las devuelve en grados celsius
list(filter(lambda c: (c * 9 / 5 + 32) > 80, temperaturas_celsius))

# Enfoque idiomático
[
    c * 9 / 5 + 32 for c in temperaturas_celsius if c > 22
]
