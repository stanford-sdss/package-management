#!/bin/bash

CONTAINER_NAME="simple_r.sif"
RECIPE_FILE="simple_r.def"

echo "Building the container..."
apptainer build $CONTAINER_NAME $RECIPE_FILE

echo "Testing DataFrames inside the container..."
apptainer exec "$CONTAINER_NAME" R -e 'setwd("/opt/R/environments/renv"); renv::load(); library(ggplot2); print("ggplot2 is working!")'

echo "Checking Project.toml and Manifest.toml inside the container..."
apptainer exec "$CONTAINER_NAME" ls -l /opt/R/environments/renv

echo "Listing installed julia packages..."
apptainer exec "$CONTAINER_NAME" R -e 'print(.libPaths())'

echo "Build complete."