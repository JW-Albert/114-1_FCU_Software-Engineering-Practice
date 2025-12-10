-- 資料庫初始化 SQL 腳本
-- 用於建立資料庫表格與欄位

-- 建立資料庫（如果不存在）
CREATE DATABASE IF NOT EXISTS `app_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用資料庫
USE `app_db`;

-- 建立 users 資料表（與 sql/001_create_tables.sql 結構一致）
CREATE TABLE IF NOT EXISTS `users` (
    `userID`          INT AUTO_INCREMENT PRIMARY KEY COMMENT '使用者 ID',
    `username`         VARCHAR(50) NOT NULL UNIQUE COMMENT '使用者名稱',
    `hashedPassword`  VARCHAR(255) NOT NULL COMMENT '密碼雜湊值',
    `mode`            ENUM('NORMAL', 'FITNESS') DEFAULT 'NORMAL' COMMENT '模式',
    `budget`          DECIMAL(8,2) DEFAULT 0 COMMENT '單餐預算上限',
    `targetCalories`  INT COMMENT '目標熱量',
    `targetProtein`   FLOAT COMMENT '目標蛋白質',
    `targetFat`       FLOAT COMMENT '目標脂肪',
    `created_at`      DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    INDEX `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='使用者資料表';

