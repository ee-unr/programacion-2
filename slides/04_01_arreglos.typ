#import "@preview/touying:0.6.3": *
#import "template.typ": setup-template, new-section-slide, inverted-slide, highlight-box

#show: setup-template.with(
  title: [Programación II],
  subtitle: [Arreglos],
  header-label: [Unidad 4],
  footer-label: [Arreglos],
  author: [Tomás Capretto],
  institution: [FCEyE · Universidad Nacional de Rosario]
)

// Cada elemento acepta una ruta de imagen o contenido Typst entre corchetes.
// Cada elemento ocupa una página. Las imágenes conservan un recuadro fijo
// y el contenido Typst usa el flujo normal de la slide.
#let assets = "../teoria/04_estructuras_lineales/imgs/01/"
#let figure-slide(title, file, caption: [], height: 270pt, max-width: 100%, caption-size: 0.8em) = slide[
  = #title
  #if type(file) == str {
    block(width: 100%, height: height)[
      #align(center + horizon)[
        #let path = if file.starts-with("imgs/") { file } else { assets + file }
        #image(path, width: max-width, height: height, fit: "contain")
      ]
    ]
  } else {
    file
  }
  #v(0.4em)
  #text(size: caption-size)[
    #caption
  ]
]
#let sequence(title, frames, max-width: 100%, caption-size: 0.95em) = {
  for frame in frames {
    figure-slide(title, frame.at(0), caption: frame.at(1), max-width: max-width, caption-size: caption-size)
  }
}

#new-section-slide[Introducción]

#slide[
  = ¿Cuál es mejor?
  Queremos imprimir todos los números pares entre 2 y 100...

  #pause

  #components.side-by-side(gutter: 1cm)[
    ```python
    numero = 2
    while numero <= 100:
        if numero % 2 == 0:
            print(numero)
        numero += 1
    ```
    #uncover(4)[*99 iteraciones*]
  ][
    ```python
    numero = 2
    while numero <= 100:
        print(numero)
        numero += 2
    ```
    #uncover(4)[*50 iteraciones*]
  ]

  #pause

  #align(center)[¿Qué hace que un algoritmo sea mejor que otro?]
]

#slide[
  = Algunos criterios...

  - Mantenibilidad
  - Legibilidad
  - Organización
  - Eficiencia
    - Velocidad
    - Memoria
]

#new-section-slide[Estructuras de datos]

#slide[
  = Data, data, data

  #components.side-by-side(gutter: 1cm, columns: (1.5fr, 2fr))[
    ```python
    x = "¡Hola! "
    y = "¿Cómo estás? "
    z = "¿Todo bien?"

    print(x + y + z)
    ```
  ][
    #pause
    ```python
    arreglo = [
      "¡Hola! ", "¿Cómo estás? ", "¿Todo bien?"
    ]

    print(arreglo[0] + arreglo[1] + arreglo[2])
    ```
  ]

  #pause

  #v(0.5em)

  #align(center)[#text(1.2em)[¿Cuál es mejor?]]

  #pause

  #v(1em)

  #highlight-box(title: [_Trade-offs_...])[
    No existe una única forma de organizar los datos de un programa.

    No solo afecta cómo se ve, también puede afectar su velocidad.
  ]

]


#slide[
  = Una estructura familiar: Arreglos

  Colección de datos en un orden determinado.

  #pause

  En Python, listas:

  ```python
  array = ["nueces", "almendras", "pistachos", "maníes", "castañas"]
  ```
  #pause

  - Tamaño (_size_): cuántos elementos contiene.
  - Índice (_index_): identifica la posición de cada elemento en él.

  #pause

  #align(center)[#image("../teoria/04_estructuras_lineales/imgs/01/arreglo-con_indice.png")]

]


#slide[
  = ¿Qué tan buena es una estructura?

  Medimos su desempeño para realizar diferentes operaciones:

  - *Lectura* (_read_): obtener el valor de una posición.
  - *Búsqueda* (_search_): encontrar la posición de un valor.
  - *Inserción* (_insert_): agregar un elemento.
  - *Eliminación* (_delete_): quitar un elemento.

  #pause

  Algo ya conocemos...

  ```python
  array[indice]               # Lectura
  array.index(valor)          # Búsqueda
  array.insert(indice, valor) # Inserción
  array.pop(indice)           # Eliminación por índice
  array.remove(valor)         # Eliminación por valor
  ```
]

#slide[
  = #text(size: 0.95em)[¿Cómo se mide la velocidad de una operación?]

  #item-by-item[
    - No se mide el tiempo con un reloj.
      - Puede variar de computadora a computadora.
    - Se cuenta la *cantidad de pasos*.
      - Medimos costo independientemente de donde se ejecutan.
    - El conteo se hace en relación a la cantidad de elementos $N$.
  ]

  #uncover("4")[
    #highlight-box(title: [La pregunta])[
      ¿Cómo cambia la cantidad de pasos a realizar a medida que crece la cantidad de elementos $N$?
    ]
  ]

]

#slide[
  = Lectura

  Acceder al valor almacenado en una posición específica del arreglo.

  ```python
  array[indice]
  ```

  #pause

  Por ejemplo:

  ```python
  array = [30, 10, 15, 25, 85]
  array[4]  # Devuelve 85
  ```

  #pause

  La memoria RAM permite acceder directamente a cualquier posición sin recorrer las anteriores.
]

#sequence([¿Por qué esto es posible?], (
  ("memoria_layout-basico.png", [Podemos imaginar la memoria como una colección de celdas numeradas.]),
  ("memoria_layout-con_direcciones.png", [Cada celda tiene una dirección única.]),
  ("memoria_layout-con_vector.png", [La computadora reserva un bloque contiguo de celdas para el arreglo.]),
  ("memoria_layout-con_direcciones_resaltadas.png", [Cinco posiciones del arreglo ocupan cinco celdas consecutivas.]),
))

#slide[
  = ¿Por qué esto es posible?

  En este modelo simplificado, la dirección se calcula con una operación aritmética simple:

  ```text
  dirección_base + i
  ```

  #pause

  - Cada celda puede leerse o modificarse en el mismo tiempo.
  - Ese tiempo es independiente de su posición.
  - De ahí el nombre *memoria de acceso aleatorio*.
]

#figure-slide([Lectura], "arreglo-con_indice_y_direccion.png", caption: [El índice indica la posición del elemento y la dirección, su ubicación en memoria.])

#slide[
  = Lectura

  Queremos leer el valor en el índice 3 de nuestro arreglo de frutos secos.

  #item-by-item[
    - El índice 0 está en la dirección 1010.
    - El índice 3 está tres posiciones después.
    - Su dirección es 1013 (1010 + 3).
    - Allí podemos acceder al valor #raw("\"maníes\"").
  ]

  #uncover("5-")[
    #highlight-box[
      Leer desde un arreglo permite acceder a cualquier elemento en un solo paso.
    ]
  ]
]

#slide[
  = El tamaño de cada elemento

  En la memoria real, las direcciones se miden en bytes.

  - Cada elemento puede ocupar varios bytes.
  - Para calcular su dirección, tenemos en cuenta ese tamaño.

  ```text
  dirección_base + i * tamaño_del_elemento
  ```

  #pause

  Por ejemplo, con una dirección inicial de 1000 y elementos de 8 bytes:

  - Las posiciones comienzan en 1000, 1008, 1016, 1024...
  - El índice 3 está en 1000 + 3 × 8 = 1024.
]

#slide[
  = Búsqueda

  Comprobar si un valor existe y, de ser así, obtener su índice.

  #pause

  - Leer: dar un índice y obtener un valor.
  - Buscar: dar un valor y obtener su índice.

  #pause

  La computadora debe revisar las celdas una por una hasta encontrar el valor.
]

#sequence([Búsqueda], (
  ("arreglo_busqueda-paso_0.png", [Buscamos #raw("\"pistachos\"") en nuestro arreglo de frutos secos.]),
  ("arreglo_busqueda-paso_1.png", [Primero revisamos el índice 0.]),
  ("arreglo_busqueda-paso_2.png", [Encontramos #raw("\"nueces\""). Avanzamos al siguiente índice.]),
  ("arreglo_busqueda-paso_3.png", [Encontramos #raw("\"pistachos\"") en el índice 2. La búsqueda tomó tres pasos.]),
))

#slide[
  = Búsqueda

  A esta forma de revisar las celdas una por una la llamamos *búsqueda lineal*.

  #item-by-item[
    - Si encontramos el valor, la búsqueda termina.
    - Si está al final o no aparece, recorremos todo el arreglo.
    - Con 5 elementos, podemos necesitar hasta 5 pasos.
    - Con $N$ elementos, podemos necesitar hasta $N$ pasos.
  ]
]

#slide[
  = Inserción

  La eficiencia depende del lugar donde se realice la inserción.

  #pause

  Queremos agregar #raw("\"pasas\"") al final de nuestra lista de frutos secos.

  - Conocemos la dirección inicial y el tamaño del arreglo.
  - Si comienza en 1010 y tiene 5 elementos, el último está en 1014.
  - El nuevo elemento ocupa la posición 1015, si hay capacidad disponible.
]

#figure-slide([Inserción], "arreglo_insercion-al_final.png", caption: [Una vez calculada la posición, la inserción al final requiere un paso.])

#slide[
  = Inserción

  Si el bloque reservado solo tiene cinco celdas, agregar un sexto elemento requiere ampliar su capacidad.

  #pause

  Insertar al inicio o en el medio requiere desplazar elementos para dejar espacio.

  Por ejemplo, queremos insertar #raw("\"pasas\"") en el índice 2.
]

#sequence([Inserción], (
  ("arreglo_insercion-al_medio.png", [Debemos mover #raw("\"pistachos\""), #raw("\"maníes\"") y #raw("\"castañas\"") una posición a la derecha.]),
  ("arreglo_insercion-al_medio_1.png", [Primero movemos #raw("\"castañas\"") una celda a la derecha.]),
  ("arreglo_insercion-al_medio_2.png", [Luego movemos #raw("\"maníes\"") a la derecha.]),
  ("arreglo_insercion-al_medio_3.png", [Por último, movemos #raw("\"pistachos\"") y liberamos el índice 2.]),
  ("arreglo_insercion-al_medio_4.png", [Insertamos #raw("\"pasas\"") en el espacio disponible.]),
  ("arreglo_insercion-al_medio_5.png", [El arreglo tiene longitud 6 y #raw("\"pasas\"") ocupa el índice 2.]),
))

#slide[
  = Inserción

  En este ejemplo usamos cuatro pasos:

  - Tres para mover datos.
  - Uno para agregar el nuevo valor.

  #pause

  #v(1em)

  #highlight-box(title: [El peor caso])[
    El peor caso ocurre al insertar al inicio: desplazamos los $N$ elementos y luego insertamos.

    En total, $N + 1$ pasos.
  ]
]

#slide[
  = Eliminación

  Quitar el valor ubicado en un índice determinado.

  #pause

  Eliminemos el índice 1, que corresponde a #raw("\"almendras\"").

  - La eliminación deja una celda vacía.
  - Debemos mover los elementos posteriores una posición a la izquierda.
]

#sequence([Eliminación], (
  ("arreglo_eliminacion-al_medio_0.png", [Eliminamos el valor del índice 1.]),
  ("arreglo_eliminacion-al_medio_1.png", [Queda una celda vacía en el medio del arreglo.]),
  ("arreglo_eliminacion-al_medio_2.png", [Movemos #raw("\"pistachos\"") una posición a la izquierda.]),
  ("arreglo_eliminacion-al_medio_3.png", [Continuamos moviendo los elementos posteriores.]),
  ("arreglo_eliminacion-al_medio_4.png", [El arreglo pasa de cinco elementos a cuatro.]),
), max-width: 75%)

#slide[
  = Eliminación

  En este ejemplo usamos cuatro pasos:

  - Uno para borrar el valor.
  - Tres para desplazar los datos.

  #pause

  #highlight-box(title: [El peor caso])[
    El peor caso ocurre al eliminar el primer elemento: borramos un valor y desplazamos los $N - 1$ restantes.

    En total, hasta $N$ pasos.
  ]
]

#slide[
  = Conjuntos

  Un conjunto puede implementarse de diferentes maneras.

  #pause

  Consideremos un *conjunto basado en arreglos*: un arreglo que no permite valores duplicados.

  - Lectura, búsqueda y eliminación funcionan como en los arreglos.
  - La diferencia aparece en la inserción.
]

#slide[
  = Conjuntos

  Antes de agregar un valor, verificamos que no exista en el conjunto.

  #pause

  ```python
  ["Ana", "Bruno", "Carla", "Diego", "Elena"]
  ```

  Queremos agregar a `"Francisco"`.
  
  Primero tenemos que comprobar que no esté ya inscripto.
]

#sequence([Conjuntos], (
  ("arreglo_conjunto_insercion-paso_0.png", [Inspeccionamos los elementos uno a uno.]),
  ("arreglo_conjunto_insercion-paso_1.png", [Buscamos una coincidencia con #raw("\"Francisco\"").]),
  ("arreglo_conjunto_insercion-paso_2.png", [Si no encontramos el valor, seguimos avanzando.]),
  ("arreglo_conjunto_insercion-paso_3.png", [La búsqueda continúa por el arreglo.]),
  ("arreglo_conjunto_insercion-paso_4.png", [Revisamos todo el conjunto y sabemos que #raw("\"Francisco\"") está ausente.]),
  ("arreglo_conjunto_insercion-paso_5.png", [Ahora podemos insertar el nuevo valor.]),
))

#slide[
  = Conjuntos

  - Insertar al final requiere $N$ pasos para buscar y uno para insertar.
  - Insertar al inicio también requiere desplazar los $N$ elementos.

  #pause
  
  #v(1em)

  #highlight-box(title: [Contando pasos])[
    Al final: $N + 1$ pasos.

    Al inicio: $2N + 1$ pasos.
  ]
]

#new-section-slide[Algoritmos]

#slide[
  = Algoritmos

  Un conjunto de pasos definidos para realizar una tarea.

  Por ejemplo, preparar un mate:

  #item-by-item[
    + Calentar el agua.
    + Colocar la yerba en el mate.
    + Insertar la bombilla.
    + Servir el agua con cuidado.
  ]
]

#slide[
  = Algoritmos

  #item-by-item[

  - La estructura de datos afecta el rendimiento del código.
  - El algoritmo que usamos también influye en su eficiencia.
  - Distintos algoritmos pueden resolver la misma tarea con eficiencias distintas.

  ]

  #v(1em)

  #uncover(4)[
    Ya vimos un ejemplo al imprimir números pares.

    Ahora vamos a trabajar con arreglos ordenados.
  ]

]

#slide[
  = Arreglos ordenados

  Los valores deben mantenerse siempre en orden.

  #pause

  ```python
  [6, 21, 38, 95]
  ```

  Queremos insertar el valor #raw("30").

  - En un arreglo común podríamos agregarlo al final.
  - En uno ordenado debemos ubicarlo en la posición correcta.
]

#sequence([Arreglos ordenados], (
  ("arreglo_ordenado-intento_insercion.png", [Agregar el 30 al final rompe el orden.]),
  ("arreglo_ordenado-insercion_correcta.png", [El 30 debe quedar entre el 21 y el 38.]),
), max-width: 70%)

#slide[
  = Arreglos ordenados

  La computadora debe:

  #item-by-item[
    + Encontrar dónde insertar el nuevo valor.
    + Desplazar los demás valores para crear espacio.
  ]
]

#sequence([Arreglos ordenados], (
  ("arreglo_ordenado-arreglo.png", [Partimos del arreglo ordenado original.]),
  ("arreglo_ordenado-paso_0.png", [Comparamos el 30 con el valor del índice 0.]),
  ("arreglo_ordenado-paso_1.png", [El 30 es mayor que el 6 y el 21. Seguimos avanzando.]),
  ("arreglo_ordenado-paso_2.png", [El 38 es mayor que el 30: debemos insertar a su izquierda.]),
  ("arreglo_ordenado-paso_3.png", [Necesitamos desplazar los datos y dejar espacio.]),
  ("imgs/arreglo_ordenado_desplazamiento-1.png", [Movemos el 95 una posición a la derecha.]),
  ("imgs/arreglo_ordenado_desplazamiento-2.png", [Queda espacio a la derecha del 38.]),
  ("imgs/arreglo_ordenado_desplazamiento-3.png", [Movemos el 38 y liberamos la posición para el 30.]),
  ("imgs/arreglo_ordenado_desplazamiento-4.png", [Insertamos el 30 en la posición correspondiente.]),
), max-width: 70%)

#slide[
  = Arreglos ordenados

  En nuestro ejemplo, la inserción tomó 6 pasos.

  - Cerca del inicio: menos comparaciones y más desplazamientos.
  - Cerca del final: más comparaciones y menos desplazamientos.

  #pause

  #highlight-box[
    La inserción requiere buscar primero la posición correcta y luego crear el espacio para el nuevo valor.
  ]
]

#slide[
  = Búsqueda en arreglos ordenados

  Buscamos el valor #raw("21").

  En un arreglo clásico, puede estar en cualquier posición:

  ```python
  [67, 25, 13, 6, 132]
  ```

  #pause

  En un arreglo ordenado podemos detenernos al llegar al #raw("25"):

  ```python
  [6, 13, 25, 67, 132]
  ```
]

#slide[
  = Búsqueda en arreglos ordenados

  ```python
  def busqueda_lineal(array, valor):
      for indice, elemento in enumerate(array):
          if elemento == valor:
              return indice
          elif elemento > valor:
              break
      return None
  ```

  #pause

  ```python
  print(busqueda_lineal([6, 13, 25, 67, 132], 21))
  # None
  ```
]

#slide[
  = Búsqueda en arreglos ordenados

  - La búsqueda termina cuando el elemento actual es mayor que el buscado.
  - En ciertos casos, revisamos menos posiciones que en un arreglo clásico.
  - En el peor caso, podemos necesitar hasta $N$ pasos.

  #pause

  La gran ventaja del orden es que permite aplicar otro algoritmo: la *búsqueda binaria*.
]

#slide[
  = Búsqueda binaria

  Alguien piensa un número entre 1 y 100 y vos tenés que adivinarlo.

  Después de cada intento, te dicen si es mayor o menor.

  #item-by-item[
    - Probamos con la mitad: el 50.
    - Si es mayor, podemos probar con 75. Si es menor, con 25.
    - En cada paso elegimos el punto medio y reducimos las posibilidades a la mitad.
  ]
]

#sequence([Búsqueda binaria], (
  ("arreglo_ordenado_busqueda-paso_0.png", [Tenemos nueve elementos ordenados y buscamos el valor 15.]),
  ("arreglo_ordenado_busqueda-paso_1.png", [Inspeccionamos el centro y encontramos el 11.]),
  ("arreglo_ordenado_busqueda-paso_2.png", [El 15 está a su derecha. Descartamos la mitad izquierda, incluido el 11.]),
  ("arreglo_ordenado_busqueda-paso_3.png", [Inspeccionamos el centro de la mitad restante. El valor es mayor que 15.]),
  ("arreglo_ordenado_busqueda-paso_4.png", [Quedan dos valores posibles y elegimos el de la derecha.]),
  ("arreglo_ordenado_busqueda-paso_5.png", [Encontramos el 15 en la última celda posible.]),
))

#slide[
  = Búsqueda binaria

  - Encontramos el 15 en cuatro pasos.
  - Con búsqueda lineal habríamos necesitado seis.
  - La búsqueda binaria funciona sobre arreglos ordenados.

  #pause

  En un arreglo desordenado no sabríamos hacia qué lado seguir buscando.
]

#slide[
  = Búsqueda binaria

  ```python
  def busqueda_binaria(array, valor):
      limite_inferior = 0
      limite_superior = len(array) - 1
      while limite_inferior <= limite_superior:
          punto_medio = (limite_inferior + limite_superior) // 2
          valor_en_punto_medio = array[punto_medio]

          if valor == valor_en_punto_medio:
              return punto_medio
          elif valor < valor_en_punto_medio:
              limite_superior = punto_medio - 1
          elif valor > valor_en_punto_medio:
              limite_inferior = punto_medio + 1
      return None

  print(busqueda_binaria([3, 17, 75, 80, 202], 22))
  # None
  ```
]


#slide[
  = Búsqueda lineal vs. búsqueda binaria

  Con arreglos pequeños, la búsqueda binaria no tiene mucha ventaja.

  Al aumentar el tamaño, la diferencia se vuelve notable.

  #item-by-item(start: 2)[
    - Con 100 elementos: hasta 100 pasos frente a 7.
    - La búsqueda lineal duplica el trabajo al duplicar el tamaño.
    - La binaria agrega un paso más.
    - Con 10.000 elementos, la binaria necesita hasta 14 pasos. Con un millón, 20.
  ]
]

#slide[
  = Búsqueda lineal vs. búsqueda binaria

  #align(center + horizon)[
    #image("../teoria/04_estructuras_lineales/imgs/01/busqueda_lineal_vs_binaria.png")
  ]

]

#slide[
  = Nada es gratis

  Cuando es posible, la búsqueda binaria es mucho más eficiente que la búsqueda lineal.

  #pause

  ¿Cuál es el costo asociado?

  #pause

  En un arreglo ordenado, la búsqueda es barata, pero la inserción es cara.

  #pause

  #highlight-box[
    ¿Harás muchas búsquedas o muchas inserciones?
  ]
]

#new-section-slide[_Big_ O]

#slide[
  = _Big_ O

  La cantidad de pasos depende del tamaño del problema.

  - Con 35 elementos, una búsqueda lineal puede requerir 35 pasos.
  - Con 200 elementos, puede requerir 200.

  #pause

  En lugar de un número fijo, hablamos de $N$ pasos para $N$ elementos.

  La notación _Big_ O permite describir y comparar la eficiencia de los algoritmos.
]

#slide[
  = _Big_ O: es relativo

  Comparamos cómo crece la cantidad de pasos al aumentar la cantidad de elementos $N$.

  #pause

  - Búsqueda lineal: hasta $N$ pasos → $O(N)$, tiempo lineal.
  - Lectura por índice: un paso para cualquier tamaño → $O(1)$, tiempo constante.

  #pause

  #highlight-box[
    En $O(1)$, el costo es independiente de la cantidad de elementos $N$.
  ]
]

#slide[
  = _Big_ O: lo que realmente importa

  #highlight-box(title: [La pregunta])[
    ¿Cómo crece la cantidad de pasos del algoritmo a medida que aumenta la cantidad de elementos $N$?
  ]

  #pause

  - Un algoritmo que siempre realiza tres pasos tiene costo constante.
  - Lo expresamos como $O(1)$, igual que si siempre realizara un solo paso.
  - Nos interesa cómo cambia el trabajo al aumentar el tamaño del problema.
]

#figure-slide([_Big_ O: lo que realmente importa], "complejidad_constante_vs_lineal.png", caption: [En este ejemplo, $N$ pasos crecen con los datos y un paso se mantiene constante.], height: 280pt)

#slide[
  = _Big_ O: lo que realmente importa

  Imaginemos un algoritmo que siempre toma 20 pasos.

  #pause

  #highlight-box[
    ¿Es más o menos eficiente que uno que realiza $N$ pasos?
  ]
]

#figure-slide([_Big_ O: lo que realmente importa], "complejidad_constante_20_vs_lineal.png", caption: [Comparamos un algoritmo de 20 pasos constantes con otro de $N$ pasos.], height: 280pt)

#slide[
  = _Big_ O: lo que realmente importa

  #item-by-item[
    - Con menos de 20 elementos, el algoritmo de $N$ pasos hace menos trabajo.
    - Con 20 elementos, ambos realizan la misma cantidad de pasos.
    - A partir de ahí, el de $N$ pasos requiere cada vez más trabajo.
  ]
]

#slide[
  = _Big_ O pesimista

  El costo de la búsqueda lineal depende de dónde se encuentra el valor buscado.

  - Mejor caso: primera posición → $O(1)$.
  - Peor caso: última posición o valor ausente → $O(N)$.

  #pause

  #highlight-box[
    Big O puede aplicarse al mejor caso, al promedio o al peor caso.

    Hablaremos del peor caso, salvo que se indique lo contrario.
  ]
]

#slide[
  = Un tercer tipo de complejidad

  En la búsqueda binaria, el número de pasos aumenta con los datos, pero más lentamente que en la búsqueda lineal.

  #pause

  - Con 100 elementos, necesita como máximo 7 intentos.
  - Una cota ajustada es $O(log N)$.
  - Se lee “O de log N” y corresponde al tiempo logarítmico.
  - Duplicar los datos agrega como máximo un intento al peor caso.
]

#figure-slide([Un tercer tipo], "complejidad_constante_lineal_logaritmica.png", caption: [Comparamos el crecimiento constante, lineal y logarítmico.], height: 280pt)

#slide[
  = Intuición detrás de $O(log N)$

  Reducimos el problema a la mitad en cada paso:

  $ 8 -> 4 -> 2 -> 1 $

  #item-by-item[
    - Con 8 elementos, hacen falta tres divisiones para llegar a uno.
    - Con 16 elementos, una división más.
    - Con 32 elementos, otra más.
    - El logaritmo en base 2 cuenta esas divisiones.
  ]
]

#slide[
  = Intuición detrás de $O(log N)$

  #table(
    columns: (1fr, 1fr, 1fr),
    inset: 10pt,
    stroke: rgb("#c8e6c9"),
    fill: (x, y) => if y == 0 { rgb("#e0f2e1") },
    [*Elementos*], [$N$], [$log_2 N$],
    [8], [8], [3],
    [16], [16], [4],
    [128], [128], [7],
    [1024], [1024], [10],
  )

  #pause

  Cada vez que se duplica la cantidad de datos, agregamos una etapa de reducción.
]

#slide[
  = Complejidad cuadrática

  Queremos verificar si un arreglo de enteros contiene números repetidos.

  ```python
  [1, 5, 3, 9, 1, 4]
  ```

  #pause

  Una primera idea: usar bucles anidados.

  ```python
  def contiene_duplicados(array):
      for i in range(len(array)):
          for j in range(len(array)):
              if (i != j) and (array[i] == array[j]):
                  return True
      return False

  contiene_duplicados([1, 5, 3, 9, 4, 6])     # False
  contiene_duplicados([1, 5, 3, 9, 1, 4, 6])  # True
  ```

]

#slide[
  = Complejidad cuadrática

  ¿Cuántos pasos realiza la función en el peor escenario?

  #item-by-item(start: 2)[
    - El peor caso ocurre cuando todos los valores son distintos.
    - El bucle externo se ejecuta $N$ veces.
    - Dentro de cada iteración, el segundo bucle se ejecuta $N$ veces.
    - En total: $N times N = N^2$ iteraciones.
  ]

  #uncover("5-")[
    #highlight-box[
      Complejidad $O(N^2)$, también conocida como tiempo cuadrático.
    ]
  ]
]

#slide[
  = Bucles anidados

  #highlight-box[
    Con frecuencia, aunque no siempre, un bucle dentro de otro tiene complejidad $O(N^2)$.
  ]
]

#slide[
  = Solución lineal

  ¿Existe una alternativa más eficiente?

  #pause

  Consideremos calificaciones enteras de productos, de 0 a 10.

  - Conocemos de antemano los valores posibles.
  - Podemos usar un arreglo auxiliar con una posición para cada calificación.
  - Realizamos como máximo un recorrido de la entrada.
]

#slide[
  = Solución lineal

  ```python
  def contiene_duplicados_lineal(array):
      valores_existentes = [0] * 11

      for i in range(len(array)):
          if valores_existentes[array[i]] == 1:
              return True
          else:
              valores_existentes[array[i]] = 1

      return False
  ```

  #pause

  ```python
  contiene_duplicados_lineal([1, 5, 3, 9, 4, 6])     # False
  contiene_duplicados_lineal([1, 5, 3, 9, 1, 4, 6])  # True
  ```
]

#slide[
  = Solución lineal

  El arreglo #raw("valores_existentes") comienza con once ceros.

  Por ejemplo, si la entrada es #raw("[3, 5, 8]", lang: "python"):

  #item-by-item[
    - Al encontrar el 3: #raw("[0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]", lang: "python").
    - Al encontrar el 5: #raw("[0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0]", lang: "python").
    - Al encontrar el 8: #raw("[0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0]", lang: "python").
  ]
]

#slide[
  = Solución lineal

  #item-by-item[
    - Si la posición ya contiene un #raw("1"), encontramos un duplicado y devolvemos #raw("True").
    - Si completamos el recorrido, devolvemos #raw("False").
    - Cada iteración realiza una cantidad constante de operaciones.
    - Para $N$ elementos, realizamos *hasta $N$ iteraciones*.
  ]

  #uncover("5-")[
    #highlight-box[
      $O(N)$ es una cota superior de su complejidad temporal.
    ]
  ]
]

#slide[
  = Letra chica

  - Esta implementación supone valores enteros entre 0 y 10.
  - Con más de once elementos, necesariamente aparecen duplicados.
  - Se revisan como máximo doce elementos: $O(1)$ es una cota más ajustada.
  - El arreglo auxiliar consume memoria adicional.
]

#slide[
  = Resumen de complejidades

  Vimos ejemplos de complejidad constante, lineal, logarítmica y cuadrática.

  Otros ejemplos:

  - Lineal-logarítmica: $O(N log N)$.
  - Cúbica: $O(N^3)$.
  - Exponencial: $O(2^N)$.
  - Factorial: $O(N!)$.
]

#slide[
  = Resumen de complejidades

  #align(center + horizon)[#image("../teoria/04_estructuras_lineales/imgs/01/resumen_complejidades.png")]
]

#inverted-slide("Gracias")
