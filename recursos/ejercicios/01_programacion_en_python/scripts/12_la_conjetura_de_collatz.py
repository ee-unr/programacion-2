def collatz(n):
    # Inicializar lista con solo el valor 'n'
    secuencia = [n]
    while n != 1:
        # Numero par
        if n % 2 == 0:
            n = n // 2 # Notar uso de división entera
        # Numero impar
        else:
            # ¿Puede el resultado ser flotante?
            n = 3 * n + 1
        secuencia.append(n)
    return secuencia


collatz(5)
collatz(20)
collatz(16)
collatz(37)

# Para discutir: ¿Podría implementarse con un 'while True'? ¿Cómo?