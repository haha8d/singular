# 设置用户库目录（与安装脚本一致）
lib_path <- file.path(Sys.getenv("USERPROFILE"), "R", "library")
.libPaths(c(lib_path, .libPaths()))

pkgs <- c('shiny','shinydashboard','dashboardthemes','shinycustomloader','shinyalert','shinyjs','ggplot2','ggpubr','DT','visNetwork','htmlwidgets','plyr','circlize','ComplexHeatmap')

installed <- installed.packages()

cat("=== Package Installation Status ===\n\n")
cat("Library paths:\n")
print(.libPaths())
cat("\n")
cat(sprintf("%-20s %s\n", "Package", "Status"))
cat(paste(rep("-", 40), collapse=""), "\n")

for(p in pkgs) {
  if(p %in% installed[,'Package']) {
    version <- installed[p, 'Version']
    cat(sprintf("%-20s INSTALLED (v%s)\n", p, version))
  } else {
    cat(sprintf("%-20s NOT INSTALLED\n", p))
  }
}


