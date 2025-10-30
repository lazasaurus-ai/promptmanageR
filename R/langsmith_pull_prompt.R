#' Pull a prompt template from LangSmith
#'
#' Downloads a prompt definition directly from the LangSmith Hub API
#' and extracts the raw text template. This is equivalent to
#' `client.pull_prompt()` in the Python SDK.
#'
#' @param path Character. Prompt path like `"rlm/rag-prompt"`. Required.
#' @param include_model Logical. Whether to include model info (default `TRUE`).
#' @param api_key Character. LangSmith API key (default reads `LANGSMITH_API_KEY` env var).
#'
#' @return Character string containing the prompt text template.
#' @examples
#' \dontrun{
#'   prompt <- pull_prompt_langsmith("rlm/rag-prompt")
#'   cat(prompt)
#' }
#' @export
pull_prompt_langsmith <- function(path,
                                  include_model = TRUE,
                                  api_key = Sys.getenv("LANGSMITH_API_KEY")) {
  
  if (missing(path) || !nzchar(path)) {
    stop("❌ `path` is required, e.g. pull_prompt_langsmith('rlm/rag-prompt').")
  }
  
  if (!nzchar(api_key)) {
    stop("❌ Missing LangSmith API key. Set LANGSMITH_API_KEY in your environment.")
  }
  
  base_url <- "https://api.smith.langchain.com/api/v1"
  url <- paste0(
    base_url, "/commits/", path,
    "/latest?include_model=", tolower(as.character(include_model))
  )
  
  req <- httr2::request(url) |>
    httr2::req_headers(
      "x-api-key" = api_key,
      "Accept" = "application/json"
    )
  
  resp <- httr2::req_perform(req)
  if (httr2::resp_status(resp) != 200) {
    stop("Prompt fetch failed [", httr2::resp_status(resp), "]: ",
         httr2::resp_status_desc(resp))
  }
  
  json <- httr2::resp_body_json(resp, simplifyVector = TRUE)
  
  # Extract and return just the template text
  json$manifest$kwargs$messages$kwargs$prompt$kwargs$template
}
