#!/bin/bash

echo "========================================"
echo "环境变量配置脚本 (Git版本)"
echo "========================================"

echo ""
echo "正在配置环境变量文件..."

# 配置后端环境变量
cd apparel_admin_back/src
if [ -f ".env" ]; then
    echo "后端.env文件已存在，跳过创建"
else
    echo "创建后端.env文件..."
    if cp env.example .env 2>/dev/null; then
        echo "✓ 后端.env文件创建成功"
    else
        echo "✗ 后端.env文件创建失败"
    fi
fi

# 配置前端环境变量
cd ../../vue3-admin-dashboard
if [ -f ".env" ]; then
    echo "前端.env文件已存在，跳过创建"
else
    echo "创建前端.env文件..."
    if cp env.example .env 2>/dev/null; then
        echo "✓ 前端.env文件创建成功"
    else
        echo "✗ 前端.env文件创建失败"
    fi
fi

cd ..

echo ""
echo "========================================"
echo "环境变量配置完成！"
echo "========================================"
echo ""
echo "请手动编辑以下文件并填入正确的配置："
echo ""
echo "后端环境变量文件: apparel_admin_back/src/.env"
echo "前端环境变量文件: vue3-admin-dashboard/.env"
echo ""
echo "编辑命令："
echo "Linux/macOS: nano .env 或 vim .env"
echo ""
echo "注意：.env文件包含敏感信息，不会被提交到Git"
echo "但env.example文件会被提交，方便其他开发者配置"
echo "" 