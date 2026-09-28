def frange(start, stop, step):
    while start < stop:
        yield start
        start += step

for i in frange(3, 4, 0.2):
    print(f"{i:.2f}")

for i in frange(3, 4, 0.15):
    print(f"{i:.2f}")
