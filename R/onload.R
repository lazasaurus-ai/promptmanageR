.onLoad <- function(libname, pkgname) {
  path <- Sys.getenv("PROMPT_PATH", unset = "")
  if (nzchar(path) && file.exists(path)) {
    options(promptmanageR.prompts = load_prompts(path))
    packageStartupMessage("✔ Loaded prompts from ", path)
  }
}
