#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

# Configuration
SERVER_IP = "192.168.1.200"
PORT = "8000"
URL = f"http://{SERVER_IP}:{PORT}/v1/models"

def get_llama_models():
    print(f"Connecting to llama-server at {URL}...\n")
    try:
        # Query the standard OpenAI-compatible models endpoint
        with urllib.request.urlopen(URL, timeout=5) as response:
            if response.status == 200:
                data = json.loads(response.read().decode())
                
                # Extract the models array
                models = data.get("data", [])
                
                if not models:
                    print("⚠️  No models returned by the server.")
                    return
                
                # Print the results neatly
                print(f"{'INDEX':<6} | {'MODEL ID':<40} | {'OWNED BY':<15}")
                print("-" * 68)
                for index, model in enumerate(models, 1):
                    model_id = model.get("id", "Unknown")
                    owned_by = model.get("owned_by", "Unknown")
                    print(f"{index:<6} | {model_id:<40} | {owned_by:<15}")
                    
            else:
                print(f"❌ Server responded with status code: {response.status}")
                
    except urllib.error.URLError as e:
        print(f"❌ Failed to connect to llama-server.")
        print(f"   Reason: {e.reason}")
    except json.JSONDecodeError:
        print("❌ Successfully reached server, but received an invalid JSON response.")

if __name__ == "__main__":
    get_llama_models()
