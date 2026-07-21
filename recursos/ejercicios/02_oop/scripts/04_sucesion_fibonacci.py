def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

for i in range(15):
    print(fibonacci(i))
