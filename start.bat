@echo off
setlocal

title LLM Vuln Lab

echo.
echo ========================================
echo   LLM Vuln Lab
echo   Local LLM Security Training Platform
echo ========================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Download and install Python from https://python.org
    pause
    exit /b 1
)

echo [OK] Python found
echo.

echo [INFO] Checking Python dependencies...
python -m pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo [ERROR] Dependency installation failed. Try: python -m pip install -r requirements.txt
    pause
    exit /b 1
)
echo [OK] Dependencies ready
echo.

echo [INFO] Detecting optional LLM providers...

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
    echo [WARN] LM Studio offline - open LM Studio and start the Local Server
)

if defined OPENROUTER_API_KEY (
    echo [OK] OpenRouter key configured
) else (
    echo [WARN] OpenRouter not configured - optional: set OPENROUTER_API_KEY=sk-or-...
)

echo.
echo [INFO] Starting backend on http://localhost:8000
echo [INFO] Open in browser: http://localhost:8000
echo [INFO] Press Ctrl+C to stop
echo.

start "" cmd /c "timeout /t 2 >nul && start http://localhost:8000"

python lab_backend_server.py
pause
