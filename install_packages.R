metanr_packages <- function(){

  # 设置国内镜像,提高下载速度
  options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

  # 设置用户库目录（避免权限问题）
  if (.Platform$OS.type == "windows") {
    lib_path <- file.path(Sys.getenv("USERPROFILE"), "R", "library")
  } else {
    lib_path <- file.path(Sys.getenv("HOME"), "R", "library")
  }

  if (!dir.exists(lib_path)) {
    dir.create(lib_path, recursive = TRUE)
  }

  # 将用户库路径设为第一个，确保优先使用
  .libPaths(c(lib_path, .libPaths()))

  cat("Library path set to:", lib_path, "\n\n")

  metr_pkgs <- c("shiny", "shinydashboard", "dashboardthemes", "shinycustomloader", "shinyalert", "shinyjs", "ggplot2", "ggpubr", "DT", "visNetwork", "htmlwidgets","plyr", "circlize", "ComplexHeatmap")

  list_installed <- installed.packages()

  new_pkgs <- subset(metr_pkgs, !(metr_pkgs %in% list_installed[, "Package"]))

  if(length(new_pkgs)!=0){
    cat("Packages to install:", length(new_pkgs), "\n")
    cat(paste(new_pkgs, collapse=", "), "\n\n")

    # 先安装 CRAN 包
    cran_pkgs <- new_pkgs[!new_pkgs %in% c("circlize", "ComplexHeatmap")]
    if (length(cran_pkgs) > 0) {
      cat("Installing CRAN packages...\n")
      install.packages(cran_pkgs, quiet = FALSE)
    }

    # 安装 Bioconductor 包
    bioc_pkgs <- new_pkgs[new_pkgs %in% c("circlize", "ComplexHeatmap")]
    if (length(bioc_pkgs) > 0) {
      if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
      cat("Installing Bioconductor packages...\n")
      BiocManager::install(bioc_pkgs, ask = FALSE, update = FALSE)
    }

    cat("\nPackages added successfully!\n")
  }

  if((length(new_pkgs)<1)){
    cat("No new packages added - all packages are already installed.\n")
  }
}

# 执行安装
metanr_packages()
