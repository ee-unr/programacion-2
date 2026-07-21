DOM = {
    1: 31,  # Enero
    2: 28,  # Febrero (29 en año bisiesto)
    3: 31,  # Marzo
    4: 30,  # Abril
    5: 31,  # Mayo
    6: 30,  # Junio
    7: 31,  # Julio
    8: 31,  # Agosto
    9: 30,  # Septiembre
    10: 31, # Octubre
    11: 30, # Noviembre
    12: 31, # Diciembre
}

class Date:
    def __init__(self, year, month, day):
        self.year = year
        self.month = month
        self.day = day

    @property
    def year(self):
        return self._year

    @year.setter
    def year(self, value):
        assert isinstance(value, int)
        assert value > 0
        self._year = value

    @property
    def month(self):
        return self._month

    @month.setter
    def month(self, value):
        assert isinstance(value, int)
        assert 1 <= value <= 12
        self._month = value

    @property
    def day(self):
        return self._day

    @day.setter
    def day(self, value):
        assert isinstance(value, int)
        assert 1 <= value <= Date._dias_del_mes(self.year, self.month)
        self._day = value

    @classmethod
    def from_str(cls, value):
        parts = value.split("-")
        assert len(parts) == 3
        year, month, day = map(int, map(lambda x: x.lstrip("0"), parts))

        assert year > 0
        assert 1 <= month <= 12
        assert 1 <= day <= Date._dias_del_mes(year, month)

        return cls(year=year, month=month, day=day)

    def __eq__(self, other):
        if isinstance(other, type(self)):
            return self.year == other.year and self.month == other.month and self.day == other.day
        return False

    def __neq__(self, other):
        return not self == other

    def __gt__(self, other):
        if self.year > other.year:
            return True
        elif self.year == other.year:
            if self.month > other.month:
                return True
            elif self.month == other.month:
                return self.day > other.day
        return False

    def __ge__(self, other):
        return (self > other) or (self == other)

    def __lt__(self, other):
        if self.year < other.year:
            return True
        elif self.year == other.year:
            if self.month < other.month:
                return True
            elif self.month == other.month:
                return self.day < other.day
        return False

    def __le__(self, other):
        return (self < other) or (self == other)

    def __str__(self):
        year = str(self.year).rjust(4, "0")
        month = str(self.month).rjust(2, "0")
        day = str(self.day).rjust(2, "0")

        return f"{year}-{month}-{day}"

    def __repr__(self):
        return f"Date(year={self.year}, month={self.month}, day={self.day})"

    @staticmethod
    def _es_bisiesto(year):
        # Divisible por 4,
        # excepto que sea divisible por 100,
        # salvo que tambien sea divisibles por 400
        return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

    @staticmethod
    def _dias_del_mes(year, month):
        if month == 2 and Date._es_bisiesto(year):
            return 29
        return DOM[month]


d = Date(1995, 11, 6)
d
str(d)


Date.from_str("2025-05-06")

d = Date(2025, 11, 12)
d2 = Date(2025, 11, 12)
d3 = Date(2025, 11, 13)

d == d3
d > d3
d3 > d
d < d3

Date.from_str("2025-11-28")

Date(2000, 2, 29)

# Como 'Date' soporta la operación de comparación, podemos usar sorted
fechas = (Date(2022, 2, 28), Date(2025, 1, 31), Date(1816, 7, 9), Date(1810, 5, 25))
sorted(fechas)

# O max ... o min
max(fechas)
min(fechas)

# NOTA: Los métodos estáticos podrían ser tranquilamente funciones auxiliares.
