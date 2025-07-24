@echo off
echo 更新七牛云域名配置...

REM 检查.env文件是否存在
if not exist "meetting_room_booking_system_backend\src\.env" (
    echo 创建.env文件...
    copy "meetting_room_booking_system_backend\src\env.example" "meetting_room_booking_system_backend\src\.env"
)

REM 更新七牛云域名配置
powershell -Command "(Get-Content 'meetting_room_booking_system_backend\src\.env') -replace 'QINIU_DOMAIN=https://img.fznbd.xin', 'QINIU_DOMAIN=http://img.fznbd.xin' | Set-Content 'meetting_room_booking_system_backend\src\.env'"

echo 七牛云域名已更新为: http://img.fznbd.xin
echo 请重启后端服务以应用新配置
pause 