// Simple numbering for non-book documents
#let equation-numbering = "(1)"
#let callout-numbering = "1"
#let subfloat-numbering(n-super, subfloat-idx) = {
  numbering("1a", n-super, subfloat-idx)
}

// Theorem configuration for theorion
// Simple numbering for non-book documents (no heading inheritance)
#let theorem-inherited-levels = 0

// Theorem numbering format (can be overridden by extensions for appendix support)
// This function returns the numbering pattern to use
#let theorem-numbering(loc) = "1.1"

// Default theorem render function
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title.]
    h(0.5em)
  }
  body
}
// Some definitions presupposed by pandoc's typst output.
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let fields = old_block.fields()
  let _ = fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => {
          let subfloat-idx = quartosubfloatcounter.get().first() + 1
          subfloat-numbering(n-super, subfloat-idx)
        })
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => block({
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          })

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let children = old_title_block.body.body.children
  let old_title = if children.len() == 1 {
    children.at(0)  // no icon: title at index 0
  } else {
    children.at(1)  // with icon: title at index 1
  }

  // TODO use custom separator if available
  // Use the figure's counter display which handles chapter-based numbering
  // (when numbering is a function that includes the heading counter)
  let callout_num = it.counter.display(it.numbering)
  let new_title = if empty(old_title) {
    [#kind #callout_num]
  } else {
    [#kind #callout_num: #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(
      old_title_block.body,
      if children.len() == 1 {
        new_title  // no icon: just the title
      } else {
        children.at(0) + new_title  // with icon: preserve icon block + new title
      }))

  align(left, block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1)))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color,
        width: 100%,
        inset: 8pt)[#if icon != none [#text(icon_color, weight: 900)[#icon] ]#title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}


// syntax highlighting functions from skylighting:
/* Function definitions for syntax highlighting generated by skylighting: */
#let EndLine() = raw("\n")
#let Skylighting(fill: none, number: false, start: 1, sourcelines) = {
   let blocks = []
   let lnum = start - 1
   let bgcolor = rgb("#f1f3f5")
   for ln in sourcelines {
     if number {
       lnum = lnum + 1
       blocks = blocks + box(width: if start + sourcelines.len() > 999 { 30pt } else { 24pt }, text(fill: rgb("#aaaaaa"), [ #lnum ]))
     }
     blocks = blocks + ln + EndLine()
   }
   block(fill: bgcolor, blocks)
}
#let AlertTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let AnnotationTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let AttributeTok(s) = text(fill: rgb("#657422"),raw(s))
#let BaseNTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let BuiltInTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let CharTok(s) = text(fill: rgb("#20794d"),raw(s))
#let CommentTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let CommentVarTok(s) = text(style: "italic",fill: rgb("#5e5e5e"),raw(s))
#let ConstantTok(s) = text(fill: rgb("#8f5902"),raw(s))
#let ControlFlowTok(s) = text(weight: "bold",fill: rgb("#003b4f"),raw(s))
#let DataTypeTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let DecValTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let DocumentationTok(s) = text(style: "italic",fill: rgb("#5e5e5e"),raw(s))
#let ErrorTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let ExtensionTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let FloatTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let FunctionTok(s) = text(fill: rgb("#4758ab"),raw(s))
#let ImportTok(s) = text(fill: rgb("#00769e"),raw(s))
#let InformationTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let KeywordTok(s) = text(weight: "bold",fill: rgb("#003b4f"),raw(s))
#let NormalTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let OperatorTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let OtherTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let PreprocessorTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let RegionMarkerTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let SpecialCharTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let SpecialStringTok(s) = text(fill: rgb("#20794d"),raw(s))
#let StringTok(s) = text(fill: rgb("#20794d"),raw(s))
#let VariableTok(s) = text(fill: rgb("#111111"),raw(s))
#let VerbatimStringTok(s) = text(fill: rgb("#20794d"),raw(s))
#let WarningTok(s) = text(style: "italic",fill: rgb("#5e5e5e"),raw(s))



#let article(
  title: none,
  subtitle: none,
  authors: none,
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  // Set document metadata for PDF accessibility
  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(author => content-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()
  set par(
    justify: true,
    leading: linestretch * 0.65em
  )
  set text(lang: lang,
           region: region,
           size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none

  set heading(numbering: sectionnumbering)

  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(content-to-string(citecolor))) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: rgb(content-to-string(filecolor)))
    } else {
      text(this)
    }
   }

  let has-title-block = title != none or (authors != none and authors != ()) or date != none or abstract != none
  if has-title-block {
    place(
      top,
      float: true,
      scope: "parent",
      clearance: 4mm,
      block(below: 1em, width: 100%)[

        #if title != none {
          align(center, block(inset: 2em)[
            #set par(leading: heading-line-height) if heading-line-height != none
            #set text(font: heading-family) if heading-family != none
            #set text(weight: heading-weight)
            #set text(style: heading-style) if heading-style != "normal"
            #set text(fill: heading-color) if heading-color != black

            #text(size: title-size)[#title #if thanks != none {
              footnote(thanks, numbering: "*")
              counter(footnote).update(n => n - 1)
            }]
            #(if subtitle != none {
              parbreak()
              text(size: subtitle-size)[#subtitle]
            })
          ])
        }

        #if authors != none and authors != () {
          let count = authors.len()
          let ncols = calc.min(count, 3)
          grid(
            columns: (1fr,) * ncols,
            row-gutter: 1.5em,
            ..authors.map(author =>
                align(center)[
                  #author.name \
                  #author.affiliation \
                  #author.email
                ]
            )
          )
        }

        #if date != none {
          align(center)[#block(inset: 1em)[
            #date
          ]]
        }

        #if abstract != none {
          block(inset: 2em)[
          #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
          ]
        }
      ]
    )
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  doc
}

#set table(
  inset: 6pt,
  stroke: none
)
#show image: it => block(sticky: true, it)
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
  columns: 1,
)

#show: doc => article(
  title: [3 - Grafos],
  lang: "es",
  sectionnumbering: "1.1.a",
  toc: true,
  toc_title: [Tabla de contenidos],
  toc_depth: 3,
  doc,
)

= Descripción de un grafo
<descripción-de-un-grafo>
En la introducción de la unidad representamos ciudades conectadas por vuelos. Podíamos consultar destinos directos, pero también viajar a otra ciudad pasando por lugares intermedios. Ahora vamos a guardar esas conexiones en Python y escribir operaciones para consultarlas, modificarlas y recorrer la red.

Para seguir los ejemplos con más facilidad, vamos a conservar seis ciudades de aquella red: Rosario, Salta, Córdoba, Mendoza, San Pablo y Ushuaia. Quitamos Buenos Aires y Lima junto con sus conexiones. Trabajaremos con las conexiones que quedan entre las ciudades elegidas, tratadas en ambos sentidos. Seguimos usando el modelo de la introducción, sin considerar horarios, precios ni distancias.

#figure([
#box(image("imgs/03/red.svg", alt: "Rosario conecta con Salta y San Pablo. Salta conecta también con Córdoba y Mendoza. Córdoba conecta con Mendoza y San Pablo. Mendoza conecta con San Pablo y San Pablo con Ushuaia. Las conexiones no tienen dirección.", width: 65%))
], caption: figure.caption(
position: bottom, 
[
Red de seis ciudades y ocho conexiones.
]), 
kind: "quarto-float-fig", 
supplement: "Figura", 
)


Un #strong[grafo] (#emph[graph]) está formado por #strong[vértices] (#emph[vertices]), también llamados nodos, y #strong[aristas] (#emph[edges]) que los conectan. En este ejemplo, cada ciudad es un vértice y cada conexión directa es una arista.

Podemos describir el dibujo con algunos términos:

#table(
  columns: (7.03%, 57.81%, 35.16%),
  align: (auto,auto,auto,),
  table.header([Término], [Qué indica], [Ejemplo],),
  table.hline(),
  [Vecinos], [Vértices unidos por una arista], [Salta y San Pablo son vecinos de Rosario],
  [Camino], [Una sucesión de vértices unidos por aristas], [Rosario, Salta, Mendoza],
  [Ciclo], [Un camino que vuelve al inicio sin repetir aristas ni los demás vértices], [Rosario, Salta, Mendoza, San Pablo, Rosario],
)
En este grafo, un ciclo incluye al menos tres vértices distintos. Por ejemplo, Rosario--Salta--Mendoza--San Pablo--Rosario vuelve al punto de partida sin repetir aristas ni otros vértices. Ir de Rosario a Salta y volver por la misma arista no forma un ciclo.

No hay una conexión directa entre Rosario y Mendoza, pero podemos llegar pasando por Salta o por San Pablo. Es decir, hay distintos caminos entre las mismas ciudades.

#figure([
#box(image("imgs/03/camino.svg", alt: "Se destacan los enlaces Rosario–Salta y Salta–Mendoza dentro de la misma red.", width: 65%))
], caption: figure.caption(
position: bottom, 
[
Camino de Rosario a Mendoza pasando por Salta.
]), 
kind: "quarto-float-fig", 
supplement: "Figura", 
)


A diferencia de los árboles con raíz que estudiamos, esta red no tiene una raíz ni relaciones de padres e hijos. Para recorrerla podemos elegir cualquier ciudad como origen. También podemos volver a una ciudad por otro camino, algo que tendremos que considerar al programar.

En este apunte usamos un grafo #strong[no dirigido], porque cada conexión se puede seguir en ambos sentidos. En un grafo #strong[dirigido], una conexión de un vértice a otro no implica que exista la conexión inversa. Nuestro ejemplo solamente registra qué ciudades están conectadas.

= Representación en Python
<representación-en-python>
En la introducción guardamos las conexiones como pares. Para esta red, la lista sería:

#Skylighting(([#NormalTok("conexiones ");#OperatorTok("=");#NormalTok(" [");],
[#NormalTok("    (");#StringTok("\"Rosario\"");#NormalTok(", ");#StringTok("\"Salta\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"Rosario\"");#NormalTok(", ");#StringTok("\"San Pablo\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"Salta\"");#NormalTok(", ");#StringTok("\"Córdoba\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"Salta\"");#NormalTok(", ");#StringTok("\"Mendoza\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"Córdoba\"");#NormalTok(", ");#StringTok("\"Mendoza\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"Córdoba\"");#NormalTok(", ");#StringTok("\"San Pablo\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"Mendoza\"");#NormalTok(", ");#StringTok("\"San Pablo\"");#NormalTok("),");],
[#NormalTok("    (");#StringTok("\"San Pablo\"");#NormalTok(", ");#StringTok("\"Ushuaia\"");#NormalTok("),");],
[#NormalTok("]");],));
Esta lista permite guardar las aristas, pero para encontrar todos los vecinos de una ciudad tenemos que revisar los pares y comprobar en cuál de sus dos posiciones aparece. Por ejemplo, San Pablo aparece como segundo elemento en varios pares y como primero en otro.

Podemos representar cada ciudad con un objeto que guarde su valor y referencias a sus vecinos. Como los nodos del árbol, estos objetos se conectan entre sí, pero ahora pueden tener cualquier cantidad de vecinos. Vamos a llamarlos #NormalTok("Vertice"); (#emph[vertex] en inglés):

#Skylighting(([#KeywordTok("class");#NormalTok(" Vertice:");],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" ");#FunctionTok("__init__");#NormalTok("(");#VariableTok("self");#NormalTok(", valor):");],
[#NormalTok("        ");#VariableTok("self");#NormalTok(".valor ");#OperatorTok("=");#NormalTok(" valor");],
[#NormalTok("        ");#VariableTok("self");#NormalTok(".vecinos ");#OperatorTok("=");#NormalTok(" []");],));
La lista #NormalTok("vecinos"); contiene referencias a otros objetos #NormalTok("Vertice");, no sus nombres. Esta representación se conoce como #strong[listas de adyacencia] (#emph[adjacency lists]). Primero creamos un objeto por ciudad:

#Skylighting(([#NormalTok("rosario ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Rosario\"");#NormalTok(")");],
[#NormalTok("salta ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Salta\"");#NormalTok(")");],
[#NormalTok("cordoba ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Córdoba\"");#NormalTok(")");],
[#NormalTok("mendoza ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Mendoza\"");#NormalTok(")");],
[#NormalTok("san_pablo ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"San Pablo\"");#NormalTok(")");],
[#NormalTok("ushuaia ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Ushuaia\"");#NormalTok(")");],));
Para conectar los vértices, agregamos el método #NormalTok("conectar"); a la clase #NormalTok("Vertice");. Guardamos la referencia en ambos sentidos porque el grafo es no dirigido:

#Skylighting(([#NormalTok("    ");#KeywordTok("def");#NormalTok(" conectar(");#VariableTok("self");#NormalTok(", otro):");],
[#NormalTok("        ");#ControlFlowTok("if");#NormalTok(" otro ");#KeywordTok("not");#NormalTok(" ");#KeywordTok("in");#NormalTok(" ");#VariableTok("self");#NormalTok(".vecinos:");],
[#NormalTok("            ");#VariableTok("self");#NormalTok(".vecinos.append(otro)");],
[#NormalTok("            otro.vecinos.append(");#VariableTok("self");#NormalTok(")");],));
Ahora podemos construir las conexiones de la red:

#Skylighting(([#NormalTok("rosario.conectar(san_pablo)");],
[#NormalTok("rosario.conectar(salta)");],
[#NormalTok("san_pablo.conectar(ushuaia)");],
[#NormalTok("salta.conectar(cordoba)");],
[#NormalTok("salta.conectar(mendoza)");],
[#NormalTok("cordoba.conectar(mendoza)");],
[#NormalTok("cordoba.conectar(san_pablo)");],
[#NormalTok("mendoza.conectar(san_pablo)");],));
#NormalTok("rosario.vecinos[0]"); referencia al mismo objeto que #NormalTok("san_pablo");. Desde allí podemos seguir sus referencias hasta Ushuaia, Córdoba o Mendoza. Así, desde un solo vértice podemos descubrir toda la parte de la red conectada con él.

Cada ciudad se representa una sola vez, aunque varios vértices la tengan como vecina. Lo que se repite son las referencias: una por cada sentido de la arista. Esto permite compartir los datos del vértice sin copiarlos en cada vecino.

El orden de los vecinos no cambia qué conexiones existen, pero sí puede cambiar el orden de un recorrido. Vamos a conservar el orden de estas listas para que el código y las figuras produzcan los mismos resultados. Desde Rosario empezaremos por San Pablo, y desde San Pablo visitaremos primero Ushuaia. Como Ushuaia no tiene otros vecinos, DFS tendrá que volver para continuar por otra rama.

== Matriz de adyacencia
<matriz-de-adyacencia>
También podemos representar las conexiones con una #strong[matriz de adyacencia] (#emph[adjacency matrix]). Asignamos una fila y una columna a cada ciudad, en el mismo orden. Un #NormalTok("1"); indica que existe una arista desde la ciudad de la fila hacia la de la columna. Un #NormalTok("0"); indica que no existe esa conexión directa.

Usamos este orden para las filas y las columnas: Rosario, Salta, Córdoba, Mendoza, San Pablo y Ushuaia. La matriz de adyacencia es:

$ A = mat(delim: "(", 0, 1, 0, 0, 1, 0; 1, 0, 1, 1, 0, 0; 0, 1, 0, 1, 1, 0; 0, 1, 1, 0, 1, 0; 1, 0, 1, 1, 0, 1; 0, 0, 0, 0, 1, 0) $

En la primera fila, el #NormalTok("1"); de la segunda columna representa la conexión Rosario--Salta. La segunda fila también tiene un #NormalTok("1"); en la primera columna porque la conexión se puede seguir en ambos sentidos. Esto ocurre con todas las aristas: como el grafo es no dirigido, la matriz es #strong[simétrica] respecto de su diagonal principal. La diagonal tiene ceros porque no conectamos una ciudad consigo misma.

Los grafos dirigidos también se pueden representar con matrices. En ese caso, un #NormalTok("1"); en la primera fila y la segunda columna no obliga a tener un #NormalTok("1"); en la segunda fila y la primera columna.

La matriz permite comprobar una conexión consultando una sola celda, en $O\(1\)$, pero reserva $V^2$ posiciones si hay $V$ vértices, aunque existan pocas aristas. Las listas de adyacencia ocupan $O\(V + E\)$, donde $E$ es la cantidad de aristas, y permiten recorrer directamente los vecinos de una ciudad. Para comprobar una conexión, en cambio, hay que buscar el destino dentro de la lista de vecinos del origen.

En Python podríamos guardar la matriz con listas de listas o con un arreglo de NumPy. Para las operaciones y los recorridos vamos a seguir usando los objetos #NormalTok("Vertice"); y sus referencias.

= Operaciones básicas
<operaciones-básicas>
Vamos a consultar y modificar los enlaces entre vértices. Suponemos que no conectamos un vértice consigo mismo y usamos #NormalTok("conectar"); y #NormalTok("desconectar"); para conservar las referencias en ambos sentidos.

== Consultar vecinos y conexiones
<consultar-vecinos-y-conexiones>
Para consultar los vecinos directos de Rosario accedemos a #NormalTok("rosario.vecinos");. Si queremos mostrar sus nombres, leemos el atributo #NormalTok("valor"); de cada uno:

#Skylighting(([#BuiltInTok("print");#NormalTok("([vecino.valor ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" rosario.vecinos])");],
[#BuiltInTok("print");#NormalTok("(salta ");#KeywordTok("in");#NormalTok(" rosario.vecinos)");],
[#BuiltInTok("print");#NormalTok("(mendoza ");#KeywordTok("in");#NormalTok(" rosario.vecinos)");],));
#Skylighting(([#NormalTok("['San Pablo', 'Salta']");],
[#NormalTok("True");],
[#NormalTok("False");],));
El último resultado solamente indica que no hay una arista entre Rosario y Mendoza. Para saber si podemos llegar mediante conexiones intermedias necesitaremos recorrer el grafo.

== Agregar un vértice
<agregar-un-vértice>
Agregar una ciudad consiste en crear un objeto:

#Skylighting(([#NormalTok("parana ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Paraná\"");#NormalTok(")");],
[#BuiltInTok("print");#NormalTok("(parana.vecinos)");],));
#Skylighting(([#NormalTok("[]");],));
Paraná ya es un vértice, pero está aislado. No podemos descubrirlo siguiendo los enlaces desde Rosario.

== Agregar y quitar una arista
<agregar-y-quitar-una-arista>
Para conectar Rosario con Paraná usamos #NormalTok("conectar");:

#Skylighting(([#NormalTok("rosario.conectar(parana)");],
[#BuiltInTok("print");#NormalTok("([vecino.valor ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" rosario.vecinos])");],
[#BuiltInTok("print");#NormalTok("([vecino.valor ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" parana.vecinos])");],));
#Skylighting(([#NormalTok("['San Pablo', 'Salta', 'Paraná']");],
[#NormalTok("['Rosario']");],));
El método agrega Paraná a los vecinos de Rosario y Rosario a los de Paraná. La comprobación evita repetir la arista si llamamos otra vez al método. Para quitarla, agregamos el método #NormalTok("desconectar"); a #NormalTok("Vertice");. Elimina las dos referencias:

#Skylighting(([#NormalTok("    ");#KeywordTok("def");#NormalTok(" desconectar(");#VariableTok("self");#NormalTok(", otro):");],
[#NormalTok("        ");#ControlFlowTok("if");#NormalTok(" otro ");#KeywordTok("in");#NormalTok(" ");#VariableTok("self");#NormalTok(".vecinos:");],
[#NormalTok("            ");#VariableTok("self");#NormalTok(".vecinos.remove(otro)");],
[#NormalTok("            otro.vecinos.remove(");#VariableTok("self");#NormalTok(")");],));
Lo usamos sobre los mismos vértices:

#Skylighting(([#NormalTok("rosario.desconectar(parana)");],
[#BuiltInTok("print");#NormalTok("([vecino.valor ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" rosario.vecinos])");],
[#BuiltInTok("print");#NormalTok("(parana.vecinos)");],));
#Skylighting(([#NormalTok("['San Pablo', 'Salta']");],
[#NormalTok("[]");],));
Paraná vuelve a quedar aislado. El objeto sigue existiendo porque la variable #NormalTok("parana"); lo referencia. Para quitar todas las conexiones de un vértice, agregamos el método #NormalTok("aislar");:

#Skylighting(([#NormalTok("    ");#KeywordTok("def");#NormalTok(" aislar(");#VariableTok("self");#NormalTok("):");],
[#NormalTok("        ");#CommentTok("# Copiamos la lista porque desconectar modifica los vecinos");],
[#NormalTok("        ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" ");#VariableTok("self");#NormalTok(".vecinos.copy():");],
[#NormalTok("            ");#VariableTok("self");#NormalTok(".desconectar(vecino)");],));
Por ejemplo:

#Skylighting(([#NormalTok("rosario.conectar(parana)");],
[#NormalTok("parana.aislar()");],
[#BuiltInTok("print");#NormalTok("(parana ");#KeywordTok("in");#NormalTok(" rosario.vecinos)");],
[#BuiltInTok("print");#NormalTok("(parana.vecinos)");],));
#Skylighting(([#NormalTok("False");],
[#NormalTok("[]");],));
El método recorre una copia de la lista de vecinos para poder modificar los enlaces mientras avanza. Al terminar, ningún otro vértice tiene una referencia a Paraná en su lista de vecinos.

= Recorridos
<recorridos>
Supongamos que queremos listar todas las ciudades a las que podemos llegar desde Rosario, incluida la ciudad de origen. Tenemos que seguir sus conexiones y las de sus vecinos. Pero, a diferencia del árbol, seguir un enlace puede llevarnos a un vértice que ya visitamos.

Por ejemplo, desde Rosario podemos ir a Salta y desde Salta volver a Rosario. Si llamáramos de nuevo a la función sin registrar las visitas, repetiríamos las mismas llamadas indefinidamente.

Para evitarlo vamos a guardar los vértices descubiertos en un conjunto llamado #NormalTok("visitados");. Antes de continuar hacia un vecino comprobaremos si ya está registrado. Además, usaremos una lista #NormalTok("orden"); para conservar el orden del resultado. Ambas colecciones guardan objetos #NormalTok("Vertice");: el conjunto permite consultar si una ciudad ya apareció y la lista permite recordar cuándo la incorporamos. Para mostrar los nombres, usamos sus atributos #NormalTok("valor");.

Vamos a comparar dos recorridos sobre el grafo original de seis ciudades. En las figuras, el verde indica que una ciudad ya está registrada en #NormalTok("visitados"); y el borde verde oscuro marca la ciudad actual. A la derecha aparecen el resultado y las llamadas activas o la cola de pendientes.

== Recorrido en profundidad
<recorrido-en-profundidad>
El #strong[recorrido en profundidad] (#emph[depth-first search], DFS) avanza hacia un vecino nuevo y continúa desde él antes de revisar los siguientes vecinos del vértice anterior. Cuando no quedan vecinos nuevos, vuelve a la llamada anterior. Podemos implementarlo con recursión, como hicimos con los árboles.

=== DFS paso a paso
<dfs-paso-a-paso>
Empezamos desde Rosario y agregamos cada ciudad al resultado al entrar a su llamada. La columna de llamadas muestra el camino actual, con la llamada más reciente abajo.

#block[
#box(image("imgs/03/dfs-1.svg", alt: "Todavía no visitamos ninguna ciudad. El resultado y las llamadas activas están vacíos.", width: 85%))

Todavía no visitamos ninguna ciudad. \ El resultado y las llamadas activas están vacíos.

#box(image("imgs/03/dfs-2.svg", alt: "Visitamos Rosario y lo agregamos al resultado. Su primer vecino es San Pablo.", width: 85%))

Visitamos Rosario y lo agregamos al resultado. \ Su primer vecino es San Pablo.

#box(image("imgs/03/dfs-3.svg", alt: "Registramos San Pablo. Rosario ya está visitado. Seguimos hacia Ushuaia.", width: 85%))

Registramos San Pablo. Rosario ya está visitado. \ Seguimos hacia Ushuaia.

#box(image("imgs/03/dfs-4.svg", alt: "Registramos Ushuaia. San Pablo ya está visitado. Sin más vecinos, esta llamada termina.", width: 85%))

Registramos Ushuaia. San Pablo ya está visitado. \ Sin más vecinos, esta llamada termina.

#box(image("imgs/03/dfs-5.svg", alt: "Volvemos a San Pablo y retomamos su lista de vecinos. El siguiente vecino nuevo es Córdoba.", width: 85%))

Volvemos a San Pablo y retomamos su lista de vecinos. \ El siguiente vecino nuevo es Córdoba.

#box(image("imgs/03/dfs-6.svg", alt: "Registramos Córdoba. San Pablo ya está visitado. Seguimos hacia Salta.", width: 85%))

Registramos Córdoba. San Pablo ya está visitado. \ Seguimos hacia Salta.

#box(image("imgs/03/dfs-7.svg", alt: "Registramos Salta. Rosario y Córdoba ya se visitaron. Seguimos hacia Mendoza.", width: 85%))

Registramos Salta. Rosario y Córdoba ya se visitaron. \ Seguimos hacia Mendoza.

#box(image("imgs/03/dfs-8.svg", alt: "Registramos Mendoza. Sus vecinos ya están visitados. Esta llamada termina.", width: 85%))

Registramos Mendoza. Sus vecinos ya están visitados. \ Esta llamada termina.

#box(image("imgs/03/dfs-9.svg", alt: "Volvemos a Salta. No quedan vecinos pendientes. Su llamada termina.", width: 85%))

Volvemos a Salta. No quedan vecinos pendientes. \ Su llamada termina.

#box(image("imgs/03/dfs-10.svg", alt: "Volvemos a Córdoba. Mendoza y San Pablo se visitaron. Su llamada termina.", width: 85%))

Volvemos a Córdoba. Mendoza y San Pablo se visitaron. \ Su llamada termina.

#box(image("imgs/03/dfs-11.svg", alt: "Volvemos a San Pablo. Mendoza ya está visitado. Su llamada termina.", width: 85%))

Volvemos a San Pablo. Mendoza ya está visitado. \ Su llamada termina.

#box(image("imgs/03/dfs-12.svg", alt: "Volvemos a Rosario. Salta ya está visitada. Su llamada termina.", width: 85%))

Volvemos a Rosario. Salta ya está visitada. \ Su llamada termina.

#box(image("imgs/03/dfs-13.svg", alt: "Ya no hay llamadas activas. Devolvemos la lista completa.", width: 85%))

Ya no hay llamadas activas. \ Devolvemos la lista completa.

] <grafos-dfs>
Al volver de Ushuaia, la llamada de San Pablo retoma su #NormalTok("for"); y continúa hacia Córdoba. Por eso Córdoba aparece después de Ushuaia en el resultado, aunque no haya una arista entre ellas: el recorrido volvió a San Pablo antes de avanzar por otra rama.

=== Implementación de DFS
<implementación-de-dfs>
#Skylighting(([#KeywordTok("def");#NormalTok(" dfs(origen):");],
[#NormalTok("    visitados ");#OperatorTok("=");#NormalTok(" ");#BuiltInTok("set");#NormalTok("()");],
[#NormalTok("    orden ");#OperatorTok("=");#NormalTok(" []");],
[],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" visitar(actual):");],
[#NormalTok("        ");#CommentTok("# Registramos el vértice antes de seguir sus conexiones");],
[#NormalTok("        visitados.add(actual)");],
[#NormalTok("        orden.append(actual)");],
[],
[#NormalTok("        ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" actual.vecinos:");],
[#NormalTok("            ");#ControlFlowTok("if");#NormalTok(" vecino ");#KeywordTok("not");#NormalTok(" ");#KeywordTok("in");#NormalTok(" visitados:");],
[#NormalTok("                visitar(vecino)");],
[],
[#NormalTok("    visitar(origen)");],
[#NormalTok("    ");#ControlFlowTok("return");#NormalTok(" orden");],));
La función interna #NormalTok("visitar"); comparte #NormalTok("visitados"); y #NormalTok("orden"); entre todas las llamadas. Cuando encuentra un vecino nuevo, la llamada recursiva se completa antes de que el #NormalTok("for"); continúe con el siguiente.

Si el recorrido requiere muchas llamadas anidadas, esta versión puede superar el límite de recursión de Python y producir un #NormalTok("RecursionError");. Una implementación con una pila explícita evita ese límite.

#Skylighting(([#BuiltInTok("print");#NormalTok("([vertice.valor ");#ControlFlowTok("for");#NormalTok(" vertice ");#KeywordTok("in");#NormalTok(" dfs(rosario)])");],));
#Skylighting(([#NormalTok("['Rosario', 'San Pablo', 'Ushuaia', 'Córdoba', 'Salta', 'Mendoza']");],));
El resultado depende del orden de las listas de vecinos, aunque las conexiones sean las mismas.

== Recorrido en anchura
<recorrido-en-anchura>
Ahora queremos procesar primero todos los vecinos directos de Rosario y después los que vamos descubriendo desde ellos. Para lograrlo, en lugar de continuar inmediatamente desde cada vecino, lo guardamos al final de una cola.

El #strong[recorrido en anchura] (#emph[breadth-first search], BFS) usa esa cola para recordar los pendientes. La primera ciudad que entra es la primera que sale.

=== BFS paso a paso
<bfs-paso-a-paso>
Empezamos registrando Rosario en #NormalTok("visitados"); y agregándolo a la cola. En cada paso sacamos una ciudad, la agregamos al resultado y revisamos sus vecinos. Los vecinos nuevos se registran y se agregan al final de la cola. En la figura, la próxima ciudad en salir está arriba.

#block[
#box(image("imgs/03/bfs-1.svg", alt: "Registramos Rosario y lo ponemos en la cola. Todavía no hay ciudades en el resultado.", width: 85%))

Registramos Rosario y lo ponemos en la cola. \ Todavía no hay ciudades en el resultado.

#box(image("imgs/03/bfs-2.svg", alt: "Sacamos Rosario. Registramos San Pablo y Salta. Los encolamos en ese orden.", width: 85%))

Sacamos Rosario. Registramos San Pablo y Salta. \ Los encolamos en ese orden.

#box(image("imgs/03/bfs-3.svg", alt: "Sacamos San Pablo. Rosario ya está registrado. Registramos y encolamos Ushuaia, Córdoba y Mendoza.", width: 85%))

Sacamos San Pablo. Rosario ya está registrado. \ Registramos y encolamos Ushuaia, Córdoba y Mendoza.

#box(image("imgs/03/bfs-4.svg", alt: "Sacamos Salta. Sus vecinos ya están registrados. No agregamos ciudades a la cola.", width: 85%))

Sacamos Salta. Sus vecinos ya están registrados. \ No agregamos ciudades a la cola.

#box(image("imgs/03/bfs-5.svg", alt: "Sacamos Ushuaia. San Pablo ya está registrado. En la cola quedan Córdoba y Mendoza.", width: 85%))

Sacamos Ushuaia. San Pablo ya está registrado. \ En la cola quedan Córdoba y Mendoza.

#box(image("imgs/03/bfs-6.svg", alt: "Sacamos Córdoba. Sus vecinos ya están registrados. En la cola solo queda Mendoza.", width: 85%))

Sacamos Córdoba. Sus vecinos ya están registrados. \ En la cola solo queda Mendoza.

#box(image("imgs/03/bfs-7.svg", alt: "Sacamos Mendoza. Sus vecinos ya están registrados. La cola queda vacía y el recorrido termina.", width: 85%))

Sacamos Mendoza. Sus vecinos ya están registrados. \ La cola queda vacía y el recorrido termina.

] <grafos-bfs>
Al procesar Salta, Córdoba y Mendoza ya están registrados aunque todavía esperen en la cola. Si esperáramos a registrarlos hasta sacarlos, podríamos encolarlos de nuevo desde Salta. Por eso registramos cada vértice cuando lo agregamos a la cola.

=== Implementación de BFS
<implementación-de-bfs>
Usamos #NormalTok("deque");, del módulo #NormalTok("collections"); de Python, como cola. Con #NormalTok("append"); agregamos un vértice al final y con #NormalTok("popleft"); sacamos el primero:

#Skylighting(([#ImportTok("from");#NormalTok(" collections ");#ImportTok("import");#NormalTok(" deque");],
[],
[],
[#KeywordTok("def");#NormalTok(" bfs(origen):");],
[#NormalTok("    ");#CommentTok("# Registramos cada vértice al agregarlo a la cola");],
[#NormalTok("    visitados ");#OperatorTok("=");#NormalTok(" {origen}");],
[#NormalTok("    cola ");#OperatorTok("=");#NormalTok(" deque([origen])");],
[#NormalTok("    orden ");#OperatorTok("=");#NormalTok(" []");],
[],
[#NormalTok("    ");#ControlFlowTok("while");#NormalTok(" cola:");],
[#NormalTok("        actual ");#OperatorTok("=");#NormalTok(" cola.popleft()");],
[#NormalTok("        orden.append(actual)");],
[],
[#NormalTok("        ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" actual.vecinos:");],
[#NormalTok("            ");#ControlFlowTok("if");#NormalTok(" vecino ");#KeywordTok("not");#NormalTok(" ");#KeywordTok("in");#NormalTok(" visitados:");],
[#NormalTok("                visitados.add(vecino)");],
[#NormalTok("                cola.append(vecino)");],
[],
[#NormalTok("    ");#ControlFlowTok("return");#NormalTok(" orden");],));
Después de procesar Rosario, en la cola quedan San Pablo y Salta, en ese orden. Sacamos San Pablo con #NormalTok("popleft"); y agregamos Ushuaia, Córdoba y Mendoza al final. El próximo turno sigue siendo de Salta. El recorrido termina cuando la cola queda vacía. Las figuras muestran los nombres de los vértices que esperan en ella.

La cola #NormalTok("cola"); guarda los vértices pendientes de procesar, mientras que la lista #NormalTok("orden"); guarda los que ya procesamos, en el orden en que salieron de la cola. Al terminar, la cola queda vacía y devolvemos la lista con el resultado.

Como ejercicio, podemos reemplazar #NormalTok("deque"); por una clase #NormalTok("Cola"); propia, con operaciones para encolar y desencolar como las que vimos en la Unidad 4.

#Skylighting(([#BuiltInTok("print");#NormalTok("([vertice.valor ");#ControlFlowTok("for");#NormalTok(" vertice ");#KeywordTok("in");#NormalTok(" bfs(rosario)])");],));
#Skylighting(([#NormalTok("['Rosario', 'San Pablo', 'Salta', 'Ushuaia', 'Córdoba', 'Mendoza']");],));
== Comparación de los recorridos
<comparación-de-los-recorridos>
Los dos recorridos alcanzan las mismas ciudades desde un mismo origen:

#table(
  columns: (15%, 40%, 45%),
  align: (auto,auto,auto,),
  table.header([Recorrido], [Cómo recuerda dónde continuar], [Cómo avanza],),
  table.hline(),
  [DFS], [Llamadas recursivas], [Continúa desde un vecino nuevo antes de revisar los demás],
  [BFS], [Cola], [Procesa primero las ciudades a una arista del origen, después las que están a dos, y así sucesivamente],
)
Desde Rosario, BFS procesa Salta y San Pablo, que están a un tramo, antes que Córdoba, Mendoza y Ushuaia, cuya menor cantidad de tramos desde el origen es dos. Ese orden permite encontrar caminos con la menor cantidad de aristas. La función #NormalTok("bfs"); que escribimos devuelve el orden de visita. Para reconstruir un camino mínimo, también necesitaríamos guardar desde qué vértice descubrimos cada vecino y seguir esas referencias desde el destino hasta el origen.

Para buscar algo cercano al origen, BFS permite revisar primero los vecinos directos y después las conexiones más lejanas. DFS profundiza en una rama antes de probar otra y puede encontrar antes un destino profundo si está en esa rama. Ninguno es siempre más rápido: depende del grafo, del destino y del orden de los vecinos.

= Aplicaciones
<aplicaciones>
Los recorridos permiten listar todos los vértices alcanzables. Si solamente queremos saber si podemos llegar a un destino, podemos detenernos apenas lo encontramos.

== Viajar mediante conexiones
<viajar-mediante-conexiones>
Para comprobar si podemos viajar de Rosario a Mendoza, podemos adaptar DFS. La función devuelve #NormalTok("True"); al encontrar el destino. Cada llamada transmite ese resultado a la anterior y termina, sin explorar las ramas pendientes. Si agota las posibilidades, devuelve #NormalTok("False");. Recibe los objetos de origen y destino. La condición #NormalTok("actual is destino"); comprueba si llegamos al mismo objeto.

#Skylighting(([#KeywordTok("def");#NormalTok(" hay_camino(origen, destino):");],
[#NormalTok("    visitados ");#OperatorTok("=");#NormalTok(" ");#BuiltInTok("set");#NormalTok("()");],
[],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" visitar(actual):");],
[#NormalTok("        ");#ControlFlowTok("if");#NormalTok(" actual ");#KeywordTok("is");#NormalTok(" destino:");],
[#NormalTok("            ");#ControlFlowTok("return");#NormalTok(" ");#VariableTok("True");],
[],
[#NormalTok("        visitados.add(actual)");],
[#NormalTok("        ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" actual.vecinos:");],
[#NormalTok("            ");#ControlFlowTok("if");#NormalTok(" vecino ");#KeywordTok("not");#NormalTok(" ");#KeywordTok("in");#NormalTok(" visitados:");],
[#NormalTok("                ");#ControlFlowTok("if");#NormalTok(" visitar(vecino):");],
[#NormalTok("                    ");#ControlFlowTok("return");#NormalTok(" ");#VariableTok("True");],
[],
[#NormalTok("        ");#ControlFlowTok("return");#NormalTok(" ");#VariableTok("False");],
[],
[#NormalTok("    ");#ControlFlowTok("return");#NormalTok(" visitar(origen)");],
[],
[#BuiltInTok("print");#NormalTok("(hay_camino(rosario, mendoza))");],
[#BuiltInTok("print");#NormalTok("(hay_camino(rosario, ushuaia))");],));
#Skylighting(([#NormalTok("True");],
[#NormalTok("True");],));
En la segunda búsqueda visitamos Rosario, San Pablo y Ushuaia. Al encontrar Ushuaia, terminamos sin visitar Córdoba, Salta ni Mendoza. Esto comprueba que existe un camino, pero no devuelve un itinerario. Tampoco la lista de un recorrido es un itinerario: DFS visita Ushuaia y Córdoba una después de la otra, aunque no haya una arista entre ellas.

En nuestro ejemplo todas las ciudades están conectadas entre sí mediante algún camino. Si agregamos otra ciudad sin aristas, el recorrido desde Rosario no la alcanzará:

#Skylighting(([#NormalTok("parana ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Paraná\"");#NormalTok(")");],
[#BuiltInTok("print");#NormalTok("(hay_camino(rosario, parana))");],));
#Skylighting(([#NormalTok("False");],));
Un recorrido desde un origen solamente alcanza la parte del grafo conectada con él. Si hay vértices aislados, necesitamos conservar referencias a ellos para poder accederlos.

== Encontrar contactos indirectos
<encontrar-contactos-indirectos>
Supongamos ahora que los vértices representan personas y una arista indica que dos personas son contactos en una red. Queremos saber qué personas puede alcanzar Ana mediante sus contactos, aunque todavía no tenga una conexión directa con ellas.

#figure([
#box(image("imgs/03/contactos.svg", alt: "Ana conecta con Bruno y Carla. Bruno conecta con Diego. Carla conecta con Diego y Elena. Todas las conexiones son mutuas.", width: 65%))
], caption: figure.caption(
position: bottom, 
[
Red de contactos de cinco personas.
]), 
kind: "quarto-float-fig", 
supplement: "Figura", 
)


Usamos la misma clase #NormalTok("Vertice");, ahora con nombres de personas:

#Skylighting(([#NormalTok("ana ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Ana\"");#NormalTok(")");],
[#NormalTok("bruno ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Bruno\"");#NormalTok(")");],
[#NormalTok("carla ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Carla\"");#NormalTok(")");],
[#NormalTok("diego ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Diego\"");#NormalTok(")");],
[#NormalTok("elena ");#OperatorTok("=");#NormalTok(" Vertice(");#StringTok("\"Elena\"");#NormalTok(")");],
[],
[#NormalTok("ana.conectar(bruno)");],
[#NormalTok("ana.conectar(carla)");],
[#NormalTok("bruno.conectar(diego)");],
[#NormalTok("carla.conectar(diego)");],
[#NormalTok("carla.conectar(elena)");],
[],
[#BuiltInTok("print");#NormalTok("([persona.valor ");#ControlFlowTok("for");#NormalTok(" persona ");#KeywordTok("in");#NormalTok(" bfs(ana)])");],));
#Skylighting(([#NormalTok("['Ana', 'Bruno', 'Carla', 'Diego', 'Elena']");],));
El recorrido empieza en Ana y registra a Bruno y Carla, sus contactos directos. Al procesar Bruno descubre a Diego. Cuando llega el turno de Carla, Diego ya está registrado, por lo que solamente agrega a Elena a la cola.

Para quedarnos con los contactos indirectos, podemos quitar del resultado a Ana y a quienes ya aparecen en su lista de vecinos:

#Skylighting(([#NormalTok("alcanzables ");#OperatorTok("=");#NormalTok(" bfs(ana)");],
[#NormalTok("indirectos ");#OperatorTok("=");#NormalTok(" [");],
[#NormalTok("    persona.valor ");#ControlFlowTok("for");#NormalTok(" persona ");#KeywordTok("in");#NormalTok(" alcanzables");],
[#NormalTok("    ");#ControlFlowTok("if");#NormalTok(" persona ");#KeywordTok("is");#NormalTok(" ");#KeywordTok("not");#NormalTok(" ana ");#KeywordTok("and");#NormalTok(" persona ");#KeywordTok("not");#NormalTok(" ");#KeywordTok("in");#NormalTok(" ana.vecinos");],
[#NormalTok("]");],
[#BuiltInTok("print");#NormalTok("(indirectos)");],));
#Skylighting(([#NormalTok("['Diego', 'Elena']");],));
Diego es alcanzable por Bruno o por Carla, mientras que Elena es alcanzable por Carla. Si hubiera más personas conectadas a través de ellos, el recorrido también las alcanzaría. La lista reúne candidatos para sugerir contactos, pero todavía no establece a quiénes conviene recomendar.

= Eficiencia de los recorridos
<eficiencia-de-los-recorridos>
Para contar el trabajo de DFS y BFS no alcanza con contar las ciudades visitadas. En cada ciudad también revisamos sus vecinos, incluso los que ya estaban registrados.

Nuestra red tiene seis vértices y ocho aristas. Un recorrido completo visita las seis ciudades y revisa dieciséis entradas en las listas de vecinos: cada arista aparece en ambos extremos. Si agregáramos más conexiones entre esas mismas ciudades, habría más vecinos que revisar, aunque la cantidad de vértices siguiera siendo seis.

Por eso usamos dos cantidades: $V$ para los vértices y $E$ para las aristas. El trabajo crece como $V + 2 E$. Al omitir el factor constante, lo expresamos como $O\(V + E\)$. Esto vale para ambos recorridos. Si hay partes desconectadas, solo procesamos la parte alcanzable desde el origen. Una búsqueda puede terminar antes si encuentra el destino, pero en el peor caso necesita explorar toda esa parte.

= Clase #NormalTok("Vertice"); completa
<clase-vertice-completa>
Reunimos los métodos que fuimos agregando:

#Skylighting(([#KeywordTok("class");#NormalTok(" Vertice:");],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" ");#FunctionTok("__init__");#NormalTok("(");#VariableTok("self");#NormalTok(", valor):");],
[#NormalTok("        ");#VariableTok("self");#NormalTok(".valor ");#OperatorTok("=");#NormalTok(" valor");],
[#NormalTok("        ");#VariableTok("self");#NormalTok(".vecinos ");#OperatorTok("=");#NormalTok(" []");],
[],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" conectar(");#VariableTok("self");#NormalTok(", otro):");],
[#NormalTok("        ");#CommentTok("# La conexión se guarda en ambos sentidos");],
[#NormalTok("        ");#ControlFlowTok("if");#NormalTok(" otro ");#KeywordTok("not");#NormalTok(" ");#KeywordTok("in");#NormalTok(" ");#VariableTok("self");#NormalTok(".vecinos:");],
[#NormalTok("            ");#VariableTok("self");#NormalTok(".vecinos.append(otro)");],
[#NormalTok("            otro.vecinos.append(");#VariableTok("self");#NormalTok(")");],
[],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" desconectar(");#VariableTok("self");#NormalTok(", otro):");],
[#NormalTok("        ");#ControlFlowTok("if");#NormalTok(" otro ");#KeywordTok("in");#NormalTok(" ");#VariableTok("self");#NormalTok(".vecinos:");],
[#NormalTok("            ");#VariableTok("self");#NormalTok(".vecinos.remove(otro)");],
[#NormalTok("            otro.vecinos.remove(");#VariableTok("self");#NormalTok(")");],
[],
[#NormalTok("    ");#KeywordTok("def");#NormalTok(" aislar(");#VariableTok("self");#NormalTok("):");],
[#NormalTok("        ");#CommentTok("# Copiamos la lista porque desconectar modifica los vecinos");],
[#NormalTok("        ");#ControlFlowTok("for");#NormalTok(" vecino ");#KeywordTok("in");#NormalTok(" ");#VariableTok("self");#NormalTok(".vecinos.copy():");],
[#NormalTok("            ");#VariableTok("self");#NormalTok(".desconectar(vecino)");],));
Podés descargar la clase y las funciones de recorridos y búsqueda en #link("grafos.py").

= Siguientes pasos
<siguientes-pasos>
Un grafo permite representar relaciones entre elementos, incluso cuando hay ciclos y distintos caminos entre dos vértices. En este apunte guardamos las conexiones mediante listas de vecinos y usamos DFS y BFS para recorrer la parte alcanzable desde un origen. También adaptamos un recorrido para comprobar si existe un camino entre dos ciudades.

Estas ideas aparecen en aplicaciones con otros datos y otras preguntas:

- #strong[Mapas y transporte.] Los vértices pueden representar intersecciones, estaciones o aeropuertos, y las aristas, los tramos que permiten viajar entre ellos. Además de saber si existe un camino, podemos buscar uno que reduzca la distancia, el tiempo o el costo del viaje.
- #strong[Redes de computadoras.] Podemos representar equipos y sus conexiones para estudiar qué destinos son alcanzables y qué partes de la red quedan incomunicadas si falla un enlace.
- #strong[Dependencias entre tareas.] Una arista puede indicar que una tarea debe terminar antes de empezar otra. Queremos encontrar un orden que respete esas dependencias y detectar ciclos que impidan cumplirlas. La misma idea sirve para organizar materias con correlatividades.
- #strong[Redes de contactos.] Además de encontrar contactos indirectos, podemos estudiar grupos de personas conectadas entre sí o cómo se difunde información a través de sus vínculos.

Para responder esas preguntas, muchas veces necesitamos ampliar el modelo. Si una conexión representa una calle de sentido único o una dependencia entre tareas, el grafo es dirigido: debemos guardar qué enlaces salen de cada vértice y seguirlos en ese sentido. Nuestro método #NormalTok("conectar");, que agrega referencias en ambos extremos, tendría que cambiar.

Si volvemos a los vuelos y agregamos precios o duraciones, cada arista necesita guardar un #strong[peso] (#emph[weight]). Hablamos entonces de un #strong[grafo ponderado] (#emph[weighted graph]). Un vuelo directo puede costar más que un viaje con una escala: el camino con menos aristas puede tener un costo total mayor. BFS sigue sirviendo para minimizar la cantidad de tramos, pero para minimizar la suma de esos pesos necesitamos otros algoritmos.

Otras consultas requieren más información que un peso por arista. Para planificar un viaje con horarios, no alcanza con sumar duraciones: hay que comprobar si llegamos a tiempo para tomar el siguiente vuelo. Si además se cancela una conexión, puede ser necesario buscar otra alternativa.

El tamaño de la red también plantea dificultades. Si crece hasta tener millones de vértices, importa cuánta memoria ocupa la representación y cuánto de ella necesitamos recorrer.

Las preguntas que guían estas ampliaciones son las mismas que empezamos a trabajar acá: qué representa cada vértice, qué información guarda una arista y qué queremos averiguar al seguir las conexiones. Las respuestas determinan tanto la representación como el algoritmo.
