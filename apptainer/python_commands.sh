#!/bin/bash

CONTAINER_NAME="simple_python.sif"
RECIPE_FILE="simple_python.def"

echo "Building the container..."
apptainer build $CONTAINER_NAME $RECIPE_FILE

echo "Testing python in the container..."
apptainer exec "$CONTAINER_NAME" python -c "import bs4; print(bs4.__version__)"

echo "Checking which python inside the container..."
apptainer exec "$CONTAINER_NAME" which python 

echo "Build complete."
