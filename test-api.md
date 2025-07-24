# API 测试说明

## 服务状态检查

### 1. 检查Docker容器状态
```bash
docker ps
```

应该看到以下容器正在运行：
- qiqi-back-mysql-1 (MySQL数据库)
- qiqi-back-backend-1 (后端API服务)
- qiqi-back-frontend-1 (前端服务)

### 2. 检查后端API
```bash
# 测试商品API
curl http://localhost:3333/product

# 测试订单API
curl http://localhost:3333/order

# 测试订单统计API
curl http://localhost:3333/order/statistics/daily
```

### 3. 访问前端应用
打开浏览器访问：http://localhost:5173

## 前后端通信测试

### 1. 商品管理功能
- 添加商品：通过前端界面添加商品，数据会保存到数据库
- 编辑商品：修改商品信息，更新到数据库
- 删除商品：删除商品记录
- 查看商品列表：从数据库获取商品数据

### 2. 开单功能
- 开单操作：创建订单并保存到数据库
- 库存更新：开单后自动更新商品库存
- 营业额统计：从数据库获取订单数据计算统计

### 3. 数据持久化
- 所有操作都会保存到MySQL数据库
- 前端不再依赖本地存储
- 数据在容器重启后仍然保持

## 故障排除

### 1. 如果后端无法连接数据库
```bash
# 重启MySQL容器
docker-compose restart mysql

# 重启后端容器
docker-compose restart backend
```

### 2. 如果前端无法连接后端
- 检查后端API是否正常运行
- 确认前端API配置中的baseURL是否正确
- 检查CORS配置

### 3. 查看容器日志
```bash
# 查看后端日志
docker logs qiqi-back-backend-1

# 查看前端日志
docker logs qiqi-back-frontend-1

# 查看MySQL日志
docker logs qiqi-back-mysql-1
```

## 数据库结构

### 主要表结构
- `products`: 商品表
- `orders`: 订单表
- `order_items`: 订单项表
- `users`: 用户表
- `roles`: 角色表
- `permissions`: 权限表

### 数据迁移
如果需要初始化数据，可以使用项目根目录的 `migrate-data.js` 脚本。 