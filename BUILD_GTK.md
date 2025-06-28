# Building C3D with GTK+OpenGL Support

This document describes how to build the C3D application with GTK+ and OpenGL support on Ubuntu Linux.

## Prerequisites

### System Dependencies
First, install the required system packages:

```bash
# Run the installation script
./scripts/install_ubuntu_deps.sh

# Or install manually:
sudo apt update
sudo apt install -y \
    libgtk-3-dev \
    libepoxy-dev \
    pkg-config \
    build-essential \
    cmake \
    git
```

### Conan Dependencies
Make sure you have Conan installed:

```bash
pip install conan
```

## Building

1. **Create build directory:**
   ```bash
   mkdir build && cd build
   ```

2. **Install Conan dependencies:**
   ```bash
   conan install .. --build=missing -s compiler.libcxx=libstdc++11
   ```

3. **Configure and build:**
   ```bash
   cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
   make -j$(nproc)
   ```

4. **Run the application:**
   ```bash
   ./bin/Release/c3d
   ```

## Features

The application now uses:
- **GTK3** for window management (native Linux window decorations)
- **libepoxy** for OpenGL function loading
- **Wayland/X11** support (automatic via GTK)
- Standard window controls (minimize, maximize, close)
- Resizable window with proper OpenGL context

## Troubleshooting

### Missing GTK Development Headers
If you get errors about missing GTK headers:
```bash
sudo apt install libgtk-3-dev
```

### OpenGL Context Issues
If you experience OpenGL context creation problems:
```bash
# Check your graphics drivers
glxinfo | grep "OpenGL version"

# For NVIDIA users, ensure proper drivers are installed
sudo ubuntu-drivers autoinstall
```

### Wayland vs X11
The application works on both Wayland and X11. GTK will automatically choose the appropriate backend.

To force X11 mode:
```bash
GDK_BACKEND=x11 ./bin/Release/c3d
```

To force Wayland mode:
```bash
GDK_BACKEND=wayland ./bin/Release/c3d
```

## Development

### Debug Build
For development with debug symbols:
```bash
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)
```

### Adding OpenGL Features
The `render_frame()` method in `AppWindow` class is where you should add your OpenGL rendering code. The context is already set up with:
- OpenGL 3.3 Core Profile
- Depth buffer enabled
- Proper viewport management

## Architecture

The window management is now handled by:
- **Compositor**: Mutter (GNOME) or equivalent
- **Window Manager**: GTK3 with native decorations
- **Graphics**: OpenGL via libepoxy
- **Event Handling**: GTK event system

This provides a modern, native Linux experience with proper integration into the desktop environment.
