library(ellmer)
library(promptmanageR)

# Load prompts from environment (auto-discovered if PROMPT_PATH set)
prompts <- load_prompts("prompts.json")

# Initialize a Bedrock chat session
chat <- chat_aws_bedrock(
  model = "anthropic.claude-3-5-sonnet-20240620-v1:0"
)

# Run a chat using a system prompt and a templated user prompt
response <- chat$chat(
  prompts$system_instructions1,
  render_prompt(prompts$user_template1, list(dataset_name = "iris"))
)

cat(response)



template <- "Compare {{model1}} and {{model2}} on {{dataset}}."
preview_prompt(template,
               list(model1 = "random forest",
                    model2 = "xgboost",
                    dataset = "iris"))
