#!/bin/bash
podman run --replace -itd --name vllm-gemma4 \
  --cap-add=SYS_PTRACE \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add=video \
  --ipc=host \
  --publish 8000:8000 \
  --security-opt=seccomp=unconfined \
  --secret=huggingface-token,type=env,target=HF_TOKEN \
  --volume ~/.cache/huggingface:/root/.cache/huggingface \
  vllm/vllm-openai-rocm \
      --model "cyankiwi/gemma-4-31B-it-AWQ-8bit" 
      --host 0.0.0.0 \
      --port 8000 \ 
      --tensor-parallel-size 1 \
      --max-num-seqs 1 \
      --max-model-len 16384 \
      --enable-auto-tool-choice \
      --reasoning-parser gemma4 \
      --tool-call-parser gemma4 \
      --gpu-memory-utilization 0.50 \ 
      --dtype auto \
      --trust-remote-code 
#     --attention-backend TRITON_ATTN \
#     --mm-encoder-attn-backend TRITON_ATTN
#    --model "google/gemma-4-31B-it" 
#  --host 0.0.0.0 \
#  --port 8000 
#  --max-model-len 393216 \
#  --max-num-seqs 6 \
#  --gpu-memory-utilization 0.95
#  --network=host \
#  --model "deepseek-ai/DeepSeek-V4-Pro"
#  --model "unsloth/gemma-4-26B-A4B-it-GGUF"
#  --model "unsloth/gemma-4-31B-it-GGUF"
#  # Required for Strix Halo / RDNA3.5 on vLLM
#  TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL=1
# --env VLLM_DISABLE_COMPILE_CACHE=1 \
# --env TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL=1 \
# --env FLASH_ATTENTION_TRITON_AMD_ENABLE="TRUE" \
# --env VLLM_TARGET_DEVICE=rocm \
# --env VLLM_USE_TRITON_AWQ=1 \
# --env MIOPEN_FIND_MODE=FAST \ 
#      --model /root/.cache/huggingface/hub/models--unsloth--Qwen3.6-27B-GGUF/snapshots/82d411acf4a06cfb8d9b073a5211bf410bfc29bf/Qwen3.6-27B-Q5_K_M.gguf 
#
#      --tokenizer Qwen/Qwen3.6-27B 
