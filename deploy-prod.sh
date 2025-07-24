#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "服装店管理系统 - 生产环境部署脚本"
echo -e "========================================${NC}"
echo

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker 未安装${NC}"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose 未安装${NC}"
    echo "请先安装 Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}✅ Docker 环境检查通过${NC}"
echo

# 创建必要的目录
echo -e "${YELLOW}[1/5] 创建必要的目录...${NC}"
mkdir -p nginx/ssl
mkdir -p mysql/init
mkdir -p logs

echo -e "${GREEN}✅ 目录创建完成${NC}"
echo

# 检查环境变量文件
echo -e "${YELLOW}[2/5] 检查环境变量配置...${NC}"

# 检查后端环境变量
if [ ! -f "meetting_room_booking_system_backend/src/.env" ]; then
    echo -e "${YELLOW}⚠️  后端环境变量文件不存在，正在创建...${NC}"
    cp meetting_room_booking_system_backend/src/env.example meetting_room_booking_system_backend/src/.env
    echo -e "${GREEN}✅ 后端环境变量文件创建完成${NC}"
else
    echo -e "${GREEN}✅ 后端环境变量文件已存在${NC}"
fi

# 检查前端环境变量
if [ ! -f "vue3-admin-dashboard/.env" ]; then
    echo -e "${YELLOW}⚠️  前端环境变量文件不存在，正在创建...${NC}"
    cp vue3-admin-dashboard/env.example vue3-admin-dashboard/.env
    echo -e "${GREEN}✅ 前端环境变量文件创建完成${NC}"
else
    echo -e "${GREEN}✅ 前端环境变量文件已存在${NC}"
fi

echo

# 停止现有服务
echo -e "${YELLOW}[3/5] 停止现有服务...${NC}"
docker-compose -f docker-compose.prod.yml down
echo -e "${GREEN}✅ 现有服务已停止${NC}"
echo

# 构建和启动服务
echo -e "${YELLOW}[4/5] 构建和启动服务...${NC}"
docker-compose -f docker-compose.prod.yml up -d --build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 服务启动成功${NC}"
else
    echo -e "${RED}❌ 服务启动失败${NC}"
    exit 1
fi

echo

# 等待服务启动
echo -e "${YELLOW}[5/5] 等待服务启动...${NC}"
sleep 30

# 检查服务状态
echo -e "${BLUE}========================================"
echo -e "🎉 部署完成！"
echo -e "========================================${NC}"
echo

echo -e "${GREEN}📍 服务地址：${NC}"
echo "   前端: http://localhost"
echo "   后端API: http://localhost/api"
echo "   API文档: http://localhost/api"
echo

echo -e "${GREEN}📝 数据库配置：${NC}"
echo "   MySQL: localhost:3306"
echo "   Redis: localhost:6379"
echo

echo -e "${GREEN}🔧 管理命令：${NC}"
echo "   查看日志: docker-compose -f docker-compose.prod.yml logs -f"
echo "   停止服务: docker-compose -f docker-compose.prod.yml down"
echo "   重启服务: docker-compose -f docker-compose.prod.yml restart"
echo "   更新服务: docker-compose -f docker-compose.prod.yml up -d --build"
echo

echo -e "${GREEN}💡 提示：${NC}"
echo "   - 首次访问可能需要等待几分钟让服务完全启动"
echo "   - 数据库会自动创建表结构"
echo "   - 所有数据都会持久化保存"
echo "   - 如需配置HTTPS，请将SSL证书放入 nginx/ssl/ 目录"
echo

# 显示服务状态
echo -e "${YELLOW}📊 服务状态：${NC}"
docker-compose -f docker-compose.prod.yml ps 