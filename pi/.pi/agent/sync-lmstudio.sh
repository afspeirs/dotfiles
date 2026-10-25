#!/bin/bash
LOG_FILE="$HOME/.pi/agent/sync.log"
echo "=== Sync started at $(date) ===" >> "$LOG_FILE"

API_URL="http://andrew-desktop:1234/v1/models"
CONFIG_FILE="$HOME/.pi/agent/models.json"
TOKEN="${LM_API_TOKEN:-lm-studio}"

echo "Fetching from $API_URL..." >> "$LOG_FILE"
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL" -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

echo "HTTP Code: $HTTP_CODE" >> "$LOG_FILE"

if [ "$HTTP_CODE" -ne 200 ]; then
    echo "Error: LM Studio returned HTTP code $HTTP_CODE. Response: $BODY" >> "$LOG_FILE"
    exit 1
fi

python3 - "$BODY" "$CONFIG_FILE" "$TOKEN" << 'PYTHON_SCRIPT'
import sys
import json

raw_json = sys.argv[1]
output_path = sys.argv[2]
token = sys.argv[3]

try:
    data = json.loads(raw_json)

    # Handle both native LM Studio shapes (array, {"models": [...]}, or {"data": [...]})
    models_list = []
    if isinstance(data, list):
        models_list = data
    elif isinstance(data, dict):
        models_list = data.get("models", data.get("data", []))

    dynamic_models = []
    for m in models_list:
        model_id = m.get("model_key") or m.get("id")
        if not model_id:
            continue

        model_name = m.get("display_name") or m.get("name") or model_id

        model_entry = {
            "id": model_id,
            "name": model_name
        }

        if "context_length" in m:
            model_entry["contextWindow"] = m["context_length"]
        elif "max_context_length" in m:
            model_entry["contextWindow"] = m["max_context_length"]

        dynamic_models.append(model_entry)

    # Fallback if list is empty so Pi doesn't throw parser complaints
    if not dynamic_models:
        dynamic_models = [{"id": "default-local-model", "name": "Default Local Model"}]

    config = {
        "$schema": "https://pi.dev/schemas/models.schema.json",
        "providers": {
            "lmstudio": {
                "baseUrl": "http://127.0.0.1:1234/v1",
                "api": "openai-completions",
                "apiKey": token,
                "models": dynamic_models
            }
        }
    }

    with open(output_path, "w") as f:
        json.dump(config, f, indent=2)

    print(f"Successfully synced {len(dynamic_models)} model(s) to {output_path}")
except Exception as e:
    print(f"Python parsing error: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT
