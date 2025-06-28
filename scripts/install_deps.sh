#!/bin/bash

# Dependency installation script
# This script helps install common C++ dependencies

echo "C3D Dependency Installation Script"
echo "=================================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install vcpkg dependencies
install_vcpkg_deps() {
    if command_exists vcpkg; then
        echo "Installing dependencies with vcpkg..."
        vcpkg install boost:x64-windows opencv:x64-windows nlohmann-json:x64-windows gtest:x64-windows
    else
        echo "vcpkg not found. Please install vcpkg first."
        echo "See: https://github.com/Microsoft/vcpkg"
    fi
}

# Function to install conan dependencies
install_conan_deps() {
    if command_exists conan; then
        echo "Installing dependencies with Conan..."
        conan install . --build=missing
    else
        echo "Conan not found. Please install conan first."
        echo "pip install conan"
    fi
}

# Main menu
echo "Choose dependency management method:"
echo "1) vcpkg (Microsoft package manager)"
echo "2) Conan (C++ package manager)"
echo "3) Manual (download and place in external/)"
echo "4) Exit"

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        install_vcpkg_deps
        ;;
    2)
        install_conan_deps
        ;;
    3)
        echo "For manual installation:"
        echo "1. Download library binaries"
        echo "2. Place headers in external/installed/include/"
        echo "3. Place libraries in external/installed/lib/debug/ and external/installed/lib/release/"
        echo "4. Update external/cmake/external_deps.cmake if needed"
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo "Dependency installation completed!"
