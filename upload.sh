#!/bin/bash

# Xサーバー FTP設定
FTP_HOST="sv16565.xserver.jp"
FTP_USER="xs842747"
FTP_PASS="J.JTAuM8yQ"
FTP_DIR="public_html"

echo "Xサーバーにアップロード中..."

# 方法1: curl with standard FTP (port 21)
echo "標準FTP (port 21) を試行中..."
curl -T index.html ftp://$FTP_HOST/$FTP_DIR/ --user $FTP_USER:$FTP_PASS --ftp-create-dirs

if [ $? -eq 0 ]; then
    echo "✅ アップロード完了！"
    echo "サイトURL: https://hironoristudio.com/"
    exit 0
fi

# 方法2: sftp風のアプローチ
echo "別の方法を試行中..."
curl -T index.html ftp://$FTP_HOST:21/$FTP_DIR/ --user $FTP_USER:$FTP_PASS --ftp-pasv

if [ $? -eq 0 ]; then
    echo "✅ アップロード完了！"
    echo "サイトURL: https://hironoristudio.com/"
else
    echo "❌ 自動アップロード失敗"
    echo ""
    echo "手動アップロード方法:"
    echo "1. https://www.xserver.ne.jp/ にログイン"
    echo "2. サーバー管理 → ファイル管理"
    echo "3. public_html フォルダに index.html をアップロード"
    exit 1
fi