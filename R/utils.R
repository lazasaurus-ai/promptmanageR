#' Get currently loaded prompts
#' @export
get_prompts <- function() {
  getOption("promptmanageR.prompts", default = NULL)
}

#' Refresh the prompt file
#' @param path Optional path; defaults to PROMPT_PATH
#' @export
reload_prompts <- function(path = Sys.getenv("PROMPT_PATH", "")) {
  if (!nzchar(path) || !file.exists(path)) stop("Prompt file not found.")
  prompts <- load_prompts(path)
  options(promptmanageR.prompts = prompts)
  invisible(prompts)
}
