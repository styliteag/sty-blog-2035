#!/usr/bin/env bash

# Feature Image Generator (from scratch)
# - Uses OpenAI Images API (gpt-image-1)
# - Appends house style and normalizes to 1536x1024
# Usage:
#   ./generate-feature-image.sh "your prompt" [output-file]
# Env:
#   OPENAI_API_KEY=sk-...

# set -euo pipefail
# Debug flag (enable with --debug)
DEBUG=0

log_debug() { if [[ "$DEBUG" -eq 1 ]]; then echo "[debug] $*" >&2; fi }

# --- Config ---
BRAND_STYLE=", professional dark theme, corporate technology aesthetic, Red accents (#dc2626), wide composition, high quality illustration, blog header look"
OPENAI_ENDPOINT="https://api.openai.com/v1/images/generations"
OPENAI_MODEL="gpt-image-1"  # preferred over legacy dall-e-3
# We'll request a wide size and crop to blog spec afterwards
REQUEST_SIZE="1536x1024"
FINAL_WIDTH=1536
FINAL_HEIGHT=1024

# --- Helpers ---
err() { echo "Error: $*" >&2; }
need() { command -v "$1" >/dev/null 2>&1 || { err "Missing dependency: $1"; exit 1; }; }

# portable mktemp helpers for macOS/Linux (no suffix at end)
mktemp_file() {
  if command -v mktemp >/dev/null 2>&1; then
    mktemp -t stylite_img_XXXXXX 2>/dev/null || echo "/tmp/stylite_img_$$.$RANDOM"
  else
    echo "/tmp/stylite_img_$$.$RANDOM"
  fi
}

base64_decode() {
  # macOS uses -D, GNU uses -d; try both
  if echo "test" | base64 >/dev/null 2>&1; then
    if base64 --help 2>&1 | grep -q "-d"; then
      base64 -d
    else
      base64 -D
    fi
  else
    err "base64 utility not found"; exit 1
  fi
}

# --- Args & flags ---
CUSTOM_OUT=""
CUSTOM_SIZE=""

ARGS=()
while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    --debug)
      DEBUG=1; shift ;;
    --out|-o)
      CUSTOM_OUT=${2:-}; shift 2 ;;
    --size)
      CUSTOM_SIZE=${2:-}; shift 2 ;;
    *)
      ARGS+=("$1"); shift ;;
  esac
done

set -- "${ARGS[@]:-}"

PROMPT=${1:-}
OUTPUT_FILE=${CUSTOM_OUT:-${2:-feature.png}}

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  err "OPENAI_API_KEY environment variable not set"
  echo "Please run: export OPENAI_API_KEY='sk-...'"
  exit 1
fi

if [[ -z "$PROMPT" ]]; then
  err "No prompt provided"
  echo "Usage: $0 \"your prompt text\" [output-file]"
  exit 1
fi

# Check required tools
need curl
need python3

echo "Generating image with OpenAI…"
echo "Prompt: $PROMPT"
echo "Output: $OUTPUT_FILE"
[[ -n "$CUSTOM_SIZE" ]] && echo "Requested size override: $CUSTOM_SIZE"
log_debug "Endpoint: $OPENAI_ENDPOINT"
log_debug "Model: $OPENAI_MODEL"

FULL_PROMPT="${PROMPT}${BRAND_STYLE}"
log_debug "Full prompt: $FULL_PROMPT"

generate_once() {
  local size="$1"
  local payload
  # Safely JSON-escape the prompt and build payload without relying on jq program parsing
  local prompt_json
  prompt_json=$(printf '%s' "$FULL_PROMPT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
  payload=$(printf '{"model":"%s","prompt":%s,"size":"%s"}' "$OPENAI_MODEL" "$prompt_json" "$size")

  if [[ "$DEBUG" -eq 1 ]]; then
    local req_file
    req_file=$(mktemp_file)
    echo "$payload" > "$req_file"
    log_debug "Saved request payload: $req_file"
  fi

  # Capture body to a temp file and return status + file path
  local tmp_resp
  tmp_resp=$(mktemp_file)
  local http_status
  http_status=$(curl -sS -X POST "$OPENAI_ENDPOINT" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    -w '\n%{http_code}' -o "$tmp_resp" | tail -n1)

  if [[ "$DEBUG" -eq 1 ]]; then
    log_debug "Saved raw response: $tmp_resp"
  fi

  echo "$http_status"
  echo "$tmp_resp"
}

# First attempt with wide size; fallback to 1024x1024 if size is rejected
REQUESTED_SIZE=${CUSTOM_SIZE:-$REQUEST_SIZE}
HTTP_STATUS_AND_PATH=$(generate_once "$REQUESTED_SIZE")
HTTP_STATUS=$(echo "$HTTP_STATUS_AND_PATH" | head -n1)
RESP_FILE=$(echo "$HTTP_STATUS_AND_PATH" | tail -n +2)

# If non-2xx or error present, check if it's size-related and retry
ERR_PRESENT_INIT=$(python3 - "$RESP_FILE" <<'PY'
import sys,json
try:
  with open(sys.argv[1],'rb') as f:
    data=json.load(f)
  print('yes' if 'error' in data else 'no')
except Exception:
  print('no')
PY
)
if [[ ! "$HTTP_STATUS" =~ ^2 ]] || [[ "$ERR_PRESENT_INIT" == "yes" ]]; then
  MSG=$(python3 - "$RESP_FILE" <<'PY'
import sys,json
try:
  with open(sys.argv[1],'rb') as f:
    data=json.load(f)
  print(data.get('error',{}).get('message',''))
except Exception:
  print('')
PY
)
  if echo "$MSG" | grep -qiE 'size|dimension|1792|width|height'; then
    echo "OpenAI rejected size $REQUESTED_SIZE; retrying with 1024x1024…"
    HTTP_STATUS_AND_PATH=$(generate_once "1024x1024")
    HTTP_STATUS=$(echo "$HTTP_STATUS_AND_PATH" | head -n1)
    RESP_FILE=$(echo "$HTTP_STATUS_AND_PATH" | tail -n +2)
  fi
fi

# Final error check
if [[ ! "$HTTP_STATUS" =~ ^2 ]]; then
  err "OpenAI API HTTP $HTTP_STATUS"
  python3 - "$RESP_FILE" <<'PY'
import sys,json
try:
  with open(sys.argv[1],'rb') as f:
    data=json.load(f)
  msg = data.get('error',{}).get('message')
  print(msg if msg is not None else json.dumps(data))
except Exception:
  import pathlib
  p=pathlib.Path(sys.argv[1])
  print(p.read_text())
PY
  exit 1
fi
ERR_PRESENT=$(python3 - "$RESP_FILE" <<'PY'
import sys,json
try:
  with open(sys.argv[1],'rb') as f:
    data=json.load(f)
  print('yes' if 'error' in data else 'no')
except Exception:
  print('no')
PY
)
if [[ "$ERR_PRESENT" == "yes" ]]; then
  MSG_ONLY=$(python3 - "$RESP_FILE" <<'PY'
import sys,json
with open(sys.argv[1],'rb') as f:
  data=json.load(f)
print(data.get('error',{}).get('message',''))
PY
)
  err "OpenAI error: $MSG_ONLY"
  exit 1
fi

// Extract base64 and write image directly via Python to avoid shell limits
python3 - "$RESP_FILE" "$OUTPUT_FILE" <<'PY'
import sys,json,base64,io,os
resp_path, out_path = sys.argv[1], sys.argv[2]
with open(resp_path,'rb') as f:
  data=json.load(f)
b64=(data.get('data') or [{}])[0].get('b64_json','')
if not b64:
  print('Could not extract image from response', file=sys.stderr)
  print(open(resp_path,'r',encoding='utf-8',errors='ignore').read(), file=sys.stderr)
  sys.exit(2)
img=base64.b64decode(b64)
with open(out_path,'wb') as out:
  out.write(img)
PY
if [[ $? -ne 0 ]]; then
  exit 1
fi

# Cleanup response file unless debugging
if [[ "$DEBUG" -ne 1 ]]; then
  rm -f "$RESP_FILE" 2>/dev/null || true
fi
echo "Saved: $OUTPUT_FILE"

# Normalize to 1536x1024 if ImageMagick available (prefer modern IM7 "magick")
if command -v magick >/dev/null 2>&1; then
  echo "Resizing to ${FINAL_WIDTH}x${FINAL_HEIGHT} with magick…"
  magick "$OUTPUT_FILE" -resize ${FINAL_WIDTH}x${FINAL_HEIGHT}^ -gravity center -extent ${FINAL_WIDTH}x${FINAL_HEIGHT} "$OUTPUT_FILE"
elif command -v convert >/dev/null 2>&1; then
  echo "Resizing to ${FINAL_WIDTH}x${FINAL_HEIGHT}…"
  convert "$OUTPUT_FILE" -resize ${FINAL_WIDTH}x${FINAL_HEIGHT}^ -gravity center -extent ${FINAL_WIDTH}x${FINAL_HEIGHT} "$OUTPUT_FILE"
else
  echo "ImageMagick not found; leaving original dimensions."
fi

# Report final dimensions if identify is available
if command -v identify >/dev/null 2>&1; then
  dims=$(identify -format "%wx%h" "$OUTPUT_FILE" 2>/dev/null || true)
elif command -v magick >/dev/null 2>&1; then
  dims=$(magick identify -format "%wx%h" "$OUTPUT_FILE" 2>/dev/null || true)
fi
[[ -n "$dims" ]] && echo "Final image size: $dims"

echo "✅ Feature image generated: $OUTPUT_FILE ($(ls -lh "$OUTPUT_FILE" | awk '{print $5}'))"

if [[ -f "index.md" ]]; then
  echo
  echo "Next steps:"
  echo "- Review the image in this post folder."
  echo "- Run 'npm run dev' to preview the blog."
fi
