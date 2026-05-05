@echo off
REM ═══════════════════════════════════════════════════════════════
REM  LLM Vuln Lab — Start Script (Windows)
REM  Double-click this file or run: start.bat
REM ═══════════════════════════════════════════════════════════════

title LLM Vuln Lab

echo.
echo  ██╗     ██╗     ███╗   ███╗    ██╗   ██╗██╗   ██╗██╗     ███╗   ██╗
echo  ██║     ██║     ████╗ ████║    ██║   ██║██║   ██║██║     ████╗  ██║
echo  ██║     ██║     ██╔████╔██║    ██║   ██║██║   ██║██║     ██╔██╗ ██║
echo  ██║     ██║     ██║╚██╔╝██║    ╚██╗ ██╔╝██║   ██║██║     ██║╚██╗██║
echo  ███████╗███████╗██║ ╚═╝ ██║     ╚████╔╝ ╚██████╔╝███████╗██║ ╚████║
echo  ╚══════╝╚══════╝╚═╝     ╚═╝      ╚═══╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝
echo.
echo                   LOCAL LLM SECURITY TRAINING PLATFORM
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Download from https://python.org
    pause
    exit /b 1
)

echo [OK] Python found
echo.

REM Install dependencies
echo [INFO] Checking Python dependencies...
python -m pip install fastapi uvicorn httpx --quiet
echo [OK] Dependencies ready
echo.

REM Detect providers
echo [INFO] Detecting LLM providers...

curl -sf http://localhost:11434/api/tags --max-time 2 >nul 2>&1
if not errorlevel 1 (
    echo [OK] Ollama is running
) else (
    echo [WARN] Ollama offline - start with: ollama serve
)

curl -sf http://localhost:1234/v1/models --max-time 2 >nul 2>&1
if not errorlevel 1 (
    echo [OK] LM Studio is running
) else (
    echo [WARN] LM Studio offline - open app then click Local Server - Start
)

if defined OPENROUTER_API_KEY (
    echo [OK] OpenRouter key configured
) else (
    echo [WARN] OpenRouter not configured - set: set OPENROUTER_API_KEY=sk-or-...
)

echo.
echo [INFO] Starting backend on http://localhost:8000
echo [INFO] *** Open in browser: http://localhost:8000 ***
echo [INFO] Press Ctrl+C to stop
echo.

REM Open browser at served URL (avoids CORS/file:// issues)
start "" cmd /c "timeout /t 2 >nul && start http://localhost:8000"

python lab_backend_server.py
pause
