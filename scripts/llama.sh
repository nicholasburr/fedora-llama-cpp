#!/bin/bash
#podman run --replace -itd --name llama-server --volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z --device /dev/dri:/dev/dri --device /dev/kfd:/dev/kfd --group-add video --group-add render --security-opt seccomp=unconfined -p 8080:8080 --ipc=host localhost/llama.cpp:server llama-server -hf unsloth/gemma-4-31B-it-GGUF:BF16 --log-timestamps --host 0.0.0.0 --port 8080 --no-mmap -fit off -c 8192 -ngl 999 -fa 1

#podman run --replace -itd --name llama-server --volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z --device /dev/dri:/dev/dri --device /dev/kfd:/dev/kfd --group-add video --group-add render --security-opt seccomp=unconfined -p 8080:8080 --ipc=host ghcr.io/ggml-org/llama.cpp:server-rocm -hf unsloth/gemma-4-31B-it-GGUF:BF16 --log-timestamps --host 0.0.0.0 --port 8080 --no-mmap -fit off -c 16384 -ngl 999 -fa 1

#podman run --replace -itd --name llama-server --volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z --device /dev/dri:/dev/dri --device /dev/kfd:/dev/kfd --group-add video --group-add render --security-opt seccomp=unconfined -p 8080:8080 --ipc=host kyuz0/amd-strix-halo-toolboxes:rocm-7.2.2 llama-server -hf unsloth/gemma-4-31B-it-GGUF:BF16 --log-timestamps --host 0.0.0.0 --port 8080 --no-mmap -fit off -c 16384 -ngl 999 -fa 1


podman run --replace -itd --name llama-server --volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z --device /dev/dri:/dev/dri --device /dev/kfd:/dev/kfd --group-add video --group-add render --security-opt seccomp=unconfined -p 8080:8080 --ipc=host localhost/llama.cpp:server llama-server -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_M --log-timestamps --host 0.0.0.0 --port 8080 --no-mmap -fit off -c 16382 -ngl 999 -fa 1
