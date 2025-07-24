@echo off
chcp 65001 >nul
echo ========================================
echo 会议室预订系统 - 停止所有服务
echo ========================================
echo.

echo [1/4] 停止前端服务...
taskkill /f /im node.exe /fi "WINDOWTITLE eq Frontend Server*" >nul 2>&1
echo ✅ 前端服务已停止

echo [2/4] 停止后端服务...
taskkill /f /im node.exe /fi "WINDOWTITLE eq Backend Server*" >nul 2>&1
echo ✅ 后端服务已停止

echo [3/4] 停止 Redis 服务...
taskkill /f /im redis-server.exe >nul 2>&1
echo ✅ Redis 服务已停止

echo [4/4] 停止 MySQL 服务...
net stop MySQL80 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL 服务已停止
) else (
    echo ⚠️  MySQL 服务可能已经停止或需要手动停止
)

echo.
echo ========================================
echo 🎉 所有服务已停止！
echo ========================================
echo.
pause 