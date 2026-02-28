# SINGULAR 部署指南

## 快速部署（Ubuntu/Debian）

### 1. 安装 Shiny Server

```bash
# 上传并运行安装脚本
sudo bash deploy/install_shiny_server.sh
```

### 2. 部署应用

```bash
# 上传并运行部署脚本
sudo bash deploy/deploy_app.sh
```

### 3. 访问应用

打开浏览器访问: `http://服务器IP:3838/singular`

## 手动部署步骤

### 1. 安装 R

```bash
sudo apt-get update
sudo apt-get install -y r-base r-base-dev
```

### 2. 安装 Shiny

```bash
sudo su - -c "R -e \"install.packages('shiny')\""
```

### 3. 安装 Shiny Server

```bash
wget https://download3.rstudio.org/ubuntu-22.04/pkgs/shiny-server-1.5.23.1025-amd64.deb
sudo dpkg -i shiny-server-1.5.23.1025-amd64.deb
```

### 4. 部署应用

```bash
# 创建应用目录
sudo mkdir -p /srv/shiny-server/singular
cd /srv/shiny-server/singular

# 克隆代码
sudo git clone https://github.com/haha8d/singular.git .

# 安装依赖
sudo R -f install_app.R

# 设置权限
sudo chown -R shiny:shiny /srv/shiny-server/singular
sudo chmod -R 755 /srv/shiny-server/singular

# 重启服务
sudo systemctl restart shiny-server
```

## 查看日志

```bash
# Shiny Server 日志
sudo journalctl -u shiny-server -f

# 应用日志
sudo tail -f /var/log/shiny-server/singular-*.log
```

## 端口配置

Shiny Server 默认端口: 3838

如需修改，编辑 `/etc/shiny-server/shiny-server.conf`:
```
listen 3838;
```

重启服务:
```bash
sudo systemctl restart shiny-server
```

## 防火墙配置

```bash
# Ubuntu (ufw)
sudo ufw allow 3838/tcp

# CentOS (firewalld)
sudo firewall-cmd --permanent --add-port=3838/tcp
sudo firewall-cmd --reload
```

## Nginx 反向代理（可选）

创建配置文件 `/etc/nginx/sites-available/singular`:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location /singular/ {
        proxy_pass http://127.0.0.1:3838/singular/;
        proxy_redirect http://127.0.0.1:3838/ $scheme://$host/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 20d;
    }
}
```

启用配置:
```bash
sudo ln -s /etc/nginx/sites-available/singular /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 常见问题

### 应用无法访问
- 检查 Shiny Server 状态: `sudo systemctl status shiny-server`
- 检查端口是否开放: `sudo netstat -tlnp | grep 3838`
- 查看应用日志: `sudo tail -f /var/log/shiny-server/singular-*.log`

### 数据文件解压失败
确保 `Visualization-data.zip` 存在且有正确的权限

### R 包安装失败
检查镜像源设置，确保网络可访问
