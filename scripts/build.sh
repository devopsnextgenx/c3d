#!/bin/bash

# Build script for C3D project
# Usage: ./scripts/build.sh [Debug|Release] [clean] [--no-conan]

BUILD_TYPE=${1:-Release}
CLEAN=${2:-}
NO_CONAN=${3:-}

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build/${BUILD_TYPE,,}"

echo "Building C3D project..."
echo "Build type: ${BUILD_TYPE}"
echo "Build directory: ${BUILD_DIR}"

# Clean if requested
if [[ "$CLEAN" == "clean" ]]; then
    echo "Cleaning build directory..."
    rm -rf "${BUILD_DIR}"
    # Also clean conan cache for this build type
    echo "Cleaning Conan cache for ${BUILD_TYPE}..."
    conan remove "*" --builds --force 2>/dev/null || true
fi

# Create build directory
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Install Conan dependencies if not skipped
if [[ "$NO_CONAN" != "--no-conan" ]]; then
    echo "Installing Conan dependencies for ${BUILD_TYPE}..."
    
    # Install Conan dependencies with build type specific settings
    conan install "${PROJECT_ROOT}" \
        --build=missing \
        --settings=build_type=${BUILD_TYPE} \
        --settings=compiler.cppstd=17 \
        --output-folder="${BUILD_DIR}"
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Conan install failed"
        exit 1
    fi
fi

# Configure
echo "Configuring CMake..."
# Find the correct toolchain file path
TOOLCHAIN_FILE="${BUILD_DIR}/conan_toolchain.cmake"
if [[ ! -f "${TOOLCHAIN_FILE}" ]]; then
    # Try the nested generators path
    TOOLCHAIN_FILE="${BUILD_DIR}/build/${BUILD_TYPE}/generators/conan_toolchain.cmake"
fi

if [[ ! -f "${TOOLCHAIN_FILE}" ]]; then
    echo "Error: Could not find conan_toolchain.cmake"
    echo "Searched in:"
    echo "  ${BUILD_DIR}/conan_toolchain.cmake"
    echo "  ${BUILD_DIR}/build/${BUILD_TYPE}/generators/conan_toolchain.cmake"
    exit 1
fi

echo "Using toolchain file: ${TOOLCHAIN_FILE}"
cmake \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
    -DBUILD_TESTS=ON \
    -DBUILD_EXAMPLES=ON \
    "${PROJECT_ROOT}"

if [[ $? -ne 0 ]]; then
    echo "Error: CMake configuration failed"
    exit 1
fi

# Build
echo "Building..."
cmake --build . --config "${BUILD_TYPE}" --parallel $(nproc 2>/dev/null || echo 4)

if [[ $? -ne 0 ]]; then
    echo "Error: Build failed"
    exit 1
fi

# Run tests if they were built
if [[ -f "bin/${BUILD_TYPE}/unit_tests" || -f "bin/${BUILD_TYPE}/unit_tests.exe" || -f "tests/unit_tests" ]]; then
    echo "Running tests..."
    ctest --build-config "${BUILD_TYPE}" --output-on-failure
fi

echo "Build completed successfully!"
echo "Binaries are in: ${BUILD_DIR}/bin/${BUILD_TYPE}"
echo "Libraries are in: ${BUILD_DIR}/lib/${BUILD_TYPE}"
