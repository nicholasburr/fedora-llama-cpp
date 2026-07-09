#!/bin/bash
# Configuration Loader for fedora-llama-cpp

# Prevent multiple sourcing
if [ -n "${__CONFIG_SH_LOADED:-}" ]; then
    return 0
fi
__CONFIG_SH_LOADED=1

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load from .env if it exists
if [ -f "${PROJECT_ROOT}/.env" ]; then
    export $(grep -v "^#" "${PROJECT_ROOT}/.env" | grep -v "^$" | xargs)
fi

# Set defaults
: "${MODEL_CACHE_DIR:=${HOME}/.cache/huggingface/hub}"
: "${CONFIG_DIR:=${HOME}/.config/llama.cpp}"
: "${SCRIPTS_DIR:=${PROJECT_ROOT}/containers/files}"
: "${CONTAINER_REGISTRY:=localhost}"
: "${CONTAINER_RUNTIME:=podman}"
: "${HF_TOKEN:=}"
: "${VLLM_API_KEY:=}"
: "${CONFIG_DEBUG:=0}"
: "${DRY_RUN:=0}"

# Export for use in scripts
export MODEL_CACHE_DIR CONFIG_DIR SCRIPTS_DIR CONTAINER_REGISTRY
export CONTAINER_RUNTIME HF_TOKEN VLLM_API_KEY CONFIG_DEBUG DRY_RUN

# Create required directories
mkdir -p "$MODEL_CACHE_DIR"
mkdir -p "$CONFIG_DIR"

# Debug output
if [ "${CONFIG_DEBUG:-0}" = "1" ]; then
    echo "[config] MODEL_CACHE_DIR=$MODEL_CACHE_DIR"
    echo "[config] CONFIG_DIR=$CONFIG_DIR"
    echo "[config] SCRIPTS_DIR=$SCRIPTS_DIR"
    echo "[config] CONTAINER_REGISTRY=$CONTAINER_REGISTRY"
fi

# Validation
if [ ! -w "$MODEL_CACHE_DIR" ]; then
    echo "[config] Error: MODEL_CACHE_DIR not writable: $MODEL_CACHE_DIR"
    exit 1
fi

if [ ! -w "$CONFIG_DIR" ]; then
    echo "[config] Error: CONFIG_DIR not writable: $CONFIG_DIR"
    exit 1
fi
