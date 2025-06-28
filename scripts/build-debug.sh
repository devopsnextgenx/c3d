#!/bin/bash

# Quick build script for Debug configuration
# Usage: ./scripts/build-debug.sh [clean] [--no-conan]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/build.sh" Debug "$@"
