#!/bin/bash

echo "🚀 最終自動デプロイ - SFTP版"
echo "================================"

# 設定
HOST="sv16565.xserver.jp"
USER="xs842747"
PASS="J.JTAuM8yQ"
FILE="index.html"

echo "📁 ファイル確認: $FILE"
if [ ! -f "$FILE" ]; then
    echo "❌ $FILE が見つかりません"
    exit 1
fi

echo "✅ ファイルサイズ: $(wc -c < $FILE) bytes"

echo "🌐 SFTP接続テスト中..."

# SFTPを使用したアップロード
sshpass -p "$PASS" sftp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" << EOF
cd public_html
put $FILE
ls -la $FILE
quit
EOF

if [ $? -eq 0 ]; then
    echo "✅ SFTP アップロード成功！"
    echo "🌐 https://hironoristudio.com/"
else
    echo "❌ SFTP失敗 - 標準FTPを試行..."
    
    # 標準FTP (ncftp使用)
    if command -v ncftp >/dev/null 2>&1; then
        echo "📤 ncftp でアップロード中..."
        ncftpput -u "$USER" -p "$PASS" "$HOST" public_html "$FILE"
        
        if [ $? -eq 0 ]; then
            echo "✅ ncftp アップロード成功！"
        else
            echo "❌ 自動アップロード失敗"
            echo ""
            echo "📋 手動アップロード手順:"
            echo "1. https://www.xserver.ne.jp/ にログイン"
            echo "2. サーバー管理 → ファイル管理"
            echo "3. public_html に $FILE をアップロード"
        fi
    else
        echo "⚠️  ncftp がインストールされていません"
        echo "brew install ncftp でインストールできます"
    fi
fi