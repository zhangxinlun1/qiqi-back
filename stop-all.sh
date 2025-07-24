#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "会议室预订系统 - 停止所有服务"
echo -e "========================================${NC}"
echo

# 停止前端服务
echo -e "${YELLOW}[1/4] 停止前端服务...${NC}"
if [ -f "frontend.pid" ]; then
    FRONTEND_PID=$(cat frontend.pid)
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✅ 前端服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  前端服务进程不存在${NC}"
    fi
    rm -f frontend.pid
else
    echo -e "${YELLOW}⚠️  未找到前端服务PID文件${NC}"
fi

# 停止后端服务
echo -e "${YELLOW}[2/4] 停止后端服务...${NC}"
if [ -f "backend.pid" ]; then
    BACKEND_PID=$(cat backend.pid)
    if kill -0 $BACKEND_PID 2>/dev/null; then
        kill $BACKEND_PID
        echo -e "${GREEN}✅ 后端服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  后端服务进程不存在${NC}"
    fi
    rm -f backend.pid
else
    echo -e "${YELLOW}⚠️  未找到后端服务PID文件${NC}"
fi

# 停止 Redis 服务
echo -e "${YELLOW}[3/4] 停止 Redis 服务...${NC}"
if command -v systemctl &> /dev/null; then
    # Linux systemd
    sudo systemctl stop redis 2>/dev/null || sudo systemctl stop redis-server 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis 服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务可能已经停止${NC}"
    fi
elif command -v brew &> /dev/null; then
    # macOS with Homebrew
    brew services stop redis 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis 服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务可能已经停止${NC}"
    fi
else
    # 直接杀死 Redis 进程
    pkill -f redis-server
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis 服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  Redis 服务可能已经停止${NC}"
    fi
fi

# 停止 MySQL 服务
echo -e "${YELLOW}[4/4] 停止 MySQL 服务...${NC}"
if command -v systemctl &> /dev/null; then
    # Linux systemd
    sudo systemctl stop mysql 2>/dev/null || sudo systemctl stop mysqld 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MySQL 服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  MySQL 服务可能已经停止${NC}"
    fi
elif command -v brew &> /dev/null; then
    # macOS with Homebrew
    brew services stop mysql 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MySQL 服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  MySQL 服务可能已经停止${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  无法自动停止 MySQL，请手动停止${NC}"
fi

echo
echo -e "${BLUE}========================================"
echo -e "🎉 所有服务已停止！"
echo -e "========================================${NC}"
echo 