#import "@preview/touying:0.6.3": *
#import "@preview/typed-dsa:0.7.0" as dsa
#import "template.typ": setup-template, new-section-slide, inverted-slide, highlight-box, codigo-pasos

// DEFINICIONES DE LOS DIAGRAMAS
// Cada secuencia se llama más abajo, en el lugar de la clase que corresponde.
// Todas las opciones y explicaciones se editan en este mismo archivo.

// Estilo común de los diagramas. Ajustar tamaños, colores y separaciones aquí.
#let azul = rgb("#e3eff5")
#let estilo = (
  box-fill: azul,
  box-stroke: 0.8pt + rgb("#536773"),
  ptr-fill: rgb("#d9e8eb"),
  prev-ptr-fill: rgb("#d9e8eb"),
  next-ptr-fill: rgb("#d9e8eb"),
  box-w: 1.1,
  box-h: 0.85,
  box-gap: 0.65,
  node-text: (font: "Atkinson Hyperlegible", size: 12pt),
  label-text: (size: 10pt, fill: rgb("#343a40")),
  new-style: (fill: rgb("#c8e6c9"), stroke: 1.2pt + rgb("#387541")),
  remove-style: (fill: rgb("#ffcdd2"), stroke: 1.2pt + rgb("#a43e47")),
  path-style: (fill: rgb("#ffe9a8"), stroke: 1.2pt + rgb("#9a751c")),
  scale: 1.5,
)

// Un cuadro por avance. El recuadro fijo evita cambios de altura en el texto.
#let diagramas(titulo, cuadros) = {
  for (dibujo, explicacion) in cuadros {
    slide[
      // typed-dsa fija esta etiqueta en inglés; adaptamos solo su texto.
      #show "NULL": "None"
      = #titulo
      #block(width: 100%, height: 245pt)[
        #align(center + horizon)[#dibujo]
      ]
      #v(0.4em)
      #explicacion
    ]
  }
}

#let pila(..valores) = dsa.stack(
  ..valores,
  style: estilo + (box-w: 2.8, scale: 1.4),
  top-label: [Cima], language: "es",
)
#let cola(..valores) = dsa.queue(
  ..valores, style: estilo,
  front-label: [Frente], rear-label: [Final], language: "es",
)
// Las direcciones pertenecen a los nodos: no cambian al insertar o eliminar.
// Los ejemplos numéricos coinciden con la cuadrícula de memoria.
#let direcciones = (
  "30": 1043, "10": 1030, "75": 1019, "25": 1033,
  "85": 1021, "50": 1024, "60": 1040,
  "A": 1043, "M": 1024, "B": 1030, "Z": 1033,
  "Y": 1021, "C": 1019, "D": 1040, "E": 1028,
)
#let lista(marca-insercion: false, ..valores) = dsa.linked-list(
  ..valores, style: estilo + if marca-insercion { (remove-style: estilo.new-style) } else { (:) },
  pointer: true, head: true,
  addresses: valores.pos().map(v => direcciones.at(str(v))),
  language: "es", messages: (list: (head: [Inicio],)),
)
#let estilo-doble = estilo + (
  scale: 1.55, box-w: 0.95, box-h: 1.1, box-gap: 0.85,
  node-text: (font: "Atkinson Hyperlegible", size: 14pt),
  label-text: (size: 11pt, fill: rgb("#343a40")),
)
#let doble(marca-insercion: false, ..valores) = dsa.doubly-linked-list(
  ..valores,
  style: estilo-doble + if marca-insercion { (remove-style: estilo.new-style) } else { (:) },
  pointer: true, head: true,
  addresses: valores.pos().map(v => direcciones.at(str(v))),
  language: "es", messages: (list: (head: [Inicio],)),
)

// La inserción de typed-dsa deja sin dirección el nuevo nodo. Reconstruimos
// ese estado con todas las direcciones y usamos el resaltado de su API pública.
// delete-at.before marca el nodo sin quitarlo; aquí el color se cambia a verde.
#let insertar-nodo(constructor, valores, valor, indice) = {
  let nuevos = valores.slice(0, indice) + (valor,) + valores.slice(indice)
  let marcado = constructor(..nuevos, marca-insercion: true)
  (
    before: constructor(..valores).diagram,
    after: (marcado.delete-at)(indice).before,
    result: constructor(..nuevos),
  )
}
#let arreglo(valores, cima: none) = dsa.array-view(
  ..valores,
  style: estilo + (box-w: 2.6, scale: 1.25, indices: (enabled: true)),
  pointers: if cima == none { () } else { ((index: cima, label: [Cima], color: rgb("#2e7d8a")),) },
  reserve-pointers: true,
).diagram

// Estados de los ejemplos. Los valores y las operaciones están escritos explícitamente.
#let p = pila("Objeto A", "Objeto M", "Objeto B", "Objeto Z")

#let apilar = (p.push)("Objeto Y")

#let extraer-y = (apilar.result.pop)()
#let extraer-a = (extraer-y.result.pop)()
#let extraer-m = (extraer-a.result.pop)()

#let q = cola("A", "B", "C", "D", "E")
#let agregar-m = (q.enqueue)("M")
#let agregar-z = (agregar-m.result.enqueue)("Z")
#let sacar-a = (agregar-z.result.dequeue)()
#let sacar-b = (sacar-a.result.dequeue)()

#let valores-lista = (30, 10, 75, 25)
#let l = lista(..valores-lista)

// search resalta el prefijo visitado. Lo usamos también para ilustrar el
// recorrido por índice, sin acceder a funciones internas de dibujo.

#let al-inicio = insertar-nodo(lista, valores-lista, 85, 0)

#let al-medio = insertar-nodo(lista, valores-lista, 50, 2)

#let al-final = insertar-nodo(lista, valores-lista, 60, 4)

#let eliminar-inicio = (l.delete-at)(0)
#let eliminar-medio = (al-medio.result.delete-at)(2)

#let valores-doble = (30, 10, 75)
#let d = doble(..valores-doble)
#let doble-agregar = insertar-nodo(doble, valores-doble, 60, 3)
#let doble-quitar = (doble-agregar.result.delete-at)(3)

#let pila-enlazada = lista("A", "M", "B", "Z")
#let nueva-cima = insertar-nodo(lista, ("A", "M", "B", "Z"), "Y", 0)
#let quitar-cima = (nueva-cima.result.delete-at)(0)

#let cola-enlazada = doble("A", "B", "C")
#let nuevo-final = insertar-nodo(doble, ("A", "B", "C"), "M", 3)
#let quitar-frente = (nuevo-final.result.delete-at)(0)

// Secuencias de diagramas: cada par contiene un dibujo y su explicación.
// Agregar, quitar o reemplazar un par cambia un avance de la presentación.
#let pila-vista() = diagramas([Pilas], (
  (p.diagram, [Ninguna celda tiene propiedades especiales. Usamos el mismo color para todas. Solo podemos interactuar con la cima.]),
))

#let pila-insercion() = diagramas([Inserción], (
  (apilar.before, [Queremos agregar un nuevo objeto a la pila.]),
  (apilar.after, [El nuevo objeto se coloca encima de todos los demás.]),
))

#let pila-eliminacion() = diagramas([Eliminación], (
  (extraer-y.before, [Solo podemos extraer el objeto en la cima: primero sale Objeto Y.]),
  (extraer-y.after, [Después de extraer Objeto Y, Objeto A queda en la cima.]),
  (extraer-a.before, [Para extraer varios objetos, repetimos el proceso desde la cima.]),
  (extraer-a.after, [Extraemos Objeto A. Ahora Objeto M queda en la cima.]),
  (extraer-m.after, [Al extraer Objeto M, Objeto B pasa a ocupar la cima.]),
))

#let pila-arreglo() = diagramas([Implementación], (
  (arreglo(("Objeto Z", "Objeto B", "Objeto M", "Objeto A"), cima: 3), [Imaginemos que tumbamos la pila: la cima corresponde al final del arreglo.]),
  (arreglo(("Objeto Z", "Objeto B", "Objeto M", "Objeto A", "Objeto Y"), cima: 4), [Insertar en la cima equivale a agregar al final del arreglo.]),
  (arreglo(("Objeto Z", "Objeto B", "Objeto M", "Objeto A"), cima: 3), [Extraer de la cima equivale a quitar el último elemento.]),
  (arreglo(("Objeto Z", "Objeto B", "Objeto M"), cima: 2), [La siguiente extracción vuelve a ocurrir al final.]),
  (arreglo(("Objeto Z", "Objeto B"), cima: 1), [En cada extracción, la longitud del arreglo se reduce.]),
))

#let cola-operaciones() = diagramas([Colas], (
  (q.diagram, [Los elementos entran por el final y salen por el frente.]),
  (agregar-m.after, [Agregamos M al final de la cola.]),
  (agregar-z.after, [Si agregamos Z, también lo hacemos al final.]),
  (sacar-a.before, [Extraemos A, el primero en haber llegado.]),
  (sacar-a.after, [B pasa a ocupar el frente de la cola.]),
  (sacar-b.before, [En la siguiente extracción sale B.]),
  (sacar-b.after, [Los demás avanzan hacia el frente. El orden de llegada se conserva.]),
))

#let nodos-vista() = diagramas([El nodo], (
  (lista(75).diagram, [Cada nodo guarda un valor y una referencia al siguiente. Debajo mostramos su dirección en memoria. `None` indica que no hay un siguiente nodo.]),
  (lista(30).diagram, [Creamos un primer nodo. Por ahora no tiene un siguiente.]),
  (lista(30, 10).diagram, [Enlazamos el primer nodo con el segundo.]),
  (lista(30, 10, 75).diagram, [El segundo nodo apunta al tercero.]),
  (l.diagram, [El tercer nodo apunta al cuarto. El último no tiene siguiente.]),
))

#let lista-vista() = diagramas([Implementación básica], (
  (l.diagram, [Solo necesitamos guardar una referencia al primer nodo. Desde allí, seguimos los enlaces. Las direcciones no tienen que ser consecutivas.]),
))

#let lista-lectura() = diagramas([Lectura], (
  (l.diagram, [Queremos leer el valor del índice 3. Conocemos la dirección del primer nodo.]),
  ((l.search)(30).after, [Empezamos en el primer nodo, índice 0.]),
  ((l.search)(10).after, [Seguimos el enlace al nodo del índice 1.]),
  ((l.search)(75).after, [Seguimos al índice 2. Todavía no llegamos al índice solicitado.]),
  ((l.search)(25).after, [Llegamos al índice 3 y devolvemos su valor: 25. Para llegar hasta allí pasamos por los nodos anteriores.]),
))

#let lista-busqueda() = diagramas([Búsqueda], (
  (l.diagram, [Recibimos un valor y queremos devolver su índice. Busquemos el 75.]),
  ((l.search)(30).after, [Comparamos el valor del primer nodo con el buscado. El 30 no coincide.]),
  ((l.search)(10).after, [Avanzamos al siguiente nodo. El 10 tampoco coincide.]),
  ((l.search)(75).after, [Encontramos el 75 en el índice 2. La búsqueda termina.]),
  ((l.search)(99).after, [Si buscamos el 99, llegamos al final sin encontrarlo. Devolvemos None.]),
))

#let lista-insercion-inicio() = diagramas([Inserción], (
  (al-inicio.before, [Queremos insertar un nuevo elemento al inicio.]),
  (al-inicio.after, [El nuevo nodo apunta al primero anterior. La lista pasa a comenzar en el nuevo nodo. Insertar al inicio es de orden O(1).]),
))

#let lista-insercion-medio() = diagramas([Inserción], (
  (l.diagram, [Queremos insertar 50 entre 10 y 75. Primero buscamos el nodo anterior.]),
  ((l.search)(30).after, [Comenzamos el recorrido desde el primer nodo.]),
  ((l.search)(10).after, [Encontramos el nodo anterior a la posición de inserción: el que contiene el 10.]),
  (al-medio.after, [Actualizamos los enlaces: el nuevo nodo apunta al 75 y el nodo con valor 10 apunta al nuevo nodo.]),
))

#let lista-insercion-final() = diagramas([Inserción], (
  ((l.search)(25).after, [Si solo conocemos el primer nodo, insertar al final requiere recorrer toda la lista.]),
  (al-final.after, [El último nodo pasa a apuntar al nuevo nodo, que contiene el 60. No desplazamos los valores anteriores.]),
))

#let lista-eliminacion() = diagramas([Eliminación], (
  (eliminar-inicio.before, [Para eliminar al inicio, hacemos que el segundo nodo pase a ser el primero.]),
  (eliminar-inicio.after, [Solo actualizamos el inicio de la lista. El costo es de orden O(1).]),
  (eliminar-medio.before, [Ahora queremos eliminar el 50 de una posición intermedia.]),
  (eliminar-medio.after, [El nodo anterior pasa a apuntar al siguiente del que queremos eliminar. No desplazamos los demás valores.]),
))

#let doble-operaciones() = diagramas([Listas doblemente enlazadas], (
  (d.diagram, [Cada nodo tiene dos referencias: una al anterior y otra al siguiente. El primero no tiene anterior. El último no tiene siguiente.]),
  (doble-agregar.after, [Si mantenemos referencias al primero y al último, podemos insertar al final en tiempo constante. Actualizamos los enlaces en ambas direcciones.]),
  (doble-quitar.before, [También podemos eliminar el último nodo sin recorrer la lista desde el inicio.]),
  (doble-quitar.after, [Su anterior pasa a ser el último. Su referencia siguiente queda vacía.]),
))

#let pila-enlazada-operaciones() = diagramas([Pilas como una lista enlazada], (
  (pila-enlazada.diagram, [El primer nodo representa la cima de la pila.]),
  (nueva-cima.after, [Insertar: agregamos un nuevo primer nodo.]),
  (quitar-cima.before, [Extraer: quitamos el primer nodo. El último en entrar es el primero en salir.]),
  (quitar-cima.after, [El segundo nodo pasa a ser el primero. Ambas operaciones son de orden O(1).]),
))

#let cola-enlazada-operaciones() = diagramas([Colas con una lista doblemente enlazada], (
  (cola-enlazada.diagram, [Mantenemos referencias al primer y al último nodo: el frente y el final de la cola.]),
  (nuevo-final.after, [Insertamos M al final usando la referencia al último nodo.]),
  (quitar-frente.before, [Extraemos A desde el frente: fue el primero en llegar.]),
  (quitar-frente.after, [B pasa a ser el primero. Insertar al final y extraer desde el inicio son operaciones de orden O(1).]),
))

// Transición de la ilustración de cajas al modelo de celdas de memoria.
// Son cuatro rectángulos nativos de Typst, sin una imagen intermedia.
#let pila-colores() = diagramas([Pilas], ((
  stack(
    dir: ttb, spacing: 0pt,
    ..(("Objeto A", "#edb36a"), ("Objeto M", "#9eb889"),
       ("Objeto B", "#ebd881"), ("Objeto Z", "#d8948f")).map(par =>
      rect(width: 130pt, height: 51pt, fill: rgb(par.at(1)),
        stroke: 0.8pt + rgb("#536773"))[
        #align(center + horizon)[#text(size: 17pt)[#par.at(0)]]
      ]
    ),
  ),
  [Cada caja representa un objeto en memoria. Los colores nos ayudan a reconocerlos.],
),))

// Memoria esquemática: cada celda representa espacio para un nodo completo,
// no un byte. Las direcciones son ilustrativas, como en el apunte.
// Mantener posiciones y referencias en esta tabla basta para modificar el dibujo.
#let nodos-memoria = (
  "1043": (valor: "30", siguiente: "1030"),
  "1030": (valor: "10", siguiente: "1019"),
  "1019": (valor: "75", siguiente: "1033"),
  "1033": (valor: "25", siguiente: "None"),
)
#let memoria(insertado: false, actual: none) = {
  let nodos = nodos-memoria
  if insertado {
    nodos.insert("1030", (valor: "10", siguiente: "1024"))
    nodos.insert("1024", (valor: "50", siguiente: "1019"))
  }
  grid(
    columns: (96pt,) * 7, gutter: 4pt,
    ..range(1018, 1046).map(direccion => {
      let clave = str(direccion)
      let nodo = nodos.at(clave, default: none)
      let fondo = if clave == actual { rgb("#ffe9a8") }
        else if insertado and clave == "1024" { rgb("#c8e6c9") }
        else if nodo != none { azul }
        else { rgb("#f3f4f5") }
      box(width: 96pt, height: 56pt, inset: 4pt,
        fill: fondo,
        stroke: if clave == actual { 1.5pt + rgb("#9a751c") }
          else { 0.6pt + rgb("#adb5bd") },
      )[
        #align(center + horizon)[
          #grid(
            columns: (1fr,), rows: (12pt, 18pt, 12pt),
            row-gutter: 1pt, align: center + horizon,
            text(size: 11pt, fill: rgb("#64717a"))[#clave],
            if nodo != none {
              text(size: 16pt, weight: "bold")[#nodo.valor]
            } else { text(size: 9pt, fill: rgb("#8b949b"))[·] },
            if nodo != none {
              text(size: 11pt)[siguiente: #nodo.siguiente]
            } else { [] },
          )
        ]
      ]
    }),
  )
}

#let memoria-inicial() = diagramas([Implementación básica], (
  (memoria(), [Los nodos pueden estar dispersos en la memoria. Cada celda representa espacio para un nodo; las direcciones son ilustrativas.]),
  (memoria(actual: "1043"), [La lista comienza en 1043. Ese nodo contiene el 30 y una referencia a 1030.]),
  (memoria(actual: "1030"), [Seguimos la referencia hasta 1030. El nodo con valor 10 apunta a 1019: los enlaces mantienen el orden de la secuencia.]),
  (memoria(actual: "1019"), [En 1019 encontramos el valor 75 y la referencia a 1033. Seguimos ese enlace.]),
  (memoria(actual: "1033"), [El nodo en 1033 contiene el 25. Su referencia siguiente es None: llegamos al final de la lista.]),
))

#let memoria-insercion() = diagramas([Inserción], (
  (memoria(actual: "1030"), [Antes de insertar, el nodo con valor 10 apunta al nodo con valor 75, en 1019.]),
  (memoria(insertado: true), [El nuevo nodo, con valor 50, ocupa la dirección 1024 y apunta a 1019. El nodo con valor 10 ahora apunta a 1024. Los demás no se mueven.]),
))

// Misma plantilla y secuencias que en 04_01_arreglos.typ.
// Los ejemplos siguen teoria/04_estructuras_lineales/02_estructuras_lineales.qmd.
#let assets = "../teoria/04_estructuras_lineales/imgs/02/"
#let figure-slide(title, file, caption: [], height: 270pt, max-width: 100%, caption-size: 0.95em) = slide[
  = #title
  #block(width: 100%, height: height)[
    #align(center + horizon)[
      #image(assets + file, width: max-width, height: height, fit: "contain")
    ]
  ]
  #v(0.4em)
  #text(size: caption-size)[#caption]
]

// PRESENTACIÓN

#show: setup-template.with(
  title: [Programación II],
  subtitle: [Estructuras lineales],
  header-label: [Unidad 4],
  footer-label: [Estructuras lineales],
  author: [Tomás Capretto],
  institution: [FCEyE · Universidad Nacional de Rosario]
)


#new-section-slide[Introducción]

#slide[
  = Introducción

  En el apunte anterior analizamos el desempeño de distintas estructuras basadas en arreglos.

  #pause

  Pero la velocidad no es lo único que importa...

  #pause

  #highlight-box[
    Una estructura también puede ayudarnos a escribir código más simple y fácil de leer.
  ]
]

#slide[
  = Estructuras lineales

  Los elementos están organizados uno detrás de otro, formando una secuencia.

  Cada elemento, excepto el primero y el último, tiene un predecesor y un sucesor.

  #pause

  Vamos a trabajar con:

  - Pilas
  - Colas
  - Listas enlazadas
  - Listas doblemente enlazadas
]

#new-section-slide[Pilas]

#slide[
  = Pilas

  Una colección de objetos con restricciones para insertar y eliminar.

  #components.side-by-side(gutter: 1cm, columns: (1fr, 2fr))[
    #align(center)[#image(assets + "pila_cajas.png", height: 230pt)]
  ][
    #pause

    Primero colocamos la caja roja, luego la amarilla, la verde y la naranja.

    #pause

    ¿Podemos sacar cualquiera?

    #pause

    Para sacar una caja, empezamos por la de arriba.
  ]
]

#figure-slide([Pilas], "pila_cajas_brazo.png", caption: [Solo podemos leer, quitar o agregar cajas desde la cima.], max-width: 60%)

#slide[
  = Pilas

  #highlight-box(title: [LIFO])[
    _Last in, first out_: el último en entrar es el primero en salir.
  ]

  #pause

  - Agregamos elementos en la cima.
  - Leemos el elemento de la cima.
  - Extraemos el elemento de la cima.
]

#pila-colores()

#pila-vista()

#slide[
  = Lectura

  Solo podemos leer el valor en la cima de la pila.

  #pause

  Leer no implica extraer el objeto.

  #pause

  Para acceder a uno que está más abajo, primero debemos extraer los que tiene encima.
]

#pila-insercion()

#pila-eliminacion()

#slide[
  = Implementación

  En la práctica, no trabajamos directamente con una pila de celdas de memoria.

  #pause

  La pila es un *tipo de dato abstracto*: define cómo podemos interactuar con los datos.

  #pause

  Para usarla en un programa necesitamos una implementación concreta.
]

#slide[
  = Implementación

  Una opción: un arreglo al que le imponemos ciertas restricciones.

  #pause

  #highlight-box(title: [La idea])[
    Creamos una clase `Pila` que guarda los valores en una lista de Python.

    Solo permitimos interactuar con el último elemento de esa lista.
  ]
]

#pila-arreglo()

#slide[
  = Implementación

  #codigo-pasos((3, 6, 11))[
    ```python
    class Pila:
        def __init__(self):
            self._datos = []

        def insertar(self, element):
            self._datos.append(element)

        def extraer(self):
            if len(self._datos) > 0:
                return self._datos.pop()
            return None
    ```
  ]

  #uncover("4-")[
    No indicamos una posición: siempre insertamos y extraemos desde la cima.
  ]
]

#slide[
  = Implementación

  Los otros métodos de `Pila`:

  #codigo-pasos((4, 8))[
    ```python
        def leer(self):
            if len(self._datos) > 0:
                return self._datos[-1]
            return None

        @property
        def vacia(self):
            return len(self._datos) == 0
    ```
  ]

  #uncover("3-")[
    `leer` consulta la cima sin retirar el elemento.
  ]
]

#slide[
  = Aplicaciones

  El protocolo LIFO nos permite resolver distintos problemas.

  #item-by-item[
    - Invertir el orden de los datos.
    - Verificar paréntesis y corchetes.
  ]
]

#slide[
  = Invertir orden

  Apilamos los valores 1, 2 y 3, en ese orden.

  #pause

  Al extraerlos, obtenemos 3, 2 y 1.

  #pause

  #highlight-box[
    Podemos hacer lo mismo con las líneas de un archivo: apilarlas y escribirlas en el orden en que salen.
  ]
]

#slide[
  = Invertir orden

  #codigo-pasos((2, 6, 10))[
    ```python
    def invertir_archivo(origen, destino):
        pila = Pila()

        with open(origen) as archivo_origen:
            for linea in archivo_origen:
                pila.insertar(linea.rstrip("\n"))

        with open(destino, "w") as archivo_destino:
            while not pila.vacia:
                archivo_destino.write(pila.extraer() + "\n")
    ```
  ]

  #uncover("4-")[
    Primero apilamos todas las líneas. Después las extraemos una a una.
  ]
]

#slide[
  = Invertir orden

  `original.txt`:

  ```text
  ¿Quién es tu nuevo amor?
  ¿Tu nueva ocupación?
  ¿Tu misterioso alguien?
  ```

  #pause

  ```python
  invertir_archivo("original.txt", "invertido.txt")
  ```

  #pause

  `invertido.txt`:

  ```text
  ¿Tu misterioso alguien?
  ¿Tu nueva ocupación?
  ¿Quién es tu nuevo amor?
  ```
]

#slide[
  = Verificar paréntesis y corchetes

  Cada símbolo de apertura debe tener su correspondiente cierre.

  #pause

  ¿Alcanza con contar cuántos abren y cuántos cierran?

  ```text
  1 +) (3 * 5()
  ```

  #pause

  Hay la misma cantidad, pero la expresión es incorrecta.
]

#slide[
  = Verificar paréntesis y corchetes

  Recorremos la expresión de izquierda a derecha.

  #item-by-item[
    - Si encontramos una apertura, la apilamos.
    - Si encontramos un cierre, extraemos la última apertura.
    - Verificamos que formen un par válido.
    - Al terminar, la pila debe estar vacía.
  ]
]

#slide[
  = Verificar paréntesis y corchetes

  #codigo-pasos((4, 8, 11, 13, 15))[
    ```python
    def verificar_agrupamientos(expr):
        apertura = "(["
        cierre = ")]"
        pila = Pila()

        for caracter in expr:
            if caracter in apertura:
                pila.insertar(caracter)
            elif caracter in cierre:
                if pila.vacia:
                    return False
                if cierre.index(caracter) != apertura.index(pila.extraer()):
                    return False

        return pila.vacia
    ```
  ]
]

#slide[
  = Verificar paréntesis y corchetes

  Por ejemplo, con #raw("[3 + (4 * 5)]"):

  #item-by-item[
    - Leemos #raw("[") → lo apilamos.
    - Leemos #raw("(") → lo apilamos encima del corchete.
    - Leemos #raw(")") → extraemos #raw("("). Forman un par.
    - Leemos #raw("]") → extraemos #raw("["). Forman un par.
    - Terminamos con la pila vacía → #raw("True").
  ]
]

#slide[
  = Verificar paréntesis y corchetes

  ```python
  verificar_agrupamientos("(3 + (4 * 5))")  # True
  verificar_agrupamientos("[3 + (4 * 5)]")  # True
  ```

  #pause

  ```python
  verificar_agrupamientos("(3 + (4 * 5)")   # False
  verificar_agrupamientos("(3 + [(4 * 5)")  # False
  ```

  #pause

  Si queda una apertura sin cerrar, la pila no queda vacía.
]

#new-section-slide[Colas]

#figure-slide([Colas], "cola_personas.png", caption: [Los primeros en llegar al banco son los primeros en entrar.], max-width: 85%)

#slide[
  = Colas

  Una colección ordenada de objetos que sigue el principio FIFO.

  #highlight-box(title: [FIFO])[
    _First in, first out_: el primero en entrar es el primero en salir.
  ]

  #pause

  - Los nuevos elementos se agregan al final.
  - Los elementos se extraen desde el frente.
]

#slide[
  = Colas

  Las solicitudes se atienden en orden de llegada.

  Algunos ejemplos:

  #item-by-item[
    - Restaurantes y tiendas.
    - Plataformas de venta de entradas.
    - Impresoras en red.
    - Atención de llamadas.
  ]
]

#slide[
  = Implementación

  La cola también es un *tipo de dato abstracto*.

  Define cómo se comporta, pero no cómo almacena los elementos.

  #pause

  Una implementación posible usa un arreglo restringido:

  - Insertamos al final.
  - Extraemos desde el índice 0.
]

#cola-operaciones()

#slide[
  = Implementación

  #codigo-pasos((3, 6, 11))[
    ```python
    class Cola:
        def __init__(self):
            self._datos = []

        def insertar(self, element):  # enqueue
            self._datos.append(element)

        def extraer(self):           # dequeue
            if len(self._datos) > 0:
                return self._datos.pop(0)
            return None
    ```
  ]

  #uncover("4-")[
    A diferencia de la pila, extraemos desde el frente.
  ]
]

#slide[
  = Implementación

  Los otros métodos de `Cola`:

  #codigo-pasos((4, 8, 11))[
    ```python
        def leer(self):
            if len(self._datos) > 0:
                return self._datos[0]
            return None

        @property
        def vacia(self):
            return len(self._datos) == 0

        def __len__(self):
            return len(self._datos)
    ```
  ]
]

#slide[
  = Cola de impresión

  #codigo-pasos((4, 7, 9))[
    ```python
    cola_impresion = Cola()
    cola_impresion.insertar("documento1.pdf")
    cola_impresion.insertar("documento2.docx")
    cola_impresion.insertar("documento3.xlsx")

    while not cola_impresion.vacia:
        print(f"Imprimiendo {cola_impresion.extraer()}...")

    print(cola_impresion.vacia)
    ```
  ]

  #uncover("4-")[
    ```text
      Imprimiendo documento1.pdf...
      Imprimiendo documento2.docx...
      Imprimiendo documento3.xlsx...
      True
      ```
  ]
]

#slide[
  = Atención de llamadas

  Simulamos un centro de llamadas con clientes en espera.

  #item-by-item[
    - Si llega una llamada, la agregamos al final de la cola.
    - Si hay alguien disponible, atendemos la primera llamada.
    - Si no ocurre ninguna de las dos cosas, esperamos.
  ]

  #uncover("4-")[
    #v(0.5em)
    #link("../teoria/04_estructuras_lineales/imgs/02/cola_llamadas.webm")[Ver la simulación del apunte ↗]
  ]
]

#slide[
  = Atención de llamadas

  El núcleo de la simulación:

  #codigo-pasos((2, 7, 10, 12))[
    ```python
    accion = random.random()
    ahora = datetime.now().strftime("%H:%M:%S")

    if accion < 0.5:
        llamada = {"cliente": random.choice(nombres), "hora": ahora}
        cola.insertar(llamada)
        print(f"[{ahora}] Nueva llamada de {llamada['cliente']}")
    elif accion < 0.9 and not cola.vacia:
        llamada = cola.extraer()
        print(f"[{ahora}] Atendiendo a {llamada['cliente']}")
    else:
        print(f"[{ahora}] Sin actividad...")
    ```
  ]

  #uncover("5-")[
    La cola conserva el orden de llegada de las llamadas.
  ]
]

#slide[
  = Por qué usar estructuras de datos restringidas

  Si para implementar una pila restringimos un arreglo...

  #pause

  #highlight-box[
    ¿Por qué no usar directamente el arreglo?
  ]
]

#slide[
  = Por qué usar estructuras de datos restringidas

  #item-by-item[
    - *Evitar errores*: solo permitimos las operaciones que corresponden.
    - *Un modelo mental claro*: LIFO o FIFO orientan la solución.
    - *Código más legible*: quien ve una pila sabe en qué orden salen los datos.
  ]
]

#new-section-slide[Listas enlazadas]

#slide[
  = Listas enlazadas

  Otra forma de mantener los elementos en un cierto orden.

  #pause

  - Un arreglo guarda los datos en una región contigua de memoria.
  - Una lista enlazada puede distribuirlos en distintas ubicaciones.

  #pause

  ¿Cómo reconstruimos la secuencia si los elementos están separados?
]

#nodos-vista()

#slide[
  = El nodo

  #codigo-pasos((4, 7, 10))[
    ```python
    class Nodo:
        def __init__(self, valor):
            self.valor = valor
            self.siguiente = None

        def __repr__(self):
            return f"Nodo({self.valor})"

    Nodo(75)
    # Nodo(75)
    ```
  ]

  #uncover("4-")[
    Los enlaces entre nodos dan nombre a la *lista enlazada*.
  ]
]

#slide[
  = El nodo

  Creamos cuatro nodos independientes:

  ```python
  nodo1 = Nodo(30)
  nodo2 = Nodo(10)
  nodo3 = Nodo(75)
  nodo4 = Nodo(25)
  ```

  #pause

  Los enlazamos:

  ```python
  nodo1.siguiente = nodo2
  nodo2.siguiente = nodo3
  nodo3.siguiente = nodo4
  ```

  El último nodo conserva `siguiente = None`.
]

#slide[
  = El nodo

  Para recorrerlos, seguimos los enlaces:

  #codigo-pasos((1, 4, 5))[
    ```python
    actual = nodo1
    while actual:
        print(actual, end=" -> ")
        actual = actual.siguiente
    print("None")
    ```
  ]

  #uncover("4-")[
    ```text
      Nodo(30) -> Nodo(10) -> Nodo(75) -> Nodo(25) -> None
      ```
  ]
]

#slide[
  = Implementación básica

  Solo necesitamos guardar una referencia al primer nodo.

  #codigo-pasos((3, 5))[
    ```python
    class ListaEnlazada:
        def __init__(self, primer_nodo=None):
            self.primer_nodo = primer_nodo

    lista = ListaEnlazada(nodo1)
    ```
  ]

  #uncover("3-")[
    Desde allí, podemos reconstruir toda la secuencia siguiendo los enlaces.
  ]
]

#lista-vista()

#memoria-inicial()

#slide[
  = Lectura

  Leer una dirección conocida de memoria sigue siendo $O(1)$.

  #pause

  Pero ahora no podemos calcular la dirección de un elemento usando su índice.

  #pause

  #highlight-box[
    Conocemos la dirección del primer nodo. Para llegar a los demás, tenemos que seguir los enlaces.
  ]
]

#lista-lectura()

#slide[
  = Lectura

  Con $N$ elementos, leer el último requiere recorrer toda la lista.

  - Lectura en un arreglo: $O(1)$.
  - Lectura por índice en una lista enlazada: $O(N)$.

  #pause

  No son todas pálidas... Pronto vamos a ver sus puntos fuertes.
]

// Los métodos se muestran como miembros de ListaEnlazada.
// Se validan índices y listas vacías para evitar acceder a atributos de None.
#slide[
  = Lectura

  #codigo-pasos((3, 5, 9, 12, 13))[
    ```python
        def leer(self, indice):
            if indice < 0:
                return None
            nodo_actual = self.primer_nodo
            indice_actual = 0

            while nodo_actual is not None and indice_actual < indice:
                nodo_actual = nodo_actual.siguiente
                indice_actual += 1

            if nodo_actual is None:
                return None
            return nodo_actual.valor
    ```
  ]

  #uncover("6-")[
    Si no existe ese índice, devolvemos `None`.
  ]
]

#slide[
  = Búsqueda

  En lugar de recibir un índice y devolver un valor, recibimos un valor y devolvemos su índice.

  #item-by-item[
    - Comparamos el valor buscado con el del primer nodo.
    - Si coincide, devolvemos el índice.
    - Si no coincide, avanzamos al siguiente nodo.
    - Si llegamos al final, el valor no está en la lista.
  ]
]

#lista-busqueda()

#slide[
  = Búsqueda

  #codigo-pasos((3, 7, 9, 11))[
    ```python
        def buscar(self, valor):
            nodo_actual = self.primer_nodo
            indice_actual = 0

            while nodo_actual is not None:
                if nodo_actual.valor == valor:
                    return indice_actual
                nodo_actual = nodo_actual.siguiente
                indice_actual += 1

            return None
    ```
  ]

  #uncover("5-")[
    En el peor caso recorremos $N$ nodos: $O(N)$, igual que la búsqueda lineal en un arreglo.
  ]
]

#slide[
  = Inserción

  Hasta ahora, el desempeño es igual o peor que el de un arreglo.

  #pause

  ¿Qué pasa si queremos insertar al inicio?

  #pause

  - En un arreglo, desplazamos todos los elementos.
  - En una lista enlazada, creamos un nodo y actualizamos enlaces.
]

#lista-insercion-inicio()

#slide[
  = Inserción

  Insertar al inicio requiere una cantidad constante de operaciones.

  ```python
  nodo_nuevo = Nodo(valor)
  nodo_nuevo.siguiente = self.primer_nodo
  self.primer_nodo = nodo_nuevo
  ```

  #pause

  #highlight-box[
    No desplazamos los demás elementos: insertar al inicio es $O(1)$.
  ]
]

#lista-insercion-medio()

#memoria-insercion()

#lista-insercion-final()

#slide[
  = Inserción

  // El método completo entra en una slide con código ligeramente más chico.
  #show raw.where(block: true): set text(size: 11.5pt)

  #codigo-pasos((4, 9, 12, 16, 19, 21))[
    ```python
        def insertar(self, indice, valor):
            if indice < 0:
                raise IndexError("Índice fuera de rango")
            nodo_nuevo = Nodo(valor)

            if indice == 0:
                nodo_nuevo.siguiente = self.primer_nodo
                self.primer_nodo = nodo_nuevo
                return None

            nodo_actual = self.primer_nodo
            indice_actual = 0

            while nodo_actual is not None and indice_actual < (indice - 1):
                nodo_actual = nodo_actual.siguiente
                indice_actual += 1

            if nodo_actual is None:
                raise IndexError("Índice fuera de rango")
            nodo_nuevo.siguiente = nodo_actual.siguiente
            nodo_actual.siguiente = nodo_nuevo
    ```
  ]
]

#slide[
  = Eliminación

  También consiste en actualizar enlaces.

  #pause

  Para eliminar al inicio:

  ```python
  self.primer_nodo = self.primer_nodo.siguiente
  ```

  #pause

  El segundo nodo pasa a ser el primero. El costo es $O(1)$.
]

#lista-eliminacion()

#slide[
  = Eliminación

  // El método completo entra en una slide con código ligeramente más chico.
  #show raw.where(block: true): set text(size: 11.5pt)

  #codigo-pasos((3, 7, 10, 14, 17, 19))[
    ```python
        def eliminar(self, indice):
            if indice < 0 or self.primer_nodo is None:
                raise IndexError("Índice fuera de rango")

            if indice == 0:
                self.primer_nodo = self.primer_nodo.siguiente
                return None

            nodo_actual = self.primer_nodo
            indice_actual = 0

            while nodo_actual is not None and indice_actual < (indice - 1):
                nodo_actual = nodo_actual.siguiente
                indice_actual += 1

            if nodo_actual is None or nodo_actual.siguiente is None:
                raise IndexError("Índice fuera de rango")
            nodo_siguiente_al_eliminado = nodo_actual.siguiente.siguiente
            nodo_actual.siguiente = nodo_siguiente_al_eliminado
    ```
  ]
]

#slide[
  = Enlazando las partes

  Nuestra clase `ListaEnlazada` reúne los métodos que acabamos de definir.

  ```python
  lista = ListaEnlazada(nodo1)  # 30 -> 10 -> 75 -> 25
  lista.leer(3)               # 25
  lista.buscar(75)            # 2
  ```

  #pause

  ```python
  lista.insertar(2, 50)       # 30 -> 10 -> 50 -> 75 -> 25
  lista.leer(2)               # 50
  lista.eliminar(2)           # 30 -> 10 -> 75 -> 25
  lista.leer(2)               # 75
  ```
]

#slide[
  = Análisis de la eficiencia

  #table(
    columns: (1.2fr, 1fr, 1fr),
    inset: 10pt,
    stroke: rgb("#c8e6c9"),
    fill: (x, y) => if y == 0 { rgb("#e0f2e1") },
    [*Operación*], [*Arreglo*], [*Lista enlazada*],
    [Lectura], [$O(1)$], [$O(N)$],
    [Búsqueda], [$O(N)$], [$O(N)$],
    [Inserción], [$O(N)$], [$O(N)$],
    [Eliminación], [$O(N)$], [$O(N)$],
  )

  #pause

  - Arreglo: insertar y eliminar al final es $O(1)$.\*
  - Lista enlazada: insertar y eliminar al inicio es $O(1)$.

  #text(size: 0.65em)[\*En un arreglo dinámico, la inserción al final es $O(1)$ amortizado.]
]

#slide[
  = Análisis de la eficiencia

  Entonces... ¿por qué usaríamos una lista enlazada?

  #pause

  #highlight-box[
    Si ya conocemos el nodo anterior, insertar o eliminar solo requiere actualizar enlaces: $O(1)$.
  ]

  #pause

  El costo de recorrer la lista es distinto del costo de modificar los enlaces.
]

#slide[
  = Análisis de la eficiencia

  Por ejemplo, queremos eliminar elementos erróneos de una secuencia.

  #item-by-item[
    - Tenemos que recorrerla tanto con un arreglo como con una lista enlazada.
    - En el arreglo, cada eliminación puede desplazar muchos elementos.
    - En la lista enlazada, conservando el nodo anterior, actualizamos los enlaces sin desplazar valores.
  ]
]

#new-section-slide[Listas doblemente enlazadas]

#slide[
  = Listas doblemente enlazadas

  En una lista enlazada simple, cada nodo conoce al siguiente.

  #pause

  En una lista doblemente enlazada, cada nodo tiene dos referencias:

  - Una al nodo anterior.
  - Otra al nodo siguiente.

  #pause

  La lista mantiene referencias tanto al primer nodo como al último.
]

#slide[
  = Listas doblemente enlazadas

  #codigo-pasos((5, 11))[
    ```python
    class Nodo:
        def __init__(self, valor):
            self.valor = valor
            self.anterior = None
            self.siguiente = None


    class ListaDoblementeEnlazada:
        def __init__(self, primer_nodo=None, ultimo_nodo=None):
            self.primer_nodo = primer_nodo
            self.ultimo_nodo = ultimo_nodo
    ```
  ]
]

#doble-operaciones()

#slide[
  = Listas doblemente enlazadas

  Conocemos ambos extremos de la secuencia.

  #item-by-item[
    - Accedemos al primer o al último nodo en $O(1)$.
    - Insertamos o eliminamos al inicio en $O(1)$.
    - También insertamos o eliminamos al final en $O(1)$.
  ]

  #uncover("4-")[
    #highlight-box[
      Los enlaces al nodo anterior permiten retroceder desde el último.
    ]
  ]
]

#slide[
  = Pilas como una lista enlazada

  El primer nodo representa la cima de la pila.

  #pause

  - Insertar: agregamos un nuevo primer nodo.
  - Extraer: hacemos que el segundo nodo pase a ser el primero.
  - Ambas operaciones son $O(1)$.

  #pause

  #highlight-box[
    La misma pila, con el mismo comportamiento LIFO, puede tener distintas implementaciones.
  ]
]

#pila-enlazada-operaciones()

#slide[
  = Pilas como una lista enlazada

  Con un arreglo dinámico, agregar al final puede requerir ampliar su capacidad y copiar los elementos.

  #pause

  Con una lista enlazada no necesitamos un nuevo bloque contiguo para toda la pila.

  #pause

  #highlight-box(title: [_Trade-offs_...])[
    Evitamos copiar toda la secuencia al crecer, pero cada nodo también necesita memoria para su enlace.
  ]
]

#slide[
  = Colas con una lista doblemente enlazada

  Podemos insertar al final y extraer desde el inicio en $O(1)$.

  #pause

  En la cola basada en un arreglo:

  - Insertar al final es $O(1)$ amortizado.
  - Extraer del inicio es $O(N)$: desplazamos los elementos restantes.

  #pause

  La implementación concreta afecta el costo de las operaciones.
]

#cola-enlazada-operaciones()

#slide[
  = Colas con una lista doblemente enlazada

  ¿Necesitamos siempre enlaces en ambas direcciones?

  #pause

  Una lista simplemente enlazada también sirve si mantiene una referencia al último nodo.

  #pause

  - Agregamos al final usando esa referencia.
  - Extraemos desde el primer nodo.
  - Ambas operaciones son $O(1)$.
]

#inverted-slide("Gracias")
