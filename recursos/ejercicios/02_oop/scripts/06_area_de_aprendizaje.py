rectangulos = [
    (5, 8),
    (2, 2),
    (9, 2),
    (3, 3),
    (3, 7),
    (6, 3)
]

sorted(rectangulos, key=lambda r: r[0] *  r[1])

# Cuidado que esto funciona, pero hace otra cosa
sorted(rectangulos)
