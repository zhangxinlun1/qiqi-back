#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "会议室预订系统 - 环境变量配置脚本"
echo -e "========================================${NC}"
echo

# 配置后端环境变量
echo -e "${YELLOW}[1/3] 配置后端环境变量...${NC}"
cd apparel_admin_back/src

if [ -f ".env" ]; then
    echo -e "${GREEN}✅ 后端环境变量文件已存在${NC}"
else
    echo "正在创建后端环境变量文件..."
    if cp env.example .env 2>/dev/null; then
        echo -e "${GREEN}✅ 后端环境变量文件创建成功${NC}"
    else
        echo -e "${RED}❌ 后端环境变量文件创建失败${NC}"
        exit 1
    fi
fi
echo

# 配置前端环境变量
echo -e "${YELLOW}[2/3] 配置前端环境变量...${NC}"
cd ../../vue3-admin-dashboard

if [ -f ".env" ]; then
    echo -e "${GREEN}✅ 前端环境变量文件已存在${NC}"
else
    echo "正在创建前端环境变量文件..."
    if cp env.example .env 2>/dev/null; then
        echo -e "${GREEN}✅ 前端环境变量文件创建成功${NC}"
    else
        echo -e "${RED}❌ 前端环境变量文件创建失败${NC}"
        exit 1
    fi
fi
echo

# 创建数据库
echo -e "${YELLOW}[3/3] 创建数据库...${NC}"
cd ../apparel_admin_back/src
echo "正在创建数据库..."

mysql -u root -pwoaini520. -e "CREATE DATABASE IF NOT EXISTS meeting_room_booking_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 数据库创建成功${NC}"
else
    echo -e "${YELLOW}⚠️  数据库可能已存在或创建失败${NC}"
    echo "请手动检查数据库状态"
fi
echo

echo -e "${BLUE}========================================"
echo -e "🎉 环境变量配置完成！"
echo -e "========================================${NC}"
echo
echo -e "${GREEN}📝 配置说明：${NC}"
echo "   后端环境变量文件: apparel_admin_back/src/.env"
echo "   前端环境变量文件: vue3-admin-dashboard/.env"
echo
echo -e "${GREEN}💡 提示：${NC}"
echo "   - 请根据实际情况修改环境变量中的敏感信息"
echo "   - 特别是数据库密码、JWT密钥、API密钥等"
echo "   - 七牛云配置需要根据你的实际账号进行修改"
echo 