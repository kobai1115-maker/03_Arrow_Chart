@echo off
chcp 65001 > nul
setlocal
cd /d "%~dp0arrow_chart_app"

taskkill /F /IM dart.exe /T > nul 2>&1
taskkill /F /IM flutter.exe /T > nul 2>&1

rem // Cache cleanup disabled for speed
rem if exist "build" rmdir /s /q "build"
rem if exist ".dart_tool" rmdir /s /q ".dart_tool"

rem // pubspec.yaml sync disabled
rem call flutter pub get

rem // Fixed port for stability
call flutter run -d chrome --web-port=8080

if %errorlevel% neq 0 (
    echo [ERROR] Failed to start. 
    pause
)
endlocal
