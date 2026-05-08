#  Reference:  https://github.com/waybarrios/vllm-mlx

#
#  ---------- Install vLLM ----------
#
#  MacOS
# Install as CLI tool (system-wide)
uv tool install git+https://github.com/waybarrios/vllm-mlx.git

#  ---- or ----
# Install from GitHub
pip install git+https://github.com/waybarrios/vllm-mlx.git

#
#  ---------- Start vLLM Server ----------
#
# Simple mode (single user, max throughput) - Check Huggingface.co & Download Locally
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000
vllm-mlx serve ibm-granite/granite-3.3-2b-base --port 8000
vllm-mlx serve ibm-granite/granite-3.3-8b-base --port 8000
vllm-mlx serve ibm-granite/granite-4.0-h-micro-base --port 8000
vllm-mlx serve ibm-granite/granite-20b-code-instruct-8k --port 8000
vllm-mlx serve ibm-granite/granite-3b-code-base-128k --port 8000
vllm-mlx serve google/gemma-4-26B-A4B-it --port 8000

#  gguf doesn't want to load using vllm
#  vllm-mlx serve ibm-granite/granite-4.0-micro-GGUF --port 8000

#  Mac Model location
cd /Users/dan1/.cache/huggingface/hub/

#  Serves on http://0.0.0.0:8000

#  Use local model without downloading - no huggingface.co check - fast loading
vllm-mlx serve ~/.cache/huggingface/hub/models--ibm-granite--granite-4.0-h-micro-base/snapshots/372ede0bc484284e08ce574e773c96cd2b89b367 --port 8000

# Continuous batching (multiple users)
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000 --continuous-batching

# With API key authentication
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000 --api-key your-secret-key

#  Using as a Chat Server - enable the CORS - Javascript page calling
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000 --allowed-origins "*"