class Cifrado:
    def __init__(self, original, alternativo):
        if len(original) != len(alternativo):
            raise ValueError(
                f"len(original) != len(alternativo) ({len(original)} vs {len(alternativo)})"
            )

        # Se usan tuplas para poder usar .index
        self.original = tuple(original) 
        self.alternativo = tuple(alternativo)


    def codificar(self, texto):
        # Version corta:
        caracteres_codificados = [
            self.alternativo[self.original.index(caracter)] for caracter in texto
        ]

        # Version larga
        caracteres_codificados = []
        for caracter in texto:
            indice = self.original.index(caracter)
            caracteres_codificados.append(self.alternativo[indice])
        return "".join(caracteres_codificados)

    def decodificar(self, texto):
        # Análogo al método anterior (pero usando generador)
        return "".join(self.original[self.alternativo.index(caracter)] for caracter in texto)


alfabeto = "abcdefghijklmnopqrstuvwxyz"
alfabeto_mezclado = "etaoinshrdlucmfwypvbgkjqxz"

mi_cifrado = Cifrado(alfabeto, alfabeto_mezclado)

mi_cifrado.codificar("abc")    # => "eta"
mi_cifrado.codificar("xyz")    # => "qxz"
mi_cifrado.codificar("aeiou")  # => "eirfg"

mi_cifrado.decodificar("eta")    # => "abc"
mi_cifrado.decodificar("qxz")    # => "xyz"
mi_cifrado.decodificar("eirfg")  # => "aeiou"
