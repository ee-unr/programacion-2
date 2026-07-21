class Experimento:
    total_creados = 0  # atributo de clase compartido por **todas** las instancias

    def __init__(self, nombre, responsable=None):
        # Actualizamos el contador global y usamos ese valor como id
        Experimento.total_creados += 1
        self.id = Experimento.total_creados
        self.nombre = nombre
        self.responsable = responsable

    @classmethod
    def desde_dict(cls, datos):
        # crea experimento a partir de diccionario
        return cls(datos.get("nombre"), responsable=datos.get("responsable"))

    def __repr__(self):
        argumentos = (
            f"id={self.id}",
            f"nombre={self.nombre}",
            f"responsable={self.responsable}",
        )
        return f"Experimento({', '.join(argumentos)})"



e1 = Experimento("Piloto A", responsable="Dolores")
e2 = Experimento.desde_dict({"nombre": "Piloto B", "responsable": "Ana"})

print(Experimento.total_creados)  # 2
print(repr(e1))                   # Experimento(id=1, nombre='Piloto A', responsable='Dolores')
print(e2)                         # usa __repr__
