@echo off
chcp 65001 >nul
echo ========================================
echo 会议室预订系统 - 一键启动脚本
echo ========================================
echo.

:: 检查是否安装了必要的软件
echo [1/7] 检查环境...
where mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ MySQL 未安装或未添加到 PATH
    echo 请先安装 MySQL 并确保 mysql 命令可用
    pause
    exit /b 1
)

where redis-server >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Redis 未安装或未添加到 PATH
    echo 请先安装 Redis 并确保 redis-server 命令可用
    pause
    exit /b 1
)

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装或未添加到 PATH
    echo 请先安装 Node.js 并确保 node 命令可用
    pause
    exit /b 1
)

echo ✅ 环境检查通过
echo.

:: 配置环境变量
echo [2/7] 配置环境变量...
call setup-env.bat >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 环境变量配置完成
) else (
    echo ⚠️  环境变量配置可能失败，请手动检查
    echo 请手动运行 setup-env.bat 配置环境变量
)
echo.

:: 启动 MySQL
echo [3/7] 启动 MySQL 服务...
net start MySQL80 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL 服务启动成功
) else (
    echo ⚠️  MySQL 服务可能已经在运行或启动失败
    echo 请手动检查 MySQL 服务状态
)
echo.

:: 启动 Redis
echo [4/7] 启动 Redis 服务...
start "Redis Server" /min redis-server
timeout /t 2 /nobreak >nul
echo ✅ Redis 服务启动成功
echo.

:: 安装后端依赖
echo [5/7] 安装后端依赖...
cd meetting_room_booking_system_backend
if not exist node_modules (
    echo 正在安装后端依赖...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ 后端依赖安装失败
        pause
        exit /b 1
    )
) else (
    echo ✅ 后端依赖已存在
)
echo.

:: 启动后端服务
echo [6/7] 启动后端服务...
start "Backend Server" /min npm run start:dev
timeout /t 3 /nobreak >nul
echo ✅ 后端服务启动成功 (端口: 3333)
echo.

:: 安装前端依赖
echo [7/7] 安装前端依赖...
cd ..\vue3-admin-dashboard
if not exist node_modules (
    echo 正在安装前端依赖...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ 前端依赖安装失败
        pause
        exit /b 1
    )
) else (
    echo ✅ 前端依赖已存在
)
echo.

:: 启动前端服务
echo [7/7] 启动前端服务...
start "Frontend Server" /min npm run dev
timeout /t 3 /nobreak >nul
echo ✅ 前端服务启动成功 (端口: 5173)
echo.

echo ========================================
echo 🎉 所有服务启动完成！
echo ========================================
echo.
echo 📍 服务地址：
echo   前端: http://localhost:5173
echo   后端: http://localhost:3333
echo   API文档: http://localhost:3333/api
echo.
echo 📝 数据库配置：
echo   MySQL: localhost:3306
echo   Redis: localhost:6379
echo.
echo 💡 提示：
echo   - 按 Ctrl+C 可以停止当前脚本
echo   - 各个服务窗口可以独立关闭
echo   - 如需重启某个服务，请关闭对应窗口后重新运行此脚本
echo.
pause 