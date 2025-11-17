#!/bin/bash
# 安裝腳本：自動安裝系統依賴和 Python 套件

set -e

echo "🚀 開始安裝專案依賴..."

# 檢測作業系統
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📦 檢測到 macOS，使用 Homebrew 安裝系統依賴..."
    
    # 檢查 Homebrew 是否安裝
    if ! command -v brew &> /dev/null; then
        echo "❌ 未找到 Homebrew，請先安裝 Homebrew："
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    # 檢查是否已安裝 mariadb-connector-c
    if ! brew list mariadb-connector-c &> /dev/null; then
        echo "📥 安裝 MariaDB Connector/C..."
        brew install mariadb-connector-c
    else
        echo "✅ MariaDB Connector/C 已安裝"
    fi
    
    # 設置環境變數
    export LDFLAGS="-L/opt/homebrew/opt/mariadb-connector-c/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/mariadb-connector-c/include"
    export PATH="/opt/homebrew/opt/mariadb-connector-c/bin:$PATH"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "📦 檢測到 Linux，安裝系統依賴..."
    
    if command -v apt-get &> /dev/null; then
        echo "📥 使用 apt-get 安裝..."
        sudo apt-get update
        sudo apt-get install -y libmariadb-dev
    elif command -v yum &> /dev/null; then
        echo "📥 使用 yum 安裝..."
        sudo yum install -y mariadb-devel
    else
        echo "⚠️  無法自動檢測套件管理器，請手動安裝 libmariadb-dev 或 mariadb-devel"
    fi
else
    echo "⚠️  未支援的作業系統：$OSTYPE"
    echo "   請手動安裝 MariaDB Connector/C 或 libmariadb-dev"
fi

# 檢查虛擬環境
if [ ! -d "venv" ]; then
    echo "📦 創建虛擬環境..."
    python3 -m venv venv
fi

# 啟動虛擬環境並安裝 Python 套件
echo "📥 安裝 Python 套件..."
source venv/bin/activate
pip install --upgrade pip
pip install -r src/requirements.txt

echo "✅ 安裝完成！"
echo ""
echo "下一步："
echo "  1. 啟動虛擬環境：source venv/bin/activate"
echo "  2. 運行應用程式：cd src && python app.py"

