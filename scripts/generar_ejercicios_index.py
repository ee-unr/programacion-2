import argparse
import pathlib
import json

encabezado = """---
title: %s
---
"""

plantilla = """## %s

```python
{{< include %s >}}
```

"""


def extract_number(name):
    return name.split("_")[0]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("ruta") # Argumento posicional
    args = parser.parse_args()

    directorio = pathlib.Path(args.ruta)
    directorio_salida = pathlib.Path("/".join(directorio.parts[:-1]))

    with open(directorio_salida / "metadata.json") as metadata_file:
        metadata = json.load(metadata_file)

    secciones = [encabezado % metadata["title"]]
    scripts = [path for path in sorted(directorio.iterdir()) if str(path).endswith(".py")]

    for script_path in scripts:
        ejercicio_numero = extract_number(script_path.stem)
        ejercicio_nombre = metadata[ejercicio_numero]
        ejercicio_archivo = "/".join(script_path.parts[-2:])
        secciones.append(plantilla % (ejercicio_nombre, ejercicio_archivo))

    with open(directorio_salida / "index.qmd", mode="w") as archivo_salida:
        archivo_salida.write("\n".join(secciones))