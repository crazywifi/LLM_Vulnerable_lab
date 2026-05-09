#!/bin/bash
set -e

echo
echo "========================================"
echo "  LLM Vuln Lab"
echo "  Local LLM Security Training Platform"
echo "========================================"
echo

if command -v python3 >/dev/null 2>&1; then
  PYTHON="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
  PYTHON="$(command -v python)"
else
  echo "[ERROR] Python not found. Install Python 3 from https://python.org"
  exit 1
fi

echo "[OK] Python: $($PYTHON --version)"
echo

echo "[INFO] Checking Python dependencies..."
$PYTHON -m pip install -r requirements.txt --quiet
echo "[OK] Dependencies ready"
echo

echo "[INFO] Detecting optional LLM providers..."

if curl -sf http://localhost:11434/api/tags --max-time 2 >/dev/null 2>&1; then
  echo "[OK] Ollama is running"
else
  echo "[WARN] Ollama offline - start with: OLLAMA_ORIGINS=* ollama serve"
fi

if curl -sf http://localhost:1234/v1/models --max-time 2 >/dev/null 2>&1; then
  echo "[OK] LM Studio is running"
else
  echo "[WARN] LM Studio offline - open LM Studio and start the Local Server"
fi

if [ -n "$OPENROUTER_API_KEY" ]; then
  echo "[OK] OpenRouter key configured"
else
  echo "[WARN] OpenRouter not configured - optional: export OPENROUTER_API_KEY=sk-or-..."
fi

echo
echo "[INFO] Starting backend on http://localhost:8000"
echo "[INFO] API docs: http://localhost:8000/docs"
echo "[INFO] Press Ctrl+C to stop"
echo

(
  sleep 2
  if [ "$(uname)" = "Darwin" ]; then
    open "http://localhost:8000" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "http://localhost:8000" >/dev/null 2>&1 || true
  fi
) &

$PYTHON lab_backend_server.py
