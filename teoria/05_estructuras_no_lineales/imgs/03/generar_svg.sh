#!/usr/bin/env bash
set -euo pipefail

# Ejecutar desde esta carpeta, junto a los fuentes .typ.
compilador="${TYPST_BIN:-typst}"

for nombre in red camino contactos
do
  "$compilador" compile --root .. --format svg "$nombre.typ"
done

for nombre in dfs bfs
do
  "$compilador" compile --root .. "$nombre.typ" "$nombre-{p}.svg"
done
