library(stringr)

format_date <- function(date, format, locale = NULL) {
  if (!is.null(locale)) {
    original_locale <- Sys.getlocale("LC_TIME")
    Sys.setlocale("LC_TIME", locale)
    on.exit(Sys.setlocale("LC_TIME", original_locale))
  }
  return(format(as.Date(date), format))
}

FILE_ID <- "1syzAhGL4Acse9ob75Yq6qDwlffVHjlfLsnL81CPKxtM"
SHEET_NAME <- "2025"
googlesheets4::gs4_deauth()
data <- googlesheets4::read_sheet(FILE_ID, sheet = SHEET_NAME)
data[["fecha"]] <- as.Date(data[["fecha"]])
data[] <- lapply(data, as.character)
data[] <- lapply(data, function(x) gsub("\n", "<br>", x))

data$temas <- str_replace_all(data$temas, "(\\n)|(<br>)", " ") |>
  str_replace_all("\\.\\s*", ".") |>
  str_split("\\.") |>
  vapply(
    function(x) {
      if (length(x) == 1 && is.na(x)) {
        return(x)
      } else {
        # Solo las cadenas no vacias
        return(paste0("• ", str_trim(x[x != ""]), ".", collapse = "<br>"))
      }
    },
    character(1)
  )
# '%e' no se queda con el leading zero que conserva '%d'
data$fecha <- format_date(data$fecha, "%e de %B", "es_AR.utf8")

options(knitr.kable.NA = "")
tabla_md <- knitr::kable(
    data,
    col.names = c("Semana", "Fecha", "Temas", "Otras actividades"),
    align = c("c", "c", "l", "l"),
    escape = FALSE,
)

writeLines(tabla_md, here::here("informacion/_calendario.md"))
