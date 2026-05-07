#!/bin/bash

# Configuration file name
HF_MODELS_INI="/root/.config/llama.cpp/models.ini"

# Check if file exists
if [ ! -f "$HF_MODELS_INI" ]; then
    echo "Error: $HF_MODELS_INI not found."
    exit 1
fi

# Extract values labeled 'repo' and download each
grep "repo =" "$HF_MODELS_INI" | awk -F'=' '{print $2}' | sed 's/ //g' | while read -r repo_id;do grep "model =" /root/.config/llama.cpp/models.ini | awk -F'=' '{print $2}' | sed 's/ //g' | while read -r model_id; do
    echo "-----------------------------------"
    echo "Starting download for: $repo_id $model_id"
    
    # Download the model to a local directory named after the repo ID
    #hf download "$repo_id" --local-dir "./$(basename "$repo_id")"
    hf download "$repo_id" "$model_id"
done

