#!/bin/bash

# Quick build script for Release configuration
# Usage: ./scripts/build-release.sh [clean] [--no-conan]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/build.sh" Release "$@"
