#!/bin/bash
# アローチャートアプリ Web版 デプロイ用シェルスクリプト
# 実行権限を付与してから実行してください (chmod +x deploy.sh)

echo "========================================="
echo "Flutter Webアプリ ビルド＆デプロイ準備スクリプト"
echo "========================================="

echo "1. 依存関係の更新を行っています..."
flutter pub get

echo "2. Wasm最適化リリースビルドを実行しています..."
# --wasm オプションにより DartコードをWebAssemblyにコンパイルし、実行速度を向上させます
flutter build web --release --wasm --tree-shake-icons

if [ $? -eq 0 ]; then
  echo "✔ ビルドに成功しました。"
  echo "ビルド成果物は 'build/web/' フォルダに生成されています。"
  
  echo "========================================="
  echo "【Firebase Hosting にデプロイする場合】"
  echo "1. Firebase CLIツールがない場合はインストールしてください: npm install -g firebase-tools"
  echo "2. Firebase にログイン: firebase login"
  echo "3. プロジェクトの初期化: firebase init hosting"
  echo "  ・public directory をきかれたら『build/web』と入力してください"
  echo "  ・single-page app (SPA) にするかきかれたら『Yes』と入力してください"
  echo "4. デプロイ実行: firebase deploy --only hosting"
  echo "========================================="
else
  echo "❌ ビルドに失敗しました。エラーを確認してください。"
  exit 1
fi
