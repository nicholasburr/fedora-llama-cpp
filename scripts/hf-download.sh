#!/bin/bash
# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

podman run --replace -d -it --name huggingface \
  --secret=huggingface-token,type=env,target=HF_TOKEN \
  --env HF_XET_HIGH_PERFORMANCE=1 \
  --volume="${SCRIPTS_DIR}:/root/.config/llama.cpp/:Z" \
  --volume="${MODEL_CACHE_DIR}:/root/.cache/huggingface/hub/:Z" \
  "${CONTAINER_REGISTRY}/huggingface:latest"
