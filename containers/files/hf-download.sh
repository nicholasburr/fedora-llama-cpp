#!/bin/bash

# Configuration file name
HF_MODELS_YAML="${HF_CONFIG_PATH:-/root/.config/llama.cpp/models.yaml}"

# 1. Force unbuffered output so logs stream instantly
export PYTHONUNBUFFERED=1

# (Notice: HF_HUB_DISABLE_PROGRESS_BARS has been removed)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | INFO  | $1"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | ERROR | $1" >&2
}

log "Starting model synchronization script."

if [ ! -f "$HF_MODELS_YAML" ]; then
    log_error "$HF_MODELS_YAML not found. Exiting."
    exit 1
fi

total_models=$(yq '.llms | length' "$HF_MODELS_YAML")
current_model=0

log "Found $total_models models to process."
log "──────────────────────────────────────────"

yq '.llms[] | [.repo, .model] | @tsv' "$HF_MODELS_YAML" | while IFS=$'\t' read -r repo_id model_id; do
    
    if [[ -n "$repo_id" && "$repo_id" != "null" && -n "$model_id" && "$model_id" != "null" ]]; then
        ((current_model++))
        
        log "Progress: [$current_model/$total_models]"
        log "Downloading: $model_id from $repo_id"

        # The Hugging Face progress bar will now print to standard output
        if hf download "$repo_id" "$model_id"; then
            log "Successfully downloaded $model_id"
        else
            log_error "Failed to download $model_id"
        fi
        
        log "──────────────────────────────────────────"
    fi

done

log "Model synchronization complete."
