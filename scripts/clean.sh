#!/bin/bash

# Clean script for C3D project
# Usage: ./scripts/clean.sh [Debug|Release|all] [--conan-cache]

BUILD_TYPE=${1:-all}
CLEAN_CONAN_CACHE=${2:-}

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "C3D Clean Script"
echo "================"

case "$BUILD_TYPE" in
    "Debug"|"debug")
        echo "Cleaning Debug build..."
        rm -rf "${PROJECT_ROOT}/build/debug"
        echo "Debug build cleaned."
        ;;
    "Release"|"release")
        echo "Cleaning Release build..."
        rm -rf "${PROJECT_ROOT}/build/release"
        echo "Release build cleaned."
        ;;
    "all"|"All"|"ALL")
        echo "Cleaning all builds..."
        rm -rf "${PROJECT_ROOT}/build"
        rm -rf "${PROJECT_ROOT}/out"
        echo "All builds cleaned."
        ;;
    *)
        echo "Usage: $0 [Debug|Release|all] [--conan-cache]"
        echo ""
        echo "Arguments:"
        echo "  Debug     - Clean only Debug build"
        echo "  Release   - Clean only Release build" 
        echo "  all       - Clean all builds (default)"
        echo ""
        echo "Options:"
        echo "  --conan-cache - Also clean Conan cache"
        exit 1
        ;;
esac

# Clean Conan cache if requested
if [[ "$CLEAN_CONAN_CACHE" == "--conan-cache" ]]; then
    echo "Cleaning Conan cache..."
    conan remove "*" --builds --force 2>/dev/null || true
    echo "Conan cache cleaned."
fi

echo "Clean completed!"
