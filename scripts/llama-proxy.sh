#!/bin/bash
podman run --replace -d -it --name llama-proxy --network=llama-network --publish 8000:8000 --env BACKEND_URL="http://llama-server:8001" localhost/llama-proxy:latest
