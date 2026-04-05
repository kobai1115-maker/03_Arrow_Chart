@echo off
chcp 65001 >nul
echo.
echo ========================================
echo  関係性ダイアグラム — GitHub プッシュ
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] 変更ファイルを追加中...
git add .

echo.
echo [2/4] コミットメッセージを入力してください:
echo （例: アプリ名を変更、バグ修正、など）
echo.
set /p COMMIT_MSG="メッセージ: "

if "%COMMIT_MSG%"=="" set COMMIT_MSG=更新

echo.
echo [3/4] コミット中...
git commit -m "%COMMIT_MSG%"

echo.
echo [4/4] GitHubにプッシュ中...
git push origin main

echo.
echo ========================================
echo  完了！約2〜3分後にWebサイトが更新されます
echo  URL: https://kobai1115-maker.github.io/03_Arrow_Chart/
echo ========================================
echo.
pause
