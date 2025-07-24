#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "会议室预订系统 - 一键启动脚本"
echo -e "========================================${NC}"
echo

# 检查是否安装了必要的软件
echo -e "${YELLOW}[1/7] 检查环境...${NC}"

# 检查 MySQL
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}❌ MySQL 未安装或未添加到 PATH${NC}"
    echo "请先安装 MySQL 并确保 mysql 命令可用"
    exit 1
fi

# 检查 Redis
if ! command -v redis-server &> /dev/null; then
    echo -e "${RED}❌ Redis 未安装或未添加到 PATH${NC}"
    echo "请先安装 Redis 并确保 redis-server 命令可用"
    exit 1
fi

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js 未安装或未添加到 PATH${NC}"
    echo "请先安装 Node.js 并确保 node 命令可用"
    exit 1
fi

echo -e "${GREEN}✅ 环境检查通过${NC}"
echo

# 配置环境变量
echo -e "${YELLOW}[2/7] 配置环境变量...${NC}"
if ./setup-env.sh >/dev/null 2>&1; then
    echo -e "${GREEN}✅ 环境变量配置完成${NC}"
else
    echo -e "${YELLOW}⚠️  环境变量配置可能失败，请手动检查${NC}"
fi
echo

# 启动 MySQL (Linux/macOS)
echo -e "${YELLOW}[3/7] 启动 MySQL 服务...${NC}"
if command -v systemctl &> /dev/null; then
    # Linux systemd
    sudo systemctl start mysql 2>/dev/null || sudo systemctl start mysqld 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MySQL 服务启动成功${NC}"
    else
        echo -e "${YELLOW}⚠️  MySQL 服务可能已经在运行或启动失败${NC}"
        echo "请手动检查 MySQL 服务状态"
    fi
elif command -v brew &> /dev/null; then
    # macOS with Homebrew
    brew services start mysql 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MySQL 服务启动成功${NC}"
    else
        echo -e "${YELLOW}⚠️  MySQL 服务可能已经在运行或启动失败${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  无法自动启动 MySQL，请手动启动${NC}"
fi
echo

# 启动 Redis
echo -e "${YELLOW}[4/7] 启动 Redis 服务...${NC}"
if command -v systemctl &> /dev/null; then
    # Linux systemd
    sudo systemctl start redis 2>/dev/null || sudo systemctl start redis-server 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis 服务启动成功${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务可能已经在运行或启动失败${NC}"
    fi
elif command -v brew &> /dev/null; then
    # macOS with Homebrew
    brew services start redis 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis 服务启动成功${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务可能已经在运行或启动失败${NC}"
    fi
else
    # 直接启动 Redis 服务器
    nohup redis-server > /dev/null 2>&1 &
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis 服务启动成功${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务启动失败${NC}"
    fi
fi
echo

# 安装后端依赖
echo -e "${YELLOW}[5/7] 安装后端依赖...${NC}"
cd meetting_room_booking_system_backend
if [ ! -d "node_modules" ]; then
    echo "正在安装后端依赖..."
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 后端依赖安装失败${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ 后端依赖已存在${NC}"
fi
echo

# 启动后端服务
echo -e "${YELLOW}[6/7] 启动后端服务...${NC}"
nohup npm run start:dev > backend.log 2>&1 &
BACKEND_PID=$!
sleep 3
if kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${GREEN}✅ 后端服务启动成功 (端口: 3333)${NC}"
else
    echo -e "${RED}❌ 后端服务启动失败${NC}"
    exit 1
fi
echo

# 安装前端依赖
echo -e "${YELLOW}[7/7] 安装前端依赖...${NC}"
cd ../vue3-admin-dashboard
if [ ! -d "node_modules" ]; then
    echo "正在安装前端依赖..."
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 前端依赖安装失败${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ 前端依赖已存在${NC}"
fi
echo

# 启动前端服务
echo -e "${YELLOW}[7/7] 启动前端服务...${NC}"
nohup npm run dev > frontend.log 2>&1 &
FRONTEND_PID=$!
sleep 3
if kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${GREEN}✅ 前端服务启动成功 (端口: 5173)${NC}"
else
    echo -e "${RED}❌ 前端服务启动失败${NC}"
    exit 1
fi
echo

echo -e "${BLUE}========================================"
echo -e "🎉 所有服务启动完成！"
echo -e "========================================${NC}"
echo
echo -e "${GREEN}📍 服务地址：${NC}"
echo "   前端: http://localhost:5173"
echo "   后端: http://localhost:3333"
echo "   API文档: http://localhost:3333/api"
echo
echo -e "${GREEN}📝 数据库配置：${NC}"
echo "   MySQL: localhost:3306"
echo "   Redis: localhost:6379"
echo
echo -e "${GREEN}💡 提示：${NC}"
echo "   - 按 Ctrl+C 可以停止当前脚本"
echo "   - 各个服务进程可以独立关闭"
echo "   - 日志文件: backend.log, frontend.log"
echo "   - 如需重启某个服务，请关闭对应进程后重新运行此脚本"
echo

# 保存进程ID到文件，方便后续停止
echo $BACKEND_PID > backend.pid
echo $FRONTEND_PID > frontend.pid

# 等待用户输入
read -p "按回车键退出..." 