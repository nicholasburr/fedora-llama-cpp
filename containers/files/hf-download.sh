#!/bin/bash

# Configuration file name
HF_MODELS_INI="/root/.config/llama.cpp/models.ini"

# Check if file exists
if [ ! -f "$HF_MODELS_INI" ]; then
    echo "Error: $HF_MODELS_INI not found."
    exit 1
fi

# Initialize temporary variables
repo_id=""
model_id=""

while read -r line || [[ -n "$line" ]]; do
    # Trim whitespace
    line=$(echo "$line" | xargs)

    case "$line" in
        ";repo ="*)
            # Extract everything after the '=' and trim whitespace
            repo_id="${line#*=}"
            repo_id=$(echo "$repo_id" | xargs)
            ;;
        "model ="*)
            # Extract everything after the '=' and trim whitespace
            model_id="${line#*=}"
            model_id=$(echo "$model_id" | xargs)
            ;;
    esac

    if [[ -n "$repo_id" && -n "$model_id" ]]; then
        echo "──────────────────────────────────────────"
        echo "Target Repo:  $repo_id"
        echo "Target Model: $model_id"
        
        hf download "$repo_id" "$model_id"
        
        # Reset variables
        repo_id=""
        model_id=""
    fi
done < "$HF_MODELS_INI"
