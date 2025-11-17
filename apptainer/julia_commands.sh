#!/bin/bash

CONTAINER_NAME="simple_julia.sif"
RECIPE_FILE="simple_julia.def"

echo "Building the container..."
apptainer build $CONTAINER_NAME $RECIPE_FILE

echo "Testing DataFrames inside the container..."
apptainer exec $CONTAINER_NAME julia -e 'using DataFrames; println("DataFrames is working!")'

echo "Checking Project.toml and Manifest.toml inside the container..."
apptainer exec $CONTAINER_NAME ls /opt/julia/environments/v1.10/

echo "Listing installed julia packages..."
apptainer exec $CONTAINER_NAME julia -e 'using Pkg; Pkg.status()'

echo "Build complete."