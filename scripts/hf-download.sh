#!/bin/bash
podman run --replace -d -it --name huggingface --secret=huggingface-token,type=env,target=HF_TOKEN --env HF_XET_HIGH_PERFORMANCE=1 --volume=/home/nburr/Desktop/ai/local-ai/containers/files:/root/.config/llama.cpp/:Z --volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z localhost/huggingface:latest
