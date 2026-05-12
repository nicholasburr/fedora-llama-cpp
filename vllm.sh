#!/bin/bash
podman run --replace -itd --name vllm \
  --group-add=video \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --device /dev/kfd:/dev/kfd \
  --device /dev/dri:/dev/dri \
  --volume ~/.cache/huggingface:/root/.cache/huggingface \
  --secret=huggingface-token,type=env,target=HF_TOKEN \
  --ipc=host \
  --publish 8000:8000 \
  vllm/vllm-openai-rocm:v0.20.2 \
  --model "google/gemma-4-31B-it" 
#  --host 0.0.0.0 \
#  --port 8000 
#  --max-model-len 393216 \
#  --max-num-seqs 6 \
#  --gpu-memory-utilization 0.95
#  --network=host \
#  --model "deepseek-ai/DeepSeek-V4-Pro"
#  --model "unsloth/gemma-4-26B-A4B-it-GGUF"
#  --model "unsloth/gemma-4-31B-it-GGUF"
