#!/bin/bash
set -e

echo "Code build"

SEARCH_PATH="/workspace/evkbimxrt1050_hello_world/"
TARGERT_DIR="build"

DIR_PATH=$(find /workspace/ -type d -name "build")

#DIR_PATH=$(find "$SEARCH_PATH" -type d -name "$TARGET_DIR" -print -quit)

# if [ -n "$DIR_PATH" ]; then
#     echo "build dir found, clean build"
#     rm -rf build
#     mkdir build
# else
#     echo "build not found"
#     mkdir /workspace/build
# fi

cmake -S /workspace/project/evkbimxrt1050_hello_world/ -B /workspace/build
cmake --build /workspace/build
