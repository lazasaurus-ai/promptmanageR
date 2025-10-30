#' Preview a rendered prompt
#'
#' Render a stored or ad-hoc prompt with variable substitution and print it
#' to the console in a readable format. If the first argument matches a key
#' in the loaded prompts (from PROMPT_PATH or the R environment), that prompt
#' is automatically used.
#'
#' @param template Either the prompt text itself, or the name of a prompt key
#'   (e.g. "user_template1") from the loaded prompt list.
#' @param vars A named list of variable values to insert.
#' @param show_header Logical; if TRUE (default), print a header line.
#' @return The rendered prompt (invisibly).
#' @export
preview_prompt <- function(template, vars = list(), show_header = TRUE) {
  # ── Try to locate prompts ────────────────────────────────────────────────
  prompts <- getOption("promptmanageR.prompts", default = NULL)
  
  # Fallback 1: use `prompts` object from global environment if it exists
  if (is.null(prompts) && exists("prompts", envir = .GlobalEnv)) {
    prompts <- get("prompts", envir = .GlobalEnv)
    message(cli::col_green("✔ Using prompts from current R environment."))
  }
  
  # Fallback 2: load from PROMPT_PATH if available
  if (is.null(prompts)) {
    path <- Sys.getenv("PROMPT_PATH", unset = "")
    if (nzchar(path) && file.exists(path)) {
      prompts <- load_prompts(path)
      options(promptmanageR.prompts = prompts)
      message(cli::col_green(paste0("✔ Loaded prompts from ", path)))
    } else {
      message(cli::col_yellow("⚠ No prompts loaded and PROMPT_PATH not set or invalid."))
    }
  }
  
  # ── Auto-resolve key if a prompt name is given ───────────────────────────
  if (!is.null(prompts) && is.character(template) && template %in% names(prompts)) {
    template <- prompts[[template]]
  }
  
  # ── Render prompt text ──────────────────────────────────────────────────
  rendered <- render_prompt(template, vars)
  
  # ── Pretty console output ───────────────────────────────────────────────
  if (show_header) {
    cat(cli::col_cyan("\n📄 Rendered Prompt:\n"))
    cat(cli::col_grey("----------------------------------------\n"))
  }
  
  if (nzchar(rendered)) {
    cat(rendered, "\n")
  } else {
    cat(cli::col_red("⚠ Empty or unresolved template.\n"))
  }
  
  if (show_header)
    cat(cli::col_grey("----------------------------------------\n"))
  
  invisible(rendered)
}



#' Preview a universal prompt in a small RStudio popup
#' @export
preview_universal_prompt <- function() {
  keys <- names(load_universal_prompts())
  choice <- rstudioapi::selectList(keys, title = "Choose a prompt to preview")
  if (length(choice) == 0) return(invisible())
  prompt <- load_universal_prompts()[[choice]]
  rstudioapi::showDialog(
    title = paste("Preview:", choice),
    message = paste0(substr(prompt, 1, 2000), if (nchar(prompt) > 2000) "...")
  )
}
