# promptmanageR 🧠📜
> Lightweight prompt management for R + LLM clients (like [ellmer](https://github.com/mdrcdata/ellmer))

`promptmanageR` provides a simple framework for managing and rendering **system and user prompts** for AI/LLM workflows in R.  
It helps you separate prompt logic from code — load templates from JSON files, substitute variables, and preview them interactively.

---

## ✨ Features
- 📂 Load prompts from JSON files  
- 🧩 Render templates with variable substitution (`{{var}}`)  
- 👁️ Preview prompts nicely in the console  
- 🧰 Create a starter prompt file via `use_prompt_file()`  
- 🌍 Load a built-in library of universal and agent prompts  
- 🔗 Integrates seamlessly with `ellmer::chat_aws_bedrock()` and other LLM clients  

---

## 🛠 Installation

```r
# install from GitHub
remotes::install_github("lazasaurus-ai/promptmanageR")
```

---

## 🚀 Quick Start

```r
library(promptmanageR)
library(ellmer)
```

### 1️⃣ Create a prompt file interactively

Use the helper to scaffold a JSON file with example prompts in your current working directory:

```r
use_prompt_file()
```

This creates and opens a file called `prompts.json`:

```json
{
  "system_instructions1": "You are a helpful R assistant.",
  "user_template1": "Summarize the dataset {{dataset_name}}."
}
```

---

### 2️⃣ Load and render prompts

```r
prompts <- load_prompts("prompts.json")

# Replace variables in template
rendered <- render_prompt(prompts$user_template1, list(dataset_name = "iris"))

cat(rendered)
#> Summarize the dataset iris.
```

---

### 3️⃣ Preview prompts in color

```r
preview_prompt("user_template1", list(dataset_name = "mtcars"))
```

Output:
```
📄 Rendered Prompt:
----------------------------------------
Summarize the dataset mtcars
----------------------------------------
```

---

### 4️⃣ Use with an LLM client

```r
chat <- ellmer::chat_aws_bedrock(
  model = "anthropic.claude-3-5-sonnet-20240620-v1:0"
)

response <- chat$chat(
  prompts$system_instructions1,
  render_prompt(prompts$user_template1, list(dataset_name = "iris"))
)

cat(response)
```

---

## 🌍 Universal Prompts Library

`promptmanageR` ships with a built-in `universal-prompts.json` containing reusable **assistant**, **agent**, **system**, **developer**, **teaching**, **creative**, and **governance** prompts.

Load them anytime with:

```r
universal <- load_universal_prompts()
names(universal)[1:10]
```

Example:

```r
preview_prompt("developer_mlops")
```

Output:

```
📘 developer_mlops
----------------------------------------
You are a machine learning operations (MLOps) engineer. Design robust CI/CD workflows...
----------------------------------------
```
