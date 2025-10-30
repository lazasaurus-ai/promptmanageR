#' Load built-in universal prompt templates
#'
#' Returns a list of curated system prompts included with promptmanageR.
#' These represent common assistant archetypes for data science, coding,
#' analysis, and policy communication.
#' @return A named list of prompt strings.
#' @export
load_universal_prompts <- function() {
  path <- system.file("prompts", "universal-prompts.json", package = "promptmanageR")
  if (!file.exists(path))
    stop("Universal prompt file not found inside package.")
  load_prompts(path)
}
