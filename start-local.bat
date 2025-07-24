@echo off
chcp 65001 >nul
echo ========================================
echo 服装店管理系统 - 本地开发环境启动
echo ========================================
echo.

echo [1/3] 启动前端服务...
cd vue3-admin-dashboard
start "Frontend" cmd /k "yarn dev"
cd ..

echo [2/3] 启动后端服务...
cd meetting_room_booking_system_backend
start "Backend" cmd /k "yarn start:dev"
cd ..

echo [3/3] 等待服务启动...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo 🎉 服务启动完成！
echo ========================================
echo.
echo 📍 访问地址：
echo    前端: http://localhost:5173
echo    后端: http://localhost:3333
echo    API文档: http://localhost:3333/api
echo.
echo ⚠️  注意：后端可能需要数据库连接
echo    如果看到数据库连接错误，请：
echo    1. 安装本地MySQL
echo    2. 或者等待Docker网络问题解决
echo.
echo 💡 提示：
echo    - 前端使用localStorage存储数据
echo    - 后端API暂时不可用（需要数据库）
echo    - 可以先使用前端功能
echo.
pause 