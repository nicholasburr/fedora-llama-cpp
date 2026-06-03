#!/bin/bash
curl http://192.168.1.200:8001/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "unsloth/gemma-4-31B-it-GGUF:Q6_K",
    "messages": [{"role": "user", "content": "Hello!"}],
    "temperature": 0.7
  }'
