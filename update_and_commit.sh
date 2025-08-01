#!/bin/bash

echo "🚀 ファイル更新とGitコミット"
echo "================================"

# Gitコミット
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 変更をコミット中..."
    git add .
    git commit -m "Update site content - $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "✅ Gitプッシュ完了"
else
    echo "ℹ️  変更がありません"
fi

echo ""
echo "🖥️  次に手動でアップロード:"
echo "1. https://www.xserver.ne.jp/ にログイン"
echo "2. サーバー管理 → ファイル管理"
echo "3. public_html フォルダに index.html をアップロード"
echo "4. https://hironoristudio.com/ で確認"
echo ""
echo "📁 ローカルファイル: $(pwd)/index.html"