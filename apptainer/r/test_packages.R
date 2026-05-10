#!/usr/bin/env Rscript

# Test if packages are available
packages <- c("tidyverse", "sf", "terra", "igraph", "ggraph", "ks", "tidysdm", "tidyterra", "DALEX")

for (pkg in packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("✓", pkg, "loaded successfully\n")
  } else {
    cat("✗", pkg, "failed to load\n")
  }
}