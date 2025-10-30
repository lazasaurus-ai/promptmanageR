.onLoad <- function(libname, pkgname) {
  path <- Sys.getenv("PROMPT_PATH", unset = "")
  
  # Only load local prompts if explicitly provided
  if (nzchar(path) && file.exists(path)) {
    options(promptmanageR.prompts = load_prompts(path))
    packageStartupMessage("✔ Loaded prompts from ", path)
  } else {
    packageStartupMessage("ℹ No PROMPT_PATH set; prompts not loaded automatically.")
  }
}
