import random

class Sensor:
    def __init__(self, nombre):
        self.nombre = nombre
        self._offset = 0.0  # por defecto, sin corrección

    def calibrar(self, offset):
        self._offset = float(offset)

    def leer(self):
        raise NotImplementedError("Esta clase no implementa 'leer'. Use una subclase.")


class SensorTemperatura(Sensor):
    # simula un sensor de temperatura (°C)
    def leer(self):
        base = random.uniform(18, 28)    # simulación de medición
        return base + self._offset       # corrección por calibración


class SensorHumedad(Sensor):
    # Simula un sensor de humedad (%)
    def leer(self):
        base = random.uniform(30, 70)    # simulación de medición
        return base + self._offset       # corrección por calibración


def promedio_lecturas(sensores, n=5):
    """
    Toma n lecturas de cada sensor y devuelve un dict {nombre: promedio}.
    Funciona con cualquier subclase de Sensor que implemente 'leer' (polimorfismo).
    """

    if n <= 0:
        print("n debe ser un entero positivo (>= 1).")

    resultados = {}

    # para cada sensor
    for sensor in sensores:
        # n lecturas por sensor
        acumulado = 0
        for _ in range(n):
            acumulado += sensor.leer() # sumamos los resultados de las lecturas
        resultados[sensor.nombre] = acumulado / n
    return resultados


# --- Ejemplo de uso ---
if __name__ == "__main__":
    random.seed(0)  # reproducibilidad

    t = SensorTemperatura("T1")
    h = SensorHumedad("H1")

    t.calibrar(0.5)

    promedios = promedio_lecturas([t, h], n=3)
    print(promedios)
