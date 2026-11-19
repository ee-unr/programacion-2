## Figuras de grafos


## Compilar a SVG

Desde esta carpeta:

```bash
bash generar_svg.sh
```

Para elegir otro ejecutable:

```bash
TYPST_BIN=/ruta/a/typst bash generar_svg.sh
```

Para una figura estática o una secuencia:

```bash
typst compile --root .. --format svg red.typ
typst compile --root .. dfs.typ 'dfs-{p}.svg'
```

Para actualizar una secuencia al guardar cambios:

```bash
typst watch --root .. dfs.typ 'dfs-{p}.svg'
```

`--root ..` permite importar el estilo de `01`. La numeración `{p}` empieza en 1.
Los SVG usados por el apunte se guardan junto a sus fuentes.
Los carruseles reservan espacio lateral para sus controles mediante `styles.scss`.
