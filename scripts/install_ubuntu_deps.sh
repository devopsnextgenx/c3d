#!/bin/bash

# Install GTK3 development packages for Ubuntu
echo "Installing GTK3 and OpenGL development dependencies for Ubuntu..."

sudo apt update

# Install GTK3 development packages
sudo apt install -y \
    libgtk-3-dev \
    libepoxy-dev \
    pkg-config \
    build-essential \
    cmake \
    git

# Optional: Install additional development tools
sudo apt install -y \
    gdb \
    valgrind \
    clang-format \
    clang-tidy

echo "Ubuntu dependencies installed successfully!"
echo "You can now build the project with GTK support."
