#!/usr/bin/env python3
"""
確実にXサーバーにデプロイするスクリプト
Usage: python3 deploy.py
"""

import ftplib
import os
import sys
from pathlib import Path

# FTP設定
FTP_HOST = "sv16565.xserver.jp"
FTP_USER = "xs842747"
FTP_PASS = "J.JTAuM8yQ"
FTP_DIR = "public_html"
LOCAL_FILE = "index.html"

def deploy_to_xserver():
    """Xサーバーにファイルをアップロード"""
    print("🚀 Xサーバーへのデプロイを開始...")
    
    # ファイル存在確認
    if not Path(LOCAL_FILE).exists():
        print(f"❌ エラー: {LOCAL_FILE} が見つかりません")
        return False
    
    try:
        print(f"📁 {LOCAL_FILE} を確認中...")
        file_size = Path(LOCAL_FILE).stat().st_size
        print(f"   ファイルサイズ: {file_size:,} bytes")
        
        # ファイル内容確認
        with open(LOCAL_FILE, 'r', encoding='utf-8') as f:
            content = f.read()
            if 'hiro' in content:
                print("   ✅ ファイルに 'hiro' が含まれています")
            else:
                print("   ⚠️  'hiro' が見つかりません")
        
        print(f"🌐 {FTP_HOST} に接続中...")
        
        # FTP接続（パッシブモード）
        ftp = ftplib.FTP()
        ftp.set_pasv(True)  # パッシブモード
        ftp.set_debuglevel(1)  # デバッグ情報表示
        
        print(f"   接続先: {FTP_HOST}:21")
        print(f"   ユーザー: {FTP_USER}")
        print(f"   パスワード長: {len(FTP_PASS)}文字")
        
        ftp.connect(FTP_HOST, 21)
        
        # より詳細なログイン試行
        try:
            response = ftp.login(FTP_USER, FTP_PASS)
            print(f"   ログイン応答: {response}")
        except ftplib.error_perm as e:
            print(f"   ❌ ログインエラー: {e}")
            # 別のユーザー名を試行（サーバーIDそのもの）
            print("   代替ユーザー名で再試行...")
            ftp.login("xs842747", FTP_PASS)  # 明示的に同じ値で再試行
        
        print("   ✅ FTP接続成功")
        
        # ディレクトリ変更
        ftp.cwd(FTP_DIR)
        print(f"   📂 ディレクトリ変更: {FTP_DIR}")
        
        # ファイルアップロード
        print(f"   📤 {LOCAL_FILE} をアップロード中...")
        with open(LOCAL_FILE, 'rb') as f:
            ftp.storbinary(f'STOR {LOCAL_FILE}', f)
        
        # アップロード確認
        files = ftp.nlst()
        if LOCAL_FILE in files:
            print("   ✅ アップロード確認完了")
        else:
            print("   ❌ アップロード確認失敗")
            return False
        
        # 接続終了
        ftp.quit()
        
        print("🎉 デプロイ完了！")
        print("🌐 サイトURL: https://hironoristudio.com/")
        print("   数分後に変更が反映されます")
        
        return True
        
    except ftplib.all_errors as e:
        print(f"❌ FTPエラー: {e}")
        return False
    except Exception as e:
        print(f"❌ エラー: {e}")
        return False

if __name__ == "__main__":
    print("=" * 50)
    print("  Xサーバー自動デプロイスクリプト")
    print("=" * 50)
    
    success = deploy_to_xserver()
    
    if success:
        print("\n✅ デプロイ成功！")
        sys.exit(0)
    else:
        print("\n❌ デプロイ失敗")
        sys.exit(1)