#' Create and open a default prompt file
#'
#' This function bootstraps a new prompt file (JSON or YAML),
#' optionally adds a PROMPT_PATH line to .Rprofile, and opens it for editing.
#'
#' @param scope "project" (default) or "user"
#' @param format "json" (default) or "yaml"
#' @export
use_prompt_file <- function(scope = c("project", "user"), format = "json") {
  scope <- match.arg(scope)
  format <- match.arg(format, c("json", "yaml"))
  
  path <- if (scope == "user") {
    file.path(Sys.getenv("HOME"), paste0("prompts.", format))
  } else {
    file.path(usethis::proj_get(), paste0("prompts.", format))
  }
  
  example_prompts <- list(
    system_instructions1 = "You are an R assistant that writes clear, reproducible code.",
    system_instructions2 = "You are a code reviewer focusing on efficiency and style.",
    user_template1 = "Summarize the following dataset: {{dataset_name}}",
    user_template2 = "Translate this text into Spanish: {{text}}"
  )
  
  if (!file.exists(path)) {
    if (format == "json") jsonlite::write_json(example_prompts, path, pretty = TRUE, auto_unbox = TRUE)
    else yaml::write_yaml(example_prompts, path)
    message("✔ Created ", basename(path))
  } else {
    message("ℹ File already exists at ", path)
  }
  
  # Add PROMPT_PATH to .Rprofile
  profile_path <- if (scope == "user") "~/.Rprofile" else ".Rprofile"
  cat(sprintf('\nSys.setenv(PROMPT_PATH = "%s")\n', normalizePath(path, mustWork = FALSE)),
      file = profile_path, append = TRUE)
  message("✔ Added PROMPT_PATH to ", profile_path)
  
  # Open file for user
  if (rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(path)
  } else {
    utils::file.edit(path)
  }
  
  invisible(path)
}
