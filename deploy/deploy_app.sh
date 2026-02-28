#!/bin/bash
# 部署 SINGULAR 应用到 Shiny Server

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

APP_NAME="singular"
APP_DIR="/srv/shiny-server/$APP_NAME"
REPO_URL="https://github.com/haha8d/singular.git"

echo "=== 部署 SINGULAR 应用 ==="

# 1. 创建应用目录
echo "创建应用目录..."
mkdir -p $APP_DIR
cd $APP_DIR

# 2. 克隆或更新代码
if [ -d ".git" ]; then
  echo "更新现有代码..."
  git pull origin main
else
  echo "克隆仓库..."
  git clone $REPO_URL .
fi

# 3. 创建安装和设置脚本的可执行副本（避免使用 source）
echo "准备安装脚本..."
cat > install_app.R << 'EOF'
# 设置用户库目录
lib_path <- file.path(Sys.getenv("HOME"), "R", "library")
if (!dir.exists(lib_path)) {
  dir.create(lib_path, recursive = TRUE)
}
.libPaths(c(lib_path, .libPaths()))

# 设置镜像
options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 安装包
metr_pkgs <- c("shiny", "shinydashboard", "dashboardthemes", "shinycustomloader",
               "shinyalert", "shinyjs", "ggplot2", "ggpubr", "DT", "visNetwork",
               "htmlwidgets","plyr", "circlize", "ComplexHeatmap",
               "markdown", "knitr", "rmarkdown")

list_installed <- installed.packages()
new_pkgs <- metr_pkgs[!metr_pkgs %in% list_installed[, "Package"]]

if(length(new_pkgs) > 0){
  cran_pkgs <- new_pkgs[!new_pkgs %in% c("circlize", "ComplexHeatmap")]
  if (length(cran_pkgs) > 0) {
    install.packages(cran_pkgs)
  }
  bioc_pkgs <- new_pkgs[new_pkgs %in% c("circlize", "ComplexHeatmap")]
  if (length(bioc_pkgs) > 0) {
    if (!requireNamespace("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
    BiocManager::install(bioc_pkgs, ask = FALSE, update = FALSE)
  }
}

# 解压数据文件
if (file.exists("Visualization-data.zip") && !dir.exists("Visualization-data")) {
  unzip("Visualization-data.zip", exdir = ".")
}

cat("Installation complete!\n")
EOF

# 4. 修改 app.R 使用绝对路径的库
echo "调整 app.R 配置..."
sed -i 's|source("setup.R")|# setup.R handled by install_app.R|' app.R

# 5. 修改 app.R，添加全局库路径设置
cat > setup_paths.R << 'EOF'
# 设置全局库路径（Shiny Server 用户）
if (Sys.info()["user"] == "shiny") {
  lib_path <- "/home/shiny/R/library"
} else {
  lib_path <- file.path(Sys.getenv("HOME"), "R", "library")
}
if (!dir.exists(lib_path)) {
  dir.create(lib_path, recursive = TRUE)
}
.libPaths(c(lib_path, .libPaths()))
EOF

# 在 app.R 开头插入库路径设置
sed -i '2a source("setup_paths.R")' app.R

# 6. 设置权限
echo "设置文件权限..."
chown -R shiny:shiny $APP_DIR
chmod -R 755 $APP_DIR

# 7. 为 shiny 用户安装包
echo "为 shiny 用户安装 R 包..."
su - shiny -c "cd $APP_DIR && R -f install_app.R"

# 8. 重启 Shiny Server
echo "重启 Shiny Server..."
systemctl restart shiny-server

echo ""
echo "=== 部署完成 ==="
echo "应用访问地址: http://服务器IP:3838/singular"
echo "查看日志: sudo journalctl -u shiny-server -f"
echo "应用目录: $APP_DIR"
