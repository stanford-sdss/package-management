source("renv/activate.R")
proj <- Sys.getenv("PROJECT_DIR")
if (nzchar(proj) && dir.exists(proj)) {
  setwd(proj)
}

if (requireNamespace("renv", quietly = TRUE)) {
  renv::load()
}
