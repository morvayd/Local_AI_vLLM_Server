# vLLM Server on macOS

A guide to setting up and running vLLM (specifically vLLM-MLX optimized for Apple Silicon) on macOS for serving large language models.

## Overview

This project demonstrates how to install and run vLLM on macOS using MLX optimization for efficient inference on Apple Silicon Macs. vLLM is a fast and easy-to-use library for LLM inference and serving.

**Reference:** [vLLM-MLX GitHub Repository](https://github.com/waybarrios/vllm-mlx)

## Installation

### Option 1: Install as System-Wide CLI Tool (Recommended)
Note:  Install uv before continuing.  
```bash
uv tool install git+https://github.com/waybarrios/vllm-mlx.git
```

### Option 2: Install with pip

```bash
pip install git+https://github.com/waybarrios/vllm-mlx.git
```

## Starting the vLLM Server

### Basic Usage

Start a simple vLLM server on port 8000 with a single model:

```bash
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000
```

The server will be available at `http://0.0.0.0:8000`

### Available Models

The following models have been tested and are recommended:

- **mlx-community/Llama-3.2-3B-Instruct-4bit** - Fast, general purpose instruction model
- **ibm-granite/granite-3.3-2b-base** - Compact IBM model
- **ibm-granite/granite-3.3-8b-base** - Medium IBM model
- **ibm-granite/granite-4.0-h-micro-base** - Micro-optimized granite model
- **ibm-granite/granite-20b-code-instruct-8k** - Code instruction model (larger)
- **ibm-granite/granite-3b-code-base-128k** - Code model with long context
- **google/gemma-4-26B-A4B-it** - Google Gemma model

**Note:** GGUF format models may have compatibility issues with vLLM.

### Advanced Server Configurations

#### Continuous Batching (Multi-User Support)

Enable continuous batching to support multiple concurrent users:

```bash
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000 --continuous-batching
```

#### With API Key Authentication

Protect your server with an API key:

```bash
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000 --api-key your-secret-key
```

#### With CORS Support (For JavaScript/Web Clients)

Enable cross-origin requests for web-based clients:

```bash
vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000 --allowed-origins "*"
```

#### Local Model Loading (No Download)

For faster startup, use a pre-downloaded model from the local cache:

```bash
vllm-mlx serve ~/.cache/huggingface/hub/models--ibm-granite--granite-4.0-h-micro-base/snapshots/372ede0bc484284e08ce574e773c96cd2b89b367 --port 8000
```

**Model Location on macOS:**
```bash
~/.cache/huggingface/hub/
```

## Usage Examples

### Python Client (using requests)

Send requests to the running vLLM server from Python:

```python
import requests
import json

# Configure the vLLM host
VLLM_HOST = "http://0.0.0.0:8000"
url = f"{VLLM_HOST}/v1/completions"

headers = {"Content-Type": "application/json"}

# System prompt for better responses
preprompt = "You are a helpful assistant. Answer the question directly and concisely. Do NOT repeat or restate the question. Answer only with the response.\n\nQuestion: "

prompt = "What is your name?"
totalprompt = preprompt + prompt

# Prepare the request
data = {
    "model": "ibm-granite/granite-4.0-micro-GGUF",
    "prompt": totalprompt,
    "max_tokens": 1000,
    "temperature": 0
}

# Send the request
response = requests.post(url, headers=headers, data=json.dumps(data))

# Print the response
print(response.json()["choices"][0]["text"])
```

**Requirements:**
```bash
pip install requests
```

### Model Selection

Comment in/out the desired model in the Python code:

```python
# "model": "google/gemma-2b",
# "model": "mlx-community/Llama-3.2-3B-Instruct-4bit",
# "model": "ibm-granite/granite-4.0-h-micro-base",
# "model": "ibm-granite/granite-20b-code-instruct-8k",
# "model": "ibm-granite/granite-3b-code-base-128k",
```

## Advanced Configuration Options

### Available Flags

Run `vllm-mlx serve --help` for the complete list of options. Here are some commonly used ones:

| Option | Description |
|--------|-------------|
| `--host` | Host to bind (default: 0.0.0.0) |
| `--port` | Port to bind (default: 8000) |
| `--continuous-batching` | Enable continuous batching for multiple concurrent users |
| `--api-key` | API key for authentication |
| `--allowed-origins` | CORS allowed origins |
| `--max-num-seqs` | Max concurrent sequences |
| `--cache-memory-mb` | Cache memory limit in MB |
| `--max-tokens` | Default max tokens for generation |
| `--stream-interval` | Tokens to batch before streaming |
| `--rate-limit` | Rate limit requests per minute per client |
| `--timeout` | Default request timeout in seconds |
| `--kv-cache-quantization` | Quantize KV caches to reduce memory |
| `--enable-prefix-cache` | Enable prefix caching for repeated prompts |

### Inference Parameters

Key parameters for the completion request:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `model` | Model to use for inference | Required |
| `prompt` | Input prompt | Required |
| `max_tokens` | Maximum tokens to generate | 32768 |
| `temperature` | Sampling temperature (0 = deterministic) | Model default |
| `top_p` | Nucleus sampling parameter | Model default |

## Performance Tips

1. **Single User / Maximum Throughput:** Use default settings without continuous batching
2. **Multiple Users:** Enable `--continuous-batching` for better resource utilization
3. **Memory Management:** Use `--cache-memory-percent 0.20` to control memory usage
4. **Faster Loading:** Use local model paths instead of downloading from Hugging Face
5. **KV Cache Optimization:** Enable `--kv-cache-quantization` to reduce memory footprint

## Troubleshooting

- **Model not found:** Ensure you're using the correct model identifier from Hugging Face Hub
- **Memory issues:** Reduce `cache-memory-percent` or use smaller models
- **Slow loading:** Use `--allowed-origins` and CORS settings only when needed

## References

- [vLLM-MLX GitHub](https://github.com/waybarrios/vllm-mlx)
- [vLLM Deployment Guide](https://ploomber.io/blog/vllm-deploy/)
- [Hugging Face Model Hub](https://huggingface.co)

## License

This guide is provided as-is for educational and development purposes.
MIT License