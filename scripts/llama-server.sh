#!/bin/bash
podman run --replace -itd --name llama-server \
  --device=/dev/dri \
  --device=/dev/kfd \
  --group-add=video \
  --group-add=render \
  --ipc=host \
  --publish=8001:8001 \
  --restart=unless-stopped \
  --security-opt=seccomp=unconfined \
  --secret=huggingface-token,type=env,target=HF_TOKEN \
  --volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z \
  localhost/llama.cpp:server \
    llama-server \
      --models-dir /root/.cache/huggingface/hub/ \
      --log-timestamps \
      --no-mmap \
      --host 0.0.0.0 \
      --port 8001 \
      --fit off \
      --n-gpu-layers 99 \
      --ctx-size 393216 \
      --flash-attn on \
      --parallel 2 \
      --cont-batching \
      --webui-mcp-proxy \
      --jinja \
      --preserve-thinking \ 
      --spec-type draft-mtp \
      --spec-draft-n-max 2
#--models-preset /root/.config/llama.cpp/models.ini
#--volume=/home/nburr/.config/llama.cpp/:/root/.config/llama.cpp/:Z \
#localhost/llama.cpp:server llama-server --models-dir /root/.cache/huggingface/hub/ --log-timestamps --host 0.0.0.0 --port 8080 --no-mmap -fit off -c 8192 -ngl 999 -fa 1
