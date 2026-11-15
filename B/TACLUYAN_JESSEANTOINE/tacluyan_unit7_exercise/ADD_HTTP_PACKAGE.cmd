@echo off
cd /d "%~dp0"
echo Adding the Flutter http package...
flutter pub add http
if errorlevel 1 (
  echo.
  echo The package was not added. Check that Flutter is installed and this file is in your Flutter project root.
  pause
  exit /b 1
)
echo.
echo The http package was added successfully.
pause
