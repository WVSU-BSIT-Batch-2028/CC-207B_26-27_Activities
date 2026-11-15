@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0FIX_BOOK_SEARCH.ps1"
if errorlevel 1 (
  echo.
  echo The fix was not applied. Please send a photo of this window.
  pause
  exit /b 1
)
echo.
pause
