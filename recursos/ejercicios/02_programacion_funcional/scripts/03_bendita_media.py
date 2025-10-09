def mean(valores, *args):
    # Asume que 'valores' es coleccion de numeros
    if not args:
        return sum(valores) / len(valores)

    # Asume que 'valores' es un solo numero
    x = [valores] + list(args)
    return sum(x) / len(x)


mean([6.27, 8.11, 7.6, 5.2, 4.8])
mean(7.3, 8.2, 11.0, 12.5)
