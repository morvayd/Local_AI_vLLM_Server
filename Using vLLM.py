#  Reference:  https://ploomber.io/blog/vllm-deploy/

#  Running using requests

# remember to run: pip install requests
import requests
import json

# change for your host
VLLM_HOST = "http://0.0.0.0:8000"
url = f"{VLLM_HOST}/v1/completions"

#  "model": "google/gemma-2b",
#  "model": "mlx-community/Llama-3.2-3B-Instruct-4bit",
#  "model": "ibm-granite/granite-4.0-h-micro-base",
#  "model": "ibm-granite/granite-20b-code-instruct-8k",
#  "model": "ibm-granite/granite-3b-code-base-128k", 
#  "model": "ibm-granite/granite-4.0-micro-GGUF", 
#  "prompt": "JupySQL is",
#  "max_tokens": 100,
#  "temperature": 0

headers = {"Content-Type": "application/json"}

#  preprompt = "You are an assistant AI, please answer a question simply, do not repeat the question.  Question: "

preprompt = "You are a helpful assistant. Answer the question directly and concisely. Do NOT repeat or restate the question. Answer only with the response.\n\nQuestion: "

prompt = "What is your name?"

totalprompt = preprompt+prompt

data = {
    "model": "ibm-granite/granite-4.0-micro-GGUF",
    "prompt": totalprompt,
    "max_tokens": 1000,
    "temperature": 0
}

response = requests.post(url, headers=headers, data=json.dumps(data))

print(response.json()["choices"][0]["text"])