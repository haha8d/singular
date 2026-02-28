#!/bin/bash
# Shiny Server 安装脚本 - 适用于 Ubuntu/Debian

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

echo "=== 安装 Shiny Server ==="

# 1. 安装 R
echo "安装 R..."
apt-get update
apt-get install -y r-base r-base-dev

# 2. 安装 Shiny 和相关包
echo "安装 Shiny 包..."
su - -c "R -e \"install.packages('shiny')\""

# 3. 安装 Shiny Server
echo "下载并安装 Shiny Server..."
cd /tmp
wget https://download3.rstudio.org/ubuntu-22.04/pkgs/shiny-server-1.5.23.1025-amd64.deb
dpkg -i shiny-server-1.5.23.1025-amd64.deb

# 4. 启动 Shiny Server
echo "启动 Shiny Server..."
systemctl start shiny-server
systemctl enable shiny-server

# 5. 检查状态
systemctl status shiny-server

echo ""
echo "=== Shiny Server 安装完成 ==="
echo "默认访问地址: http://服务器IP:3838"
echo "应用目录: /srv/shiny-server/"
