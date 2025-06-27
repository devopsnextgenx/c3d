# C3D Project Folder Structure

## Overview
This project follows a structured approach to organize C/C++ code, dependencies, and build artifacts for CMake-based projects.

## Folder Structure Explained

### Core Project Folders

- **`include/`** - Public headers that define your project's API
  - Contains headers that other projects can include
  - Organized with namespace folders (e.g., `include/c3d/`)
  - These headers are installed with the library

- **`src/`** - Implementation files and private headers
  - Contains `.cpp` files and implementation details
  - `private/` subfolder for headers used only within your project
  - Not exposed to external users

- **`libs/`** - Your project's internal libraries/modules
  - Each module has its own CMakeLists.txt
  - Self-contained components that can be reused
  - Example: math utilities, data structures, etc.

### External Dependencies

- **`external/installed/`** - Pre-compiled dependencies
  - `include/` - Third-party headers
  - `lib/debug/` - Debug versions of static/dynamic libraries
  - `lib/release/` - Release versions of static/dynamic libraries
  - Use this for binary distributions (e.g., downloaded SDKs)

- **`external/source/`** - Third-party source code
  - For libraries you compile from source
  - Header-only libraries (e.g., nlohmann/json, Eigen)
  - Full source libraries (e.g., GoogleTest, fmt)
  - Each can have its own CMakeLists.txt

- **`external/cmake/`** - CMake modules for dependency management
  - Custom FindXXX.cmake modules
  - Configuration scripts for external dependencies

### Testing and Examples

- **`tests/`** - All test code
  - `unit/` - Unit tests for individual components
  - `integration/` - Integration tests for complete workflows

- **`examples/`** - Usage examples and demos
  - Helps users understand how to use your library
  - Can serve as integration tests

### Development Support

- **`docs/`** - Documentation
  - API documentation, build instructions, etc.

- **`scripts/`** - Build and utility scripts
  - Platform-specific build scripts
  - Dependency installation scripts
  - Environment setup scripts

## Best Practices

### 1. Dependency Management Strategy

**Option A: Package Managers (Recommended)**
```bash
# vcpkg
vcpkg install boost opencv
# or conan
conan install . --build=missing
```

**Option B: Manual Management**
- Use `external/installed/` for pre-built binaries
- Use `external/source/` for source code you want to compile

### 2. Header Organization

**Public Headers** (`include/project_name/`)
```cpp
// include/c3d/api.h
#pragma once
namespace c3d {
    class PublicAPI {
        // Public interface
    };
}
```

**Private Headers** (`src/private/`)
```cpp
// src/private/internal.h
#pragma once
// Internal implementation details
```

### 3. CMake Integration

The CMake structure automatically:
- Finds and links external dependencies
- Handles debug/release library variants
- Supports both source and binary dependencies
- Provides proper include paths

### 4. Third-Party Source Code

For third-party source that you want to include:

**Header-Only Libraries:**
```
external/source/json/
├── CMakeLists.txt          # Optional wrapper
└── single_include/
    └── nlohmann/
        └── json.hpp
```

**Full Source Libraries:**
```
external/source/googletest/
├── CMakeLists.txt
├── include/
└── src/
```

## Usage Examples

### Adding a New External Library (Binary)
1. Place headers in `external/installed/include/`
2. Place libraries in `external/installed/lib/debug/` and `external/installed/lib/release/`
3. Update `external/cmake/external_deps.cmake`

### Adding Third-Party Source Code
1. Place source in `external/source/library_name/`
2. Add `add_subdirectory(external/source/library_name)` in external_deps.cmake
3. Link against the target in your CMakeLists.txt

### Building the Project
```bash
mkdir build && cd build
cmake ..
cmake --build .
ctest  # Run tests
```

This structure scales well from small projects to large codebases and integrates seamlessly with modern C++ dependency management tools.
