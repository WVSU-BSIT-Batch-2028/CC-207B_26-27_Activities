@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0FIX_MOVIES_AND_OMDB.ps1"
if errorlevel 1 (
  echo.
  echo The fix did not complete. Read the message above.
  pause
  exit /b 1
)
echo.
pause
