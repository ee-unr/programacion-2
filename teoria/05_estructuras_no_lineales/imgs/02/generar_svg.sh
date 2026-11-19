#!/usr/bin/env bash
set -euo pipefail

# Ejecutar desde esta carpeta, junto a los fuentes .typ.
compilador="${TYPST_BIN:-typst}"

# Figuras individuales. El SVG conserva el nombre del fuente.
for fuente in ./*-[0-9].typ
do
  "$compilador" compile --root .. --format svg "$fuente"
done

# Secuencias. Cada página se exporta a un SVG numerado desde 1.
for nombre in busqueda insercion eliminacion eliminacion-un-hijo eliminacion-dos-hijos preorden inorden postorden aplicacion-directorios aplicacion-expresion
do
  "$compilador" compile --root .. \
    "$nombre.typ" "$nombre-{p}.svg"
done
