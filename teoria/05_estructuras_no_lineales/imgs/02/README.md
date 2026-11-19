## Compilar a SVG

Para generar todos los SVG de árboles desde esta carpeta, junto a los `.typ`:

```bash
bash generar_svg.sh
```

Desde esta carpeta, para una figura estática:

```bash
typst compile --root .. --format svg terminologia-0.typ
```

Esto crea `terminologia-0.svg` con el mismo nombre que el fuente.
También se puede abreviar `--format svg` como `-f svg`.

Para una secuencia de varias páginas, Typst necesita una plantilla de nombres de salida:

```bash
typst compile --root .. inorden.typ 'inorden-{p}.svg'
```

`{p}` se reemplaza por el número de página, empezando en 1.
El ejemplo produce `inorden-1.svg` a `inorden-16.svg`.
El apunte muestra primero los tres recorridos sobre el mismo árbol de números, con sus listas
resultantes y su implementación. Después presenta las aplicaciones de cada orden de visita.
Las secuencias numéricas distinguen llegar a un nodo de agregar su valor a la lista:

- `preorden.typ`: 16 pasos. Cada valor se agrega antes de recorrer los hijos.
- `inorden.typ`: 16 pasos. Cada valor se agrega entre el subárbol izquierdo y el derecho.
- `postorden.typ`: 19 pasos. Cada valor se agrega después de recorrer ambos subárboles.

El borde de 1.6 pt marca el nodo actual: azul `#0066CC` sobre el relleno celeste
y verde oscuro `#3D7A36` sobre el relleno verde.
El verde señala los valores ya incorporados al resultado.
Los nodos cuyo valor todavía no se incorporó conservan el celeste original.
Debajo del árbol, una lista alineada a la izquierda empieza vacía y crece con cada visita.
Las flechas siempre son negras, incluidas sus puntas. El trazo habitual es de 1 pt
y el camino de las llamadas desde la raíz se destaca con 1.4 pt.
Los tres documentos usan `dibujar-paso-recorrido`, definido en `base.typ`, para compartir el estilo.

Las dos aplicaciones del apunte tienen secuencias en dos columnas, sin encabezados dentro de las figuras:

- `aplicacion-directorios.typ`: 10 pasos de preorden. A la derecha aparece el listado con sangría.
- `aplicacion-expresion.typ`: 14 pasos de postorden para evaluar `a / (2 * b - c)`.
  Las variables valen `a = 15`, `b = 27` y `c = 2.5`. El código de la derecha se actualiza
  cuando obtenemos cada valor. En el árbol, cada operación resuelta se reemplaza por su resultado.

`aplicaciones-base.typ` fija el ancho de las columnas. La altura se ajusta al árbol completo,
sin espacio adicional debajo. Las imágenes se ajustan al espacio disponible del carrusel.
En `styles.scss`, los carruseles con identificador `arboles-` reservan 3 rem a cada lado
para los controles, de modo que las flechas no se superpongan con el árbol ni con la salida.
Los nombres y la sangría del directorio se editan en `lineas`.
En la expresión, `etapa` determina los resultados ya obtenidos y los nodos que se absorben
al reemplazar un subárbol. `expresiones` contiene el texto de código que corresponde a cada etapa.
El script `generar_svg.sh` también exporta estas dos secuencias.

La eliminación tiene tres secuencias, que parten del árbol original e incluyen la búsqueda:

- `eliminacion.typ`: quitar la hoja `20`, en cuatro pasos.
- `eliminacion-un-hijo.typ`: quitar `40` y enlazar su hijo `45`, en cinco pasos.
- `eliminacion-dos-hijos.typ`: quitar `30` usando su sucesor `40`, en seis pasos.

En el último caso se copia el valor del sucesor y después se elimina su nodo original.
Los dos nodos con valor `40` del paso intermedio representan ese estado transitorio.

La opción `--root ..` permite importar el estilo compartido de la carpeta `01`.
