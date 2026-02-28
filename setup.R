# 设置用户库目录（避免权限问题）
if (.Platform$OS.type == "windows") {
  lib_path <- file.path(Sys.getenv("USERPROFILE"), "R", "library")
} else {
  lib_path <- file.path(Sys.getenv("HOME"), "R", "library")
}

.libPaths(c(lib_path, .libPaths()))

cat("Library paths set:\n")
print(.libPaths())
cat("\n")
