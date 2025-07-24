# 环境变量Git配置说明

## 📋 概述

本项目使用环境变量来管理配置信息，支持Git版本控制，方便在不同电脑上部署和测试。

## 🗂️ 文件结构

```
项目根目录/
├── meetting_room_booking_system_backend/
│   └── src/
│       ├── .env                    # 后端环境变量文件 (需要手动创建)
│       └── env.example             # 后端环境变量示例文件 (已提交到Git)
├── vue3-admin-dashboard/
│   ├── .env                        # 前端环境变量文件 (需要手动创建)
│   └── env.example                 # 前端环境变量示例文件 (已提交到Git)
├── setup-env-git.bat              # Windows环境变量配置脚本
├── setup-env-git.sh               # Linux/macOS环境变量配置脚本
└── 环境变量Git配置说明.md          # 本说明文档
```

## 🚀 快速开始

### 1. 自动配置 (推荐)

#### Windows用户
```bash
# 运行配置脚本
setup-env-git.bat
```

#### Linux/macOS用户
```bash
# 给脚本执行权限
chmod +x setup-env-git.sh

# 运行配置脚本
./setup-env-git.sh
```

### 2. 手动配置

#### 后端环境变量
```bash
# 进入后端目录
cd meetting_room_booking_system_backend/src

# 复制示例文件
cp env.example .env

# 编辑环境变量
# Windows: notepad .env
# Linux/macOS: nano .env 或 vim .env
```

#### 前端环境变量
```bash
# 进入前端目录
cd vue3-admin-dashboard

# 复制示例文件
cp env.example .env

# 编辑环境变量
# Windows: notepad .env
# Linux/macOS: nano .env 或 vim .env
```

## ⚙️ 环境变量配置

### 后端环境变量 (meetting_room_booking_system_backend/src/.env)

```bash
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=your-database-password
DB_DATABASE=meeting_room_booking_system

# JWT配置
JWT_SECRET=your-super-secret-jwt-key-here
JWT_ACCESS_TOKEN_EXPIRES_IN=30m
JWT_EXPIRES_IN=7d

# 邮件配置
EMAIL_HOST=smtp.qq.com
EMAIL_PORT=587
EMAIL_USER=your-email@qq.com
EMAIL_PASS=your-email-password

# 七牛云配置 (文件上传)
QINIU_ACCESS_KEY=your-qiniu-access-key
QINIU_SECRET_KEY=your-qiniu-secret-key
QINIU_BUCKET_NAME=your-bucket-name
QINIU_DOMAIN=your-qiniu-domain

# 和风天气API配置
QWEATHER_API_KEY=your-qweather-api-key

# 服务器配置
PORT=3333
NODE_ENV=development

# CORS配置
CORS_ORIGIN=http://localhost:5173
```

### 前端环境变量 (vue3-admin-dashboard/.env)

```bash
# API配置
VITE_API_URL=http://localhost:3333
VITE_REQUEST_TIMEOUT=5000

# 应用配置
VITE_APP_TITLE=女装管理系统
VITE_APP_VERSION=1.0.0

# 开发环境配置
VITE_DEV_SERVER_PORT=5173
VITE_DEV_SERVER_HOST=0.0.0.0

# 文件上传配置
VITE_UPLOAD_URL=http://localhost:3333/api/file-upload/upload

# 调试配置
VITE_DEBUG_MODE=false
```

## 🔐 安全说明

### 已提交到Git的文件
- ✅ `env.example` - 环境变量示例文件
- ✅ 配置脚本 - 自动创建.env文件
- ✅ 说明文档 - 配置指南

### 不会提交到Git的文件
- ❌ `.env` - 包含敏感信息的环境变量文件
- ❌ `.env.local` - 本地环境变量文件
- ❌ `.env.production` - 生产环境变量文件

## 🔄 跨设备部署

### 在新电脑上部署

1. **克隆项目**
```bash
git clone <项目地址>
cd qiqi-back
```

2. **运行配置脚本**
```bash
# Windows
setup-env-git.bat

# Linux/macOS
chmod +x setup-env-git.sh
./setup-env-git.sh
```

3. **编辑环境变量**
```bash
# 后端
notepad meetting_room_booking_system_backend/src/.env

# 前端
notepad vue3-admin-dashboard/.env
```

4. **启动服务**
```bash
# 启动所有服务
start-all.bat  # Windows
./start-all.sh # Linux/macOS
```

## 📝 注意事项

1. **敏感信息保护**: 不要将包含真实密码、API密钥的.env文件提交到Git
2. **示例文件**: env.example文件会被提交，方便其他开发者了解需要配置哪些变量
3. **本地配置**: 每个开发者可以根据自己的环境修改.env文件
4. **版本控制**: 环境变量配置脚本和说明文档会被提交到Git

## 🛠️ 故障排除

### 常见问题

1. **环境变量不生效**
   - 检查.env文件是否在正确位置
   - 重启开发服务器

2. **文件上传失败**
   - 检查七牛云配置是否正确
   - 确认网络连接正常

3. **数据库连接失败**
   - 检查数据库服务是否启动
   - 确认数据库配置信息正确

### 调试命令

```bash
# 检查环境变量文件是否存在
ls -la meetting_room_booking_system_backend/src/.env
ls -la vue3-admin-dashboard/.env

# 检查环境变量是否加载
node -e "console.log(require('dotenv').config())"
```

## 📞 支持

如果遇到问题，请检查：
1. 环境变量文件是否正确创建
2. 配置信息是否正确填写
3. 服务是否正常启动

---

**注意**: 本配置方案确保敏感信息不会被提交到Git，同时方便团队成员快速配置环境。 