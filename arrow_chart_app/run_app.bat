@echo off
:: バッチファイルの存在するディレクトリに移動
cd /d "%~dp0"

:: ビルド成果物のディレクトリに移動
cd build\web

:: 古いキャッシュを完全にバイパスするため、新しいポート（8088）で起動します
start /b py -m http.server 8088

:: サーバーの起動待ち
timeout /t 2 /nobreak >nul

:: 強力なキャッシュ（Service Worker等）を無効化するため、Chromeのシークレットモードで開く
start "" chrome --incognito "http://localhost:8088"
exit
