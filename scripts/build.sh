#!/bin/bash

# Build script for C3D project
# Usage: ./scripts/build.sh [Debug|Release] [clean]

BUILD_TYPE=${1:-Release}
CLEAN=${2:-}

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build/${BUILD_TYPE,,}"

echo "Building C3D project..."
echo "Build type: ${BUILD_TYPE}"
echo "Build directory: ${BUILD_DIR}"

# Clean if requested
if [[ "$CLEAN" == "clean" ]]; then
    echo "Cleaning build directory..."
    rm -rf "${BUILD_DIR}"
fi

# Create build directory
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Configure
echo "Configuring CMake..."
cmake \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DBUILD_TESTS=ON \
    -DBUILD_EXAMPLES=ON \
    "${PROJECT_ROOT}"

# Build
echo "Building..."
cmake --build . --config "${BUILD_TYPE}" --parallel $(nproc 2>/dev/null || echo 4)

# Run tests if they were built
if [[ -f "tests/unit_tests" || -f "tests/${BUILD_TYPE}/unit_tests.exe" ]]; then
    echo "Running tests..."
    ctest --build-config "${BUILD_TYPE}" --output-on-failure
fi

echo "Build completed successfully!"
echo "Binaries are in: ${BUILD_DIR}"
