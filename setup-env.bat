@echo off
chcp 65001 >nul
echo ========================================
echo 会议室预订系统 - 环境变量配置脚本
echo ========================================
echo.

echo [1/3] 配置后端环境变量...
cd apparel_admin_back\src

if exist .env (
    echo ✅ 后端环境变量文件已存在
) else (
    echo 正在创建后端环境变量文件...
    copy env.example .env >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ 后端环境变量文件创建成功
    ) else (
        echo ❌ 后端环境变量文件创建失败
        pause
        exit /b 1
    )
)
echo.

echo [2/3] 配置前端环境变量...
cd ..\..\vue3-admin-dashboard

if exist .env (
    echo ✅ 前端环境变量文件已存在
) else (
    echo 正在创建前端环境变量文件...
    copy env.example .env >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ 前端环境变量文件创建成功
    ) else (
        echo ❌ 前端环境变量文件创建失败
        pause
        exit /b 1
    )
)
echo.

echo [3/3] 创建数据库...
cd ..\apparel_admin_back\src
echo 正在创建数据库...

mysql -u root -pwoaini520. -e "CREATE DATABASE IF NOT EXISTS meeting_room_booking_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
if %errorlevel% equ 0 (
    echo ✅ 数据库创建成功
) else (
    echo ⚠️  数据库可能已存在或创建失败
    echo 请手动检查数据库状态
)
echo.

echo ========================================
echo 🎉 环境变量配置完成！
echo ========================================
echo.
echo 📝 配置说明：
echo   后端环境变量文件: apparel_admin_back/src/.env
echo   前端环境变量文件: vue3-admin-dashboard/.env
echo.
echo 💡 提示：
echo   - 请根据实际情况修改环境变量中的敏感信息
echo   - 特别是数据库密码、JWT密钥、API密钥等
echo   - 七牛云配置需要根据你的实际账号进行修改
echo.
pause 