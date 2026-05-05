#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  LLM Vuln Lab — Start Script (Mac / Linux)
#  Run from the project folder: bash start.sh
# ═══════════════════════════════════════════════════════════════

RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[1;33m'
BLU='\033[0;34m'; CYN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

clear
echo -e "${RED}${BOLD}"
cat << 'EOF'
  ██╗     ██╗     ███╗   ███╗    ██╗   ██╗██╗   ██╗██╗     ███╗   ██╗
  ██║     ██║     ████╗ ████║    ██║   ██║██║   ██║██║     ████╗  ██║
  ██║     ██║     ██╔████╔██║    ██║   ██║██║   ██║██║     ██╔██╗ ██║
  ██║     ██║     ██║╚██╔╝██║    ╚██╗ ██╔╝██║   ██║██║     ██║╚██╗██║
  ███████╗███████╗██║ ╚═╝ ██║     ╚████╔╝ ╚██████╔╝███████╗██║ ╚████║
  ╚══════╝╚══════╝╚═╝     ╚═╝      ╚═══╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝
EOF
echo -e "${NC}${CYN}                  LOCAL LLM SECURITY TRAINING PLATFORM${NC}\n"

# ── Check Python ──────────────────────────────────────────────
if ! command -v python3 &>/dev/null; then
    echo -e "${RED}✗ Python 3 not found. Install from python.org${NC}"
    exit 1
fi
PYTHON=$(command -v python3)
echo -e "${GRN}✓ Python: $($PYTHON --version)${NC}"

# ── Install deps if needed ────────────────────────────────────
if ! $PYTHON -c "import fastapi" 2>/dev/null; then
    echo -e "${YLW}→ Installing Python dependencies...${NC}"
    $PYTHON -m pip install fastapi uvicorn httpx --quiet
    echo -e "${GRN}✓ Dependencies installed${NC}"
else
    echo -e "${GRN}✓ Dependencies OK${NC}"
fi

# ── Detect providers ──────────────────────────────────────────
echo ""
echo -e "${BLU}${BOLD}Detecting LLM providers...${NC}"

OLLAMA_OK=false
if curl -sf http://localhost:11434/api/tags --max-time 2 >/dev/null 2>&1; then
    MODELS=$(curl -sf http://localhost:11434/api/tags | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('models',[]))) " 2>/dev/null || echo "?")
    echo -e "${GRN}  ● Ollama online — ${MODELS} model(s)${NC}"
    OLLAMA_OK=true
else
    echo -e "${YLW}  ○ Ollama offline (start with: OLLAMA_ORIGINS=* ollama serve)${NC}"
fi

LMSTUDIO_OK=false
if curl -sf http://localhost:1234/v1/models --max-time 2 >/dev/null 2>&1; then
    echo -e "${GRN}  ● LM Studio online${NC}"
    LMSTUDIO_OK=true
else
    echo -e "${YLW}  ○ LM Studio offline (start LM Studio → Local Server tab)${NC}"
fi

if [ -n "$OPENROUTER_API_KEY" ]; then
    echo -e "${GRN}  ● OpenRouter key configured${NC}"
else
    echo -e "${YLW}  ○ OpenRouter not configured (export OPENROUTER_API_KEY=sk-or-...)${NC}"
fi

# ── Start backend ─────────────────────────────────────────────
echo ""
echo -e "${BLU}${BOLD}Starting backend server on port 8000...${NC}"
echo -e "${CYN}  ★ Open in browser: http://localhost:8000${NC}"
echo -e "${CYN}  API docs:          http://localhost:8000/api/docs${NC}"
echo -e "${YLW}  Press Ctrl+C to stop${NC}\n"

# Open browser at the backend URL (served mode — no CORS issues)
sleep 1.5 && {
  if [ "$(uname)" = "Darwin" ]; then
    open "http://localhost:8000" 2>/dev/null
  elif command -v xdg-open &>/dev/null; then
    xdg-open "http://localhost:8000" 2>/dev/null
  fi
} &

$PYTHON lab_backend_server.py
