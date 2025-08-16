import argparse

parser = argparse.ArgumentParser(description="Saluda a una persona")
parser.add_argument("nombre", help="El nombre de la persona")
parser.add_argument("--veces", type=int, default=1, help="Cuántas veces saludar")

args = parser.parse_args()

for _ in range(args.veces):
    print(f"¡Hola, {args.nombre}!")