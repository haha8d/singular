# 解压数据文件脚本
# 此脚本用于解压压缩的数据文件

extract_data <- function() {

  cat("=== Extracting Data Files ===\n\n")

  compressed_files <- list(
    "Visualization-data/GO/GO.csv.zip" = "Visualization-data/GO/GO.csv"
  )

  for (zip_file in names(compressed_files)) {
    target_file <- compressed_files[[zip_file]]

    if (file.exists(target_file)) {
      cat(sprintf("✓ %s already exists, skipping...\n", target_file))
    } else if (file.exists(zip_file)) {
      cat(sprintf("Extracting %s to %s...\n", zip_file, target_file))

      # 使用 R 的 unzip 函数解压
      unzip(zip_file, exdir = dirname(target_file))

      if (file.exists(target_file)) {
        cat(sprintf("✓ Successfully extracted: %s\n", target_file))
      } else {
        cat(sprintf("✗ Failed to extract: %s\n", target_file))
      }
    } else {
      cat(sprintf("✗ Compressed file not found: %s\n", zip_file))
    }
    cat("\n")
  }

  cat("=== Data Extraction Complete ===\n")
}

# 执行解压
extract_data()
