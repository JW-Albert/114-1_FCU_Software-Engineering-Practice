# 114-1_FCU_Software-Engineering-Practice

Flask 模組化網頁應用程式專案

## 專案結構

```
.
├── ENV/                  # 環境變數資料夾（需自行建立）
│   ├── .env             # 環境變數檔案（不提交到版本控制）
│   └── .env.example    # 環境變數範例檔案
├── dataset/             # 資料集資料夾
│   ├── restaurants.csv  # 餐廳資料 CSV 檔案
│   ├── menu_items.csv   # 餐點資料 CSV 檔案
│   └── app.py           # 資料生成腳本
├── docs/                # 文件資料夾
│   ├── Database_Schema.md # 資料庫結構文件
│   ├── Models_Implementation.md # 資料模型實作文件
│   ├── Restaurant_API.md # Restaurant API 文件
│   ├── Class Diagram.jpg # 類別圖
│   └── Use Case Diagram.jpg # 使用案例圖
├── sql/                 # SQL 腳本資料夾
│   ├── 001_create_tables.sql # 建立資料表 SQL
│   ├── 002_insert_sample_data.sql # 插入範例資料 SQL
│   └── SQL.sh           # SQL 執行腳本
├── deploy.sh            # 部署腳本（建立虛擬環境並安裝依賴）
├── run.sh               # 運行腳本（啟動應用程式）
├── Ubuntu24.sh          # Ubuntu 24.04 系統依賴安裝腳本
├── src/
│   ├── app.py           # 主應用程式（自動載入所有模組）
│   ├── modules/         # 模組資料夾（每個開發者的模組放在這裡）
│   │   └── frontend/   # 前端模組（Blueprint: frontend_bp）
│   ├── services/        # 共用服務
│   │   └── db.py        # 資料庫連線服務
│   └── templates/       # HTML 模板資料夾
│       └── frontend/   # 前端模組的模板
└── requirements.txt     # Python 依賴套件（需在專案根目錄建立）
```

**重要：** 以下目錄為程式碼中引用但尚未建立，**必須建立**才能正常運行：
- `src/models/` - 資料模型（`app.py` 和 `modules/frontend/routes.py` 中有引用）
  - 需要包含：`filter_criteria.py` 等
- `src/data/` - 範例資料（`modules/frontend/routes.py` 中有引用）
  - 需要包含：`sample_data.py` 等
- `src/utils/` - 工具模組（`app.py` 和 `modules/frontend/routes.py` 中有引用）
  - 需要包含：`debug.py`（提供 `DEBUG_PRINT`, `INFO_PRINT`, `WARN_PRINT`, `ERROR_PRINT` 函數）
- `src/services/search_service.py` - 搜尋服務（`modules/frontend/routes.py` 中有引用）

詳細的模組結構請參考 [`docs/Models_Implementation.md`](docs/Models_Implementation.md)

## 快速開始

### 方式一：使用自動化腳本（推薦）

**步驟 1：安裝系統依賴（僅首次需要，Ubuntu 24.04）**

```bash
# 執行系統依賴安裝腳本
bash Ubuntu24.sh
```

此腳本會自動安裝：
- MariaDB 資料庫伺服器
- Python 3 及相關工具（pip, venv）

**步驟 2：部署專案**

```bash
# 執行部署腳本（建立虛擬環境並安裝 Python 依賴）
bash deploy.sh
```

此腳本會自動：
- 建立 Python 虛擬環境（venv）
- 啟動虛擬環境
- 安裝 requirements.txt 中的套件

**注意：** 如果 `src/requirements.txt` 不存在，請先建立或手動安裝套件：
```bash
pip install flask python-dotenv mariadb
```

**步驟 3：運行應用程式**

```bash
# 執行運行腳本
bash run.sh
```

此腳本會自動：
- 啟動虛擬環境
- 運行 Flask 應用程式

應用程式將在 `http://localhost:5000` 啟動

**重要：** 在運行應用程式前，必須先建立以下目錄和檔案：
- `src/models/` 及其相關檔案
- `src/data/` 及其相關檔案  
- `src/utils/` 及其相關檔案
- `src/services/search_service.py`
否則應用程式會因為導入錯誤而無法啟動

### 方式二：手動安裝

**步驟 1：安裝系統依賴**

**Ubuntu 24.04:**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv libmariadb-dev
```

**步驟 2：創建虛擬環境並安裝 Python 依賴**

```bash
# 創建虛擬環境
python3 -m venv venv

# 啟動虛擬環境
source venv/bin/activate

# 安裝套件（如果專案根目錄有 requirements.txt）
# 或手動安裝必要套件：
pip install flask python-dotenv mariadb

# 重要：在運行應用程式前，必須先建立以下目錄和檔案：
# - src/models/ 及其相關檔案
# - src/data/ 及其相關檔案  
# - src/utils/ 及其相關檔案
# - src/services/search_service.py
# 否則應用程式會因為導入錯誤而無法啟動
```

**步驟 3：運行應用程式**

```bash
# 啟動虛擬環境
source venv/bin/activate

# 運行應用程式
python3 src/app.py
```

應用程式將在 `http://localhost:5000` 啟動

### 4. 設定環境變數

```bash
# 建立 ENV 資料夾（如果不存在）
mkdir -p ENV

# 建立 .env 檔案，填入正確的資料庫帳號密碼與系統設定
nano ENV/.env
```

應用程式會自動從 `ENV/.env` 檔案載入環境變數。如果檔案不存在，應用程式會使用預設值。

**範例 .env 檔案內容：**
```bash
SECRET_KEY=your-secret-key-here
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your-password
DB_NAME=data
DEBUG_MODE=0
VERBOSE_MODE=0
ERROR_OUTPUT=1
```

## 模組化開發

此專案採用模組化架構，使用 Flask Blueprint 實現。每個開發者可以獨立開發自己的模組，無需修改主應用程式。

### 如何創建新模組

**快速步驟：**

1. 在 `src/modules/` 資料夾中創建新資料夾（例如：`user`）
2. 創建 `__init__.py` 和 `routes.py`
3. 在 `__init__.py` 中創建 Blueprint（變數名必須是 `{模組名}_bp`）
4. 在 `routes.py` 中定義路由
5. 運行應用程式，模組會自動載入

**範例：**

```python
# src/modules/user/__init__.py
from flask import Blueprint
user_bp = Blueprint('user', __name__, url_prefix='/user')
from . import routes

# src/modules/user/routes.py
from . import user_bp
@user_bp.route('/')
def index():
    return "User Module"
```

### 現有模組

- **frontend 模組** (`src/modules/frontend/`): 前端頁面模組，提供餐廳搜尋、列表、詳情等功能
  - Blueprint: `frontend_bp`
  - 模板位置: `src/templates/frontend/`
  - 依賴模組：`services.search_service`, `models.filter_criteria`, `data.sample_data`, `utils.debug`

### 參考文件

詳細的 API 和功能說明請參考：
- [`docs/Restaurant_API.md`](docs/Restaurant_API.md) - Restaurant API 文件
- [`docs/Models_Implementation.md`](docs/Models_Implementation.md) - 資料模型實作文件

## 開發規範

- 每個模組應該有獨立的資料夾
- Blueprint 變數命名：`{模組名}_bp`（例如：`frontend_bp`, `user_bp`）
- 模板建議放在 `src/templates/{模組名}/` 資料夾中
- 主應用程式會自動掃描 `src/modules/` 並載入所有模組
- 模組導入路徑：從 `src/` 目錄開始（例如：`from services.db import ...`）

## 資料庫安全

- 所有資料庫查詢透過 `services/db.py` 使用參數化查詢，防止 SQL Injection
- 密碼驗證採用 `werkzeug.security.check_password_hash`

### 資料庫環境變數

可透過 `ENV/.env` 檔案或環境變數設定 MariaDB 連線資訊：

| 變數        | 預設值    | 說明             |
|-------------|-----------|------------------|
| `SECRET_KEY` | dev-secret-key | Flask 密鑰（正式環境請更改） |
| `DB_HOST`   | 127.0.0.1 | 資料庫主機       |
| `DB_PORT`   | 3306      | 資料庫連接埠     |
| `DB_USER`   | root      | 使用者名稱       |
| `DB_PASSWORD` | 空字串  | 使用者密碼       |
| `DB_NAME`   | data      | 目標資料庫（與 SQL 腳本對齊） |

**設定方式：**
1. 在 `ENV/` 資料夾中建立 `.env` 檔案（可參考 `ENV/.env.example`）
2. 編輯 `ENV/.env` 檔案填入正確的值
3. 應用程式會自動載入 `ENV/.env` 檔案中的設定

請於正式環境設置 `SECRET_KEY` 與上述資料庫參數。

### 資料庫初始化

在首次使用前，需要初始化資料庫結構：

**方式一：使用 SQL 腳本（推薦）**

```bash
# 進入 sql 目錄
cd sql

# 使用提供的 SQL.sh 腳本執行（需要修改腳本中的使用者名稱和密碼）
bash SQL.sh

# 或手動執行 SQL 腳本（請根據實際資料庫設定調整參數）
mysql -P 3306 -u root -p data < 001_create_tables.sql
mysql -P 3306 -u root -p data < 002_insert_sample_data.sql
```

**SQL.sh 腳本說明：**
- 位置：`sql/SQL.sh`
- 功能：連線到 MySQL/MariaDB，對 `data` 資料庫執行建表
- 預設設定：連接埠 3306，使用者 `user`
- 使用前請先修改腳本中的資料庫連線資訊（使用者名稱、密碼等）
- 腳本會執行 `001_create_tables.sql` 建立資料表
- 插入範例資料的指令已註解，如需插入請取消註解並修改路徑

**方式二：使用 MySQL 客戶端手動執行**

```bash
# 連線到 MySQL
mysql -u root -p

# 建立資料庫（如果尚未建立）
CREATE DATABASE IF NOT EXISTS data;

# 在 MySQL 中執行
USE data;
source sql/001_create_tables.sql
source sql/002_insert_sample_data.sql

# 注意：如果從專案根目錄執行，路徑為 sql/001_create_tables.sql
# 如果從其他目錄執行，請使用絕對路徑或先切換到專案根目錄
```

**方式三：參考文件手動執行**

參考 [`docs/Database_Schema.md`](docs/Database_Schema.md) 中的 SQL 語句手動執行。

**注意：** SQL 腳本使用的資料庫名稱為 `data`，請確保資料庫已建立或修改腳本中的資料庫名稱。

詳細的資料庫結構說明請參考：[`docs/Database_Schema.md`](docs/Database_Schema.md)

### 程式訊息輸出控制（類似 #ifdef）

可透過環境變數控制程式訊息的輸出，類似 C/C++ 的 `#ifdef` 功能：

| 變數        | 預設值 | 說明             |
|-------------|--------|------------------|
| `DEBUG_MODE` | 0      | 啟用除錯訊息輸出（`DEBUG_PRINT`） |
| `VERBOSE_MODE` | 0    | 啟用詳細訊息輸出（`INFO_PRINT`, `WARN_PRINT`） |
| `ERROR_OUTPUT` | 1    | 錯誤訊息輸出（預設啟用） |

**使用方式：**

在程式碼中使用條件輸出函數：

```python
from utils.debug import DEBUG_PRINT, INFO_PRINT, WARN_PRINT, ERROR_PRINT

DEBUG_PRINT("這是一個除錯訊息")  # 只在 DEBUG_MODE=1 時輸出
INFO_PRINT("這是一個資訊訊息")   # 只在 VERBOSE_MODE=1 或 DEBUG_MODE=1 時輸出
WARN_PRINT("這是一個警告訊息")   # 只在 VERBOSE_MODE=1 或 DEBUG_MODE=1 時輸出
ERROR_PRINT("這是一個錯誤訊息")  # 預設總是輸出（除非 ERROR_OUTPUT=0）
```

在 `ENV/.env` 檔案中設定：

```bash
DEBUG_MODE=1      # 啟用除錯模式
VERBOSE_MODE=1    # 啟用詳細模式
ERROR_OUTPUT=1    # 啟用錯誤輸出（預設）
```

## 執行腳本說明

專案提供了多個自動化腳本，方便快速部署和運行：

### Ubuntu24.sh

**功能：** 安裝 Ubuntu 24.04 系統依賴

**執行方式：**
```bash
bash Ubuntu24.sh
```

**執行內容：**
- 更新系統套件清單
- 升級系統套件
- 安裝 MariaDB 資料庫伺服器
- 安裝 Python 3、pip、venv

**注意：** 需要 sudo 權限

### deploy.sh

**功能：** 部署專案（建立虛擬環境並安裝依賴）

**執行方式：**
```bash
bash deploy.sh
```

**執行內容：**
- 建立 Python 虛擬環境（venv）
- 啟動虛擬環境
- 安裝 `src/requirements.txt` 中的套件

**前置需求：**
- 已安裝 Python 3 和 pip
- `src/requirements.txt` 檔案存在（或手動安裝套件）

### run.sh

**功能：** 運行 Flask 應用程式

**執行方式：**
```bash
bash run.sh
```

**執行內容：**
- 啟動虛擬環境
- 執行 `python3 src/app.py`

**前置需求：**
- 已執行 `deploy.sh` 或手動建立虛擬環境
- 已建立必要的模組目錄（models, data, utils, services）

### sql/SQL.sh

**功能：** 執行資料庫初始化 SQL 腳本

**執行方式：**
```bash
cd sql
bash SQL.sh
```

**執行內容：**
- 連線到 MySQL/MariaDB 資料庫
- 執行 `001_create_tables.sql` 建立資料表

**使用前請修改：**
- 資料庫連線資訊（使用者名稱、密碼、連接埠）
- 預設設定：連接埠 3306，使用者 `user`，資料庫 `data`

**注意：** 插入範例資料的指令已註解，如需插入請取消註解並修改路徑

## 技術棧

- Python 3.x
- Flask >= 3.0.0
- mariadb >= 1.1.10
