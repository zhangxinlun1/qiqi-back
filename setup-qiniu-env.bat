@echo off
echo 设置七牛云环境变量...

REM 检查.env文件是否存在
if not exist "apparel_admin_back\src\.env" (
    echo 创建.env文件...
    copy "apparel_admin_back\src\env.example" "apparel_admin_back\src\.env"
)

REM 更新七牛云配置
powershell -Command "(Get-Content 'apparel_admin_back\src\.env') -replace 'QINIU_ACCESS_KEY=your-qiniu-access-key', 'QINIU_ACCESS_KEY=RrTc2FiMj3Q9Wh4r4xSnPqXVrrfrLzu47786D3-C' | Set-Content 'apparel_admin_back\src\.env'"

powershell -Command "(Get-Content 'apparel_admin_back\src\.env') -replace 'QINIU_SECRET_KEY=your-qiniu-secret-key', 'QINIU_SECRET_KEY=RrTc2FiMj3Q9Wh4r4xSnPqXVrrfrLzu47786D3-C' | Set-Content 'apparel_admin_back\src\.env'"

powershell -Command "(Get-Content 'apparel_admin_back\src\.env') -replace 'QINIU_BUCKET_NAME=your-bucket-name', 'QINIU_BUCKET_NAME=xin-zone' | Set-Content 'apparel_admin_back\src\.env'"

powershell -Command "(Get-Content 'apparel_admin_back\src\.env') -replace 'QINIU_DOMAIN=your-qiniu-domain', 'QINIU_DOMAIN=http://img.fznbd.xin' | Set-Content 'apparel_admin_back\src\.env'"

echo 七牛云配置已更新！
echo 请重启后端服务以应用新配置
pause 