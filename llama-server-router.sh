#!/bin/bash
podman run --replace -itd --name llama-server \
--volume=/home/nburr/.cache/huggingface/hub/:/root/.cache/huggingface/hub/:Z \
--device /dev/dri:/dev/dri --device /dev/kfd:/dev/kfd \
--group-add video --group-add render \
--security-opt seccomp=unconfined \
--publish 8080:8080 --ipc=host \
localhost/llama.cpp:server llama-server --models-dir /root/.cache/huggingface/hub/ --log-timestamps --no-mmap --host 0.0.0.0 --port 8080 --fit off --n-gpu-layers 99 --ctx-size 393216 --flash-attn on --parallel 6 --cont-batching --webui-mcp-proxy
#--models-preset /root/.config/llama.cpp/models.ini
#--volume=/home/nburr/.config/llama.cpp/:/root/.config/llama.cpp/:Z \
#localhost/llama.cpp:server llama-server --models-dir /root/.cache/huggingface/hub/ --log-timestamps --host 0.0.0.0 --port 8080 --no-mmap -fit off -c 8192 -ngl 999 -fa 1
