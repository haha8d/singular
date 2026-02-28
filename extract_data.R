# 解压数据文件脚本
# 此脚本用于解压压缩的数据文件

extract_data <- function() {

  cat("=== Extracting Data Files ===\n\n")

  zip_file <- "Visualization-data.zip"
  target_dir <- "Visualization-data"

  # 检查是否需要解压
  need_extraction <- FALSE

  if (!dir.exists(target_dir)) {
    cat("Visualization-data directory not found. Extracting...\n")
    need_extraction <- TRUE
  } else {
    # 检查关键数据文件是否存在
    required_files <- c(
      "GO/GO.csv",
      "Pathway/pathways.csv",
      "GRN/GRNI.csv"
    )

    for (f in required_files) {
      file_path <- file.path(target_dir, f)
      if (!file.exists(file_path)) {
        cat(sprintf("Missing file: %s\n", file_path))
        need_extraction <- TRUE
        break
      }
    }

    if (!need_extraction) {
      cat("All data files already exist. Skipping extraction.\n\n")
    }
  }

  if (need_extraction && file.exists(zip_file)) {
    cat(sprintf("Extracting %s...\n", zip_file))

    # 使用 R 的 unzip 函数解压
    unzip(zip_file, exdir = ".")

    cat("✓ Data extraction complete!\n")
  } else if (need_extraction) {
    cat(sprintf("✗ Compressed file not found: %s\n", zip_file))
  }

  cat("\n=== Data Extraction Complete ===\n")
}

# 执行解压
extract_data()

