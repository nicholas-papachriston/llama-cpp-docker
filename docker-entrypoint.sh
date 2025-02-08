#!/bin/sh

set -eu

# model target, sha256 hash, and url
MODEL_LIST=$(cat << EOF
deepseek-r1-distill-qwen-7b 7b736fc4913dce4c7fbcebe5cb965a2fa7314a14b59e25fb53d415f9d18d7aa1 https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-7B-Q5_K_M.gguf
EOF
)

usage() {
  MODEL_NAMES=$(echo "$MODEL_LIST" | awk '{print "  " $1}' | sort)
  cat << EOF
Usage: $0 [MODEL]...
Run llama-server or download a model and exit

If no MODEL is provided, run llama-server with default settings.

Available models to download:

$MODEL_NAMES

EOF
}

parse_args_download_model() {
  if [ "$#" -ge 1 ]; then
    MODEL_LINE=$(echo "$MODEL_LIST" | grep "$1" || true)

    if [ "$1" = "--help" ] || [ -z "$MODEL_LINE" ]; then
      usage
      exit 1
    fi

    MODEL_SHA256=$(echo "$MODEL_LINE" | awk '{print $2}')
    MODEL_URL=$(echo "$MODEL_LINE" | awk '{print $3}')
    MODEL_NAME=$(basename "$MODEL_URL")

    curl -LO "$MODEL_URL"
    echo "$MODEL_SHA256  $MODEL_NAME" | sha256sum -c -
    exit 0
  fi
}

set_default_env_vars() {
  if [ -z ${LLAMA_ARG_HOST+x} ]; then
    export LLAMA_ARG_HOST="0.0.0.0"
  fi
}

parse_args_download_model "$@"
set_default_env_vars

set -x
llama-server
