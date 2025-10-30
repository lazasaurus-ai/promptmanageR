#' Render a prompt template with variable substitution
#'
#' @param template A character string with variables in {{var}} format
#' @param vars A named list of variable values
#' @return The rendered prompt string
#' @examples
#' render_prompt("Summarize {{dataset}}", list(dataset = "iris"))
#' @export
render_prompt <- function(template, vars = list()) {
  if (!nzchar(template)) return("")
  if (length(vars) == 0) return(template)
  
  out <- glue::glue_data(
    .x = as.list(vars),
    .envir = parent.frame(),
    .open = "{{",
    .close = "}}",
    template
  )
  
  as.character(out)
}
