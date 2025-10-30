devtools::document()
devtools::load_all()


# Create Defualt prompt file

use_prompt_file(scope = "project")

prompts <- load_prompts("prompts.json")
names(prompts)


