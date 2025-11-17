# 114-1_FCU_Software-Engineering-Practice

Flask 模組化網頁應用程式專案

## 專案結構

```
src/
├── app.py                 # 主應用程式（自動載入所有模組）
├── modules/               # 模組資料夾（每個開發者的模組放在這裡）
│   ├── home/             # 範例模組：首頁與靜態頁面
│   ├── user/             # 使用者登入模組（Blueprint: user_bp）
│   └── README.md         # 模組開發指南
├── services/             # 共用服務（例如資料庫連線）
├── templates/            # HTML 模板資料夾
│   ├── home/            # 各模組的模板（建議按模組分資料夾）
│   └── user/
└── requirements.txt      # Python 依賴套件
```

## 快速開始

### 方式一：使用自動安裝腳本（推薦）

```bash
# 執行安裝腳本（會自動安裝系統依賴和 Python 套件）
./install.sh
```

### 方式二：手動安裝

### 1. 安裝系統依賴（僅首次需要）

**macOS (使用 Homebrew):**
```bash
# 安裝 MariaDB Connector/C（mariadb Python 套件需要）
brew install mariadb-connector-c

# 設置編譯環境變數（可選，加入 ~/.zshrc 以永久生效）
export LDFLAGS="-L/opt/homebrew/opt/mariadb-connector-c/lib"
export CPPFLAGS="-I/opt/homebrew/opt/mariadb-connector-c/include"
export PATH="/opt/homebrew/opt/mariadb-connector-c/bin:$PATH"
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install libmariadb-dev
```

**Linux (CentOS/RHEL):**
```bash
sudo yum install mariadb-devel
```

### 2. 安裝 Python 依賴

```bash
# 啟動虛擬環境
source venv/bin/activate

# 安裝套件（如果已設置環境變數，可直接執行）
pip install -r src/requirements.txt

# 如果未設置環境變數，macOS 用戶可一次性執行：
# LDFLAGS="-L/opt/homebrew/opt/mariadb-connector-c/lib" \
# CPPFLAGS="-I/opt/homebrew/opt/mariadb-connector-c/include" \
# PATH="/opt/homebrew/opt/mariadb-connector-c/bin:$PATH" \
# pip install -r src/requirements.txt
```

### 3. 運行應用程式

```bash
cd src
python app.py
```

應用程式將在 `http://localhost:5000` 啟動

## 模組化開發

此專案採用模組化架構，使用 Flask Blueprint 實現。每個開發者可以獨立開發自己的模組，無需修改主應用程式。

### 如何創建新模組

詳細說明請參考：[`src/modules/README.md`](src/modules/README.md)

**快速步驟：**

1. 在 `modules/` 資料夾中創建新資料夾（例如：`user`）
2. 創建 `__init__.py` 和 `routes.py`
3. 在 `__init__.py` 中創建 Blueprint（變數名必須是 `{模組名}_bp`）
4. 在 `routes.py` 中定義路由
5. 運行應用程式，模組會自動載入

### 範例模組

查看 `modules/home/` 與 `modules/user/` 作為參考範例。

## 開發規範

- 每個模組應該有獨立的資料夾
- Blueprint 變數命名：`{模組名}_bp`
- 模板建議放在 `templates/{模組名}/` 資料夾中
- 主應用程式會自動掃描並載入所有模組

## 使用者登入與資料庫安全

- 新增 `/auth/login` 路由（`user` 模組）提供登入介面
- 所有登入查詢透過 `services/db.py` 使用參數化查詢，防止 SQL Injection
- 密碼驗證採用 `werkzeug.security.check_password_hash`

### 資料庫環境變數

可透過環境變數或 `app.config['DB_CONFIG']` 設定 MariaDB 連線資訊：

| 變數        | 預設值    | 說明             |
|-------------|-----------|------------------|
| `DB_HOST`   | 127.0.0.1 | 資料庫主機       |
| `DB_PORT`   | 3306      | 資料庫連接埠     |
| `DB_USER`   | root      | 使用者名稱       |
| `DB_PASSWORD` | 空字串  | 使用者密碼       |
| `DB_NAME`   | app_db    | 目標資料庫       |

請於正式環境設置 `SECRET_KEY` 與上述資料庫參數。

## 技術棧

- Python 3.x
- Flask >= 3.0.0
- mariadb >= 1.1.10
