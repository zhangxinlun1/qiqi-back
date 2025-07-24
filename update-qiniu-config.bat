@echo off
echo 更新七牛云配置...
echo.

set /p ACCESS_KEY="请输入七牛云 Access Key: "
set /p SECRET_KEY="请输入七牛云 Secret Key: "
set /p BUCKET_NAME="请输入存储空间名称: "
set /p DOMAIN="请输入CDN域名: "

echo.
echo 正在更新配置文件...

REM 备份原文件
copy "meetting_room_booking_system_backend\src\.env" "meetting_room_booking_system_backend\src\.env.backup"

REM 更新七牛云配置
powershell -Command "(Get-Content 'meetting_room_booking_system_backend\src\.env') -replace 'QINIU_ACCESS_KEY=your-qiniu-access-key', 'QINIU_ACCESS_KEY=%ACCESS_KEY%' | Set-Content 'meetting_room_booking_system_backend\src\.env'"
powershell -Command "(Get-Content 'meetting_room_booking_system_backend\src\.env') -replace 'QINIU_SECRET_KEY=your-qiniu-secret-key', 'QINIU_SECRET_KEY=%SECRET_KEY%' | Set-Content 'meetting_room_booking_system_backend\src\.env'"
powershell -Command "(Get-Content 'meetting_room_booking_system_backend\src\.env') -replace 'QINIU_BUCKET_NAME=your-bucket-name', 'QINIU_BUCKET_NAME=%BUCKET_NAME%' | Set-Content 'meetting_room_booking_system_backend\src\.env'"
powershell -Command "(Get-Content 'meetting_room_booking_system_backend\src\.env') -replace 'QINIU_DOMAIN=your-qiniu-domain', 'QINIU_DOMAIN=%DOMAIN%' | Set-Content 'meetting_room_booking_system_backend\src\.env'"

echo.
echo 配置更新完成！
echo 请检查以下配置是否正确：
echo.
type "meetting_room_booking_system_backend\src\.env" | findstr QINIU
echo.
pause 