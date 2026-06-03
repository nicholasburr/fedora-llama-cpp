#!/bin/bash
podman run --replace -itd --name vllm-gemma4 \
    --ipc=host \
    --network=host \
    --privileged \
    --cap-add=CAP_SYS_ADMIN \
    --device=/dev/kfd \
    --device=/dev/dri \
    --group-add=video \
    --cap-add=SYS_PTRACE \
    --security-opt=seccomp=unconfined \
    --volume ~/.cache/huggingface:/root/.cache/huggingface \
    --secret=vllm-api-key,type=env,target=VLLM_API_KEY \
    --secret=huggingface-token,type=env,target=HF_TOKEN \
    --env=VLLM_USE_TRITON_AWQ=1 \
    vllm/vllm-openai-rocm:latest \
    cyankiwi/gemma-4-31B-it-AWQ-8bit --host 0.0.0.0 --port 8000 --tensor-parallel-size 1 --max-num-seqs 1 --max-model-len 262144 --gpu-memory-utilization 0.95 --dtype auto --trust-remote-code --enforce-eager --attention-backend TRITON_ATTN --mm-encoder-attn-backend TRITON_ATTN 

