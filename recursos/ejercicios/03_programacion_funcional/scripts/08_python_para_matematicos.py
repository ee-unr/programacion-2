def mcd(a, b):
    # Puede ser math.gcd
    while b != 0:
        a, b = b, a % b
    return abs(a)


class Fraccion:
    def __init__(self, numerador, denominador):
        if denominador == 0:
            raise ValueError("El denominador no puede ser cero")
        self.numerador = numerador
        self.denominador = denominador
        self._simplificar()

    def _simplificar(self):
        divisor = mcd(self.numerador, self.denominador)
        self.numerador = self.numerador // divisor
        self.denominador = self.denominador // divisor

        # Normalizamos: denominador siempre positivo
        if self.denominador < 0:
            self.numerador *= -1
            self.denominador *= -1

    def __str__(self):
        return f"{self.numerador}/{self.denominador}"

    def __repr__(self):
        return f"Fraccion({self.numerador}, {self.denominador})"

    def __add__(self, other):
        if not isinstance(other, Fraccion):
            return NotImplemented
        num = self.numerador * other.denominador + other.numerador * self.denominador
        den = self.denominador * other.denominador
        return Fraccion(num, den)

    def __sub__(self, other):
        if not isinstance(other, Fraccion):
            return NotImplemented
        num = self.numerador * other.denominador - other.numerador * self.denominador
        den = self.denominador * other.denominador
        return Fraccion(num, den)

    def __mul__(self, other):
        if not isinstance(other, Fraccion):
            return NotImplemented
        num = self.numerador * other.numerador
        den = self.denominador * other.denominador
        return Fraccion(num, den)

    def __truediv__(self, other):
        if not isinstance(other, Fraccion):
            return NotImplemented

        if other.numerador == 0:
            raise ZeroDivisionError("No se puede dividir por cero")

        num = self.numerador * other.denominador
        den = self.denominador * other.numerador
        return Fraccion(num, den)


f1 = Fraccion(4, 5)
f2 = Fraccion(1, 8)

print(f1 + f2)   # 37/40
print(f1 - f2)   # 27/40
print(f1 * f2)   # 1/10
print(f1 / f2)   # 32/5

# Operandos no soportados:
f1 + 2
f1 - 2
f1 * 2
f1 / 2


f1 / Fraccion(2, 1) # Pero esto sí :')
f1 * Fraccion(5, 1) # Pero esto sí :')
