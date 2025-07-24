# Docker 镜像源配置说明

## 方法1：通过Docker Desktop GUI配置

1. **打开Docker Desktop**
2. **点击设置图标（齿轮）**
3. **选择 "Docker Engine"**
4. **在配置文件中添加或修改以下内容：**

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://ccr.ccs.tencentyun.com"
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": false
}
```

5. **点击 "Apply & Restart"**

## 方法2：通过命令行配置

### 创建配置文件
```bash
# 创建配置目录
mkdir -p "$env:USERPROFILE\.docker"

# 创建配置文件
@"
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
"@ | Out-File -FilePath "$env:USERPROFILE\.docker\daemon.json" -Encoding UTF8
```

### 重启Docker Desktop
1. 右键点击系统托盘中的Docker图标
2. 选择 "Restart Docker Desktop"

## 方法3：使用代理

如果您有代理服务器，可以在Docker Desktop中配置：

1. **打开Docker Desktop设置**
2. **选择 "Resources" > "Proxies"**
3. **配置HTTP/HTTPS代理**

## 验证配置

配置完成后，运行以下命令验证：

```bash
# 测试拉取镜像
docker pull hello-world

# 查看镜像源配置
docker info
```

## 常用镜像源

- **中科大**: https://docker.mirrors.ustc.edu.cn
- **网易**: https://hub-mirror.c.163.com
- **百度**: https://mirror.baidubce.com
- **腾讯**: https://ccr.ccs.tencentyun.com
- **阿里云**: https://registry.cn-hangzhou.aliyuncs.com

## 故障排除

如果仍然无法连接，可以尝试：

1. **检查网络连接**
   ```bash
   ping docker.mirrors.ustc.edu.cn
   ```

2. **使用VPN或代理**

3. **临时禁用防火墙**

4. **重启Docker Desktop** 