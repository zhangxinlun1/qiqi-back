@echo off
chcp 65001 >nul
echo ========================================
echo 服装店管理系统 - 生产环境部署脚本
echo ========================================
echo.

:: 检查Docker是否安装
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker 未安装
    echo 请先安装 Docker: https://docs.docker.com/get-docker/
    pause
    exit /b 1
)

:: 检查Docker Compose是否安装
where docker-compose >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose 未安装
    echo 请先安装 Docker Compose: https://docs.docker.com/compose/install/
    pause
    exit /b 1
)

echo ✅ Docker 环境检查通过
echo.

:: 创建必要的目录
echo [1/5] 创建必要的目录...
if not exist nginx\ssl mkdir nginx\ssl
if not exist mysql\init mkdir mysql\init
if not exist logs mkdir logs

echo ✅ 目录创建完成
echo.

:: 检查环境变量文件
echo [2/5] 检查环境变量配置...

:: 检查后端环境变量
if not exist "meetting_room_booking_system_backend\src\.env" (
    echo ⚠️  后端环境变量文件不存在，正在创建...
    copy "meetting_room_booking_system_backend\src\env.example" "meetting_room_booking_system_backend\src\.env" >nul 2>&1
    echo ✅ 后端环境变量文件创建完成
) else (
    echo ✅ 后端环境变量文件已存在
)

:: 检查前端环境变量
if not exist "vue3-admin-dashboard\.env" (
    echo ⚠️  前端环境变量文件不存在，正在创建...
    copy "vue3-admin-dashboard\env.example" "vue3-admin-dashboard\.env" >nul 2>&1
    echo ✅ 前端环境变量文件创建完成
) else (
    echo ✅ 前端环境变量文件已存在
)

echo.

:: 停止现有服务
echo [3/5] 停止现有服务...
docker-compose -f docker-compose.prod.yml down
echo ✅ 现有服务已停止
echo.

:: 构建和启动服务
echo [4/5] 构建和启动服务...
docker-compose -f docker-compose.prod.yml up -d --build

if %errorlevel% equ 0 (
    echo ✅ 服务启动成功
) else (
    echo ❌ 服务启动失败
    pause
    exit /b 1
)

echo.

:: 等待服务启动
echo [5/5] 等待服务启动...
timeout /t 30 /nobreak >nul

:: 检查服务状态
echo ========================================
echo 🎉 部署完成！
echo ========================================
echo.

echo 📍 服务地址：
echo    前端: http://localhost
echo    后端API: http://localhost/api
echo    API文档: http://localhost/api
echo.

echo 📝 数据库配置：
echo    MySQL: localhost:3306
echo    Redis: localhost:6379
echo.

echo 🔧 管理命令：
echo    查看日志: docker-compose -f docker-compose.prod.yml logs -f
echo    停止服务: docker-compose -f docker-compose.prod.yml down
echo    重启服务: docker-compose -f docker-compose.prod.yml restart
echo    更新服务: docker-compose -f docker-compose.prod.yml up -d --build
echo.

echo 💡 提示：
echo    - 首次访问可能需要等待几分钟让服务完全启动
echo    - 数据库会自动创建表结构
echo    - 所有数据都会持久化保存
echo    - 如需配置HTTPS，请将SSL证书放入 nginx/ssl/ 目录
echo.

:: 显示服务状态
echo 📊 服务状态：
docker-compose -f docker-compose.prod.yml ps

pause 