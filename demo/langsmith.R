library(promptmanageR)
prompt <- pull_prompt_langsmith(
  "rlm/rag-prompt",
  api_key = Sys.getenv("LANGSMITH_API_KEY")
)
prompt

# OR 

Sys.setenv(LANGSMITH_API_KEY = "")

prompt <- pull_prompt_langsmith("rlm/rag-prompt")
cat(prompt)


prompt <- pull_prompt_langsmith("rlm/text-to-sql")
cat(prompt)
