@echo off
setlocal
cd /d "%~dp0"
if not exist "omdb-key.txt" (
  echo Create omdb-key.txt in this folder and paste your OMDb API key into it.
  pause
  exit /b 1
)
set /p OMDB_KEY=<"omdb-key.txt"
if "%OMDB_KEY%"=="" (
  echo omdb-key.txt is empty. Paste your OMDb API key into it first.
  pause
  exit /b 1
)
echo Starting the Unit 7 Profile Shelf app in Chrome...
flutter run -d chrome --dart-define=OMDB_KEY=%OMDB_KEY% --dart-define=CMS_URL=http://localhost:1337
pause
