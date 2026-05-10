#!/bin/bash

CONTAINER_NAME="rocker_r.sif"
RECIPE_FILE="rocker_r.def"

echo "Building the container..."
apptainer build $CONTAINER_NAME $RECIPE_FILE

echo "Testing DataFrames inside the container..."
apptainer exec "$CONTAINER_NAME" R -e 'setwd("/opt/R/environments/renv"); renv::load(); library(tidyterra); print("tidyterra is working!")'

echo "Checking Project.toml and Manifest.toml inside the container..."
apptainer exec "$CONTAINER_NAME" ls -l /opt/R/environments/renv

echo "Listing installed julia packages..."
apptainer exec "$CONTAINER_NAME" R -e 'print(.libPaths())'

echo "Build complete."