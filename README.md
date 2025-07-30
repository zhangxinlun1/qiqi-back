# 会议室预订系统 - 一键启动脚本

这是一个包含前端和后端的会议室预订系统，提供了一键启动所有服务的脚本。

## 项目结构

```
qiqi-back/
├── apparel_admin_back/  # 后端项目 (NestJS)
├── vue3-admin-dashboard/                  # 前端项目 (Vue3 + Element Plus)
├── start-all.bat                         # Windows 启动脚本
├── start-all.sh                          # Linux/macOS 启动脚本
├── stop-all.bat                          # Windows 停止脚本
├── stop-all.sh                           # Linux/macOS 停止脚本
└── README.md                             # 说明文档
```

## 环境要求

在运行脚本之前，请确保已安装以下软件：

### 必需软件
- **Node.js** (版本 16 或更高)
- **MySQL** (版本 8.0 或更高)
- **Redis** (版本 6.0 或更高)

### 安装指南

#### Windows
1. **Node.js**: 从 [官网](https://nodejs.org/) 下载并安装
2. **MySQL**: 从 [官网](https://dev.mysql.com/downloads/mysql/) 下载并安装
3. **Redis**: 从 [官网](https://redis.io/download) 下载并安装，或使用 [Redis for Windows](https://github.com/microsoftarchive/redis/releases)

#### Linux (Ubuntu/Debian)
```bash
# 安装 Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 安装 MySQL
sudo apt update
sudo apt install mysql-server

# 安装 Redis
sudo apt install redis-server
```

#### macOS
```bash
# 使用 Homebrew 安装
brew install node
brew install mysql
brew install redis
```

## 使用方法

### Windows 用户

1. **启动所有服务**
   ```cmd
   start-all.bat
   ```

2. **停止所有服务**
   ```cmd
   stop-all.bat
   ```

### Linux/macOS 用户

1. **给脚本执行权限**
   ```bash
   chmod +x start-all.sh stop-all.sh
   ```

2. **启动所有服务**
   ```bash
   ./start-all.sh
   ```

3. **停止所有服务**
   ```bash
   ./stop-all.sh
   ```

## 服务端口

启动成功后，可以通过以下地址访问：

- **前端**: http://localhost:5173
- **后端**: http://localhost:3333
- **API文档**: http://localhost:3333/api
- **MySQL**: localhost:3306
- **Redis**: localhost:6379

## 数据库配置

### MySQL 配置
- 主机: localhost
- 端口: 3306
- 用户名: root
- 密码: woaini520.
- 数据库: meeting_room_booking_system

### Redis 配置
- 主机: localhost
- 端口: 6379
- 数据库: 1

## 故障排除

### 常见问题

1. **MySQL 连接失败**
   - 确保 MySQL 服务正在运行
   - 检查用户名和密码是否正确
   - 确保数据库已创建

2. **Redis 连接失败**
   - 确保 Redis 服务正在运行
   - 检查端口是否被占用

3. **前端无法访问后端**
   - 确保后端服务正在运行
   - 检查 CORS 配置
   - 确认端口 3333 未被占用

4. **依赖安装失败**
   - 检查网络连接
   - 尝试使用 `npm cache clean --force`
   - 删除 node_modules 文件夹后重新安装

### 手动启动服务

如果自动脚本无法正常工作，可以手动启动：

#### 后端
```bash
cd apparel_admin_back
npm install
npm run start:dev
```

#### 前端
```bash
cd vue3-admin-dashboard
npm install
npm run dev
```

## 开发说明

### 后端技术栈
- **框架**: NestJS
- **数据库**: MySQL + TypeORM
- **缓存**: Redis
- **认证**: JWT
- **文档**: Swagger

### 前端技术栈
- **框架**: Vue 3
- **UI库**: Element Plus
- **状态管理**: Pinia
- **路由**: Vue Router
- **构建工具**: Vite

## 许可证

本项目仅供学习和演示使用。

## 联系方式

如有问题，请联系项目维护者。 # qiqi-back
