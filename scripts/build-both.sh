#!/bin/bash

# Build script for both Debug and Release configurations
# Usage: ./scripts/build-both.sh [clean] [--no-conan]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=================================="
echo "Building both Debug and Release configurations"
echo "=================================="

# Build Debug first
echo ""
echo "Building Debug configuration..."
echo "=================================="
"${SCRIPT_DIR}/build.sh" Debug "$@"
DEBUG_EXIT_CODE=$?

# Build Release second
echo ""
echo "Building Release configuration..."
echo "=================================="
"${SCRIPT_DIR}/build.sh" Release "$@"
RELEASE_EXIT_CODE=$?

# Summary
echo ""
echo "=================================="
echo "Build Summary:"
if [[ $DEBUG_EXIT_CODE -eq 0 ]]; then
    echo "✓ Debug build: SUCCESS"
else
    echo "✗ Debug build: FAILED"
fi

if [[ $RELEASE_EXIT_CODE -eq 0 ]]; then
    echo "✓ Release build: SUCCESS"
else
    echo "✗ Release build: FAILED"
fi
echo "=================================="

# Exit with error if any build failed
if [[ $DEBUG_EXIT_CODE -ne 0 || $RELEASE_EXIT_CODE -ne 0 ]]; then
    exit 1
fi

echo "Both builds completed successfully!"
echo "Debug binaries: build/debug/bin/Debug/"
echo "Release binaries: build/release/bin/Release/"
