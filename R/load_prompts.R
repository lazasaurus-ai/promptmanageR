#' Load prompts from a JSON or YAML file
#'
#' @param path Path to the JSON or YAML file
#' @return A named list of prompts
#' @examples
#' prompts <- load_prompts("~/prompts.json")
#' prompts$system_instructions1
#' @export
load_prompts <- function(path) {
  if (!file.exists(path)) stop("Prompt file not found: ", path)
  ext <- tools::file_ext(path)
  switch(
    ext,
    "json" = jsonlite::fromJSON(path, simplifyVector = TRUE),
    "yaml" = yaml::read_yaml(path),
    "yml"  = yaml::read_yaml(path),
    stop("Unsupported file type: ", ext)
  )
}
