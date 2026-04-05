@echo off
@chcp 65001 > nul
echo --------------------------------------------------
echo   Relationship Diagram SaaS - Startup Script
echo --------------------------------------------------
echo.
echo 1. Checking dependencies...
call flutter pub get

echo.
echo 2. Launching App (Google Chrome)...
echo Please wait for a few seconds.
echo.
call flutter run -d chrome

pause
