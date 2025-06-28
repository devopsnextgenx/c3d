### build instructions

**Note**: The Conan dependencies are currently configured for Release build only. If you need Debug mode, you'll need to install dependencies for Debug configuration as well.

#### Release Build (Recommended)
```
cd "/d/github/devopsnextgenx/c3d"
conan profile detect
conan remote add conan-community https://center.conan.io
conan install . --output-folder=build --build=missing 
python -m conans.conan install . --output-folder=build --build=missing
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=build/build/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
./build/bin/Release/unit_tests.exe
./build/bin/Release/basic_example.exe
./build/bin/Release/c3d.exe
```

#### Debug Build (Requires additional Conan setup)
```
cd "/d/github/devopsnextgenx/c3d"
conan profile detect
conan remote add conan-community https://center.conan.io
# Install Release dependencies first
conan install . --output-folder=build --build=missing --settings=build_type=Release
# Install Debug dependencies (this adds to existing Release dependencies)
conan install . --output-folder=build --build=missing --settings=build_type=Debug
python -m conans.conan install . --output-folder=build --build=missing --settings=build_type=Debug
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=build/build/Debug/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
./build/bin/Debug/unit_tests.exe
./build/bin/Debug/basic_example.exe
./build/bin/Debug/c3d.exe
```

#### Debug Build Workaround (for libpng/OpenCV issues)

If you encounter libpng download errors (403 Forbidden) when building Debug configuration, use this workaround to build and run tests:

```bash
cd "/d/github/devopsnextgenx/c3d"

# Create a minimal conanfile for Debug tests
cat > conanfile_debug.txt << EOF
[requires]
gtest/1.14.0

[options]

[generators]
CMakeToolchain
CMakeDeps

[layout]
cmake_layout
EOF

# Install GTest for Debug
python -m conans.conan install conanfile_debug.txt --output-folder=build_debug --build=missing --settings=build_type=Debug

# Create a test-only CMakeLists.txt
cat > CMakeLists_tests.txt << EOF
cmake_minimum_required(VERSION 3.15)
project(c3d_tests VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)

find_package(GTest REQUIRED)

add_subdirectory(src)
enable_testing()
add_subdirectory(tests)
EOF

# Backup original CMakeLists.txt and use test version
cp CMakeLists.txt CMakeLists_original.txt
cp CMakeLists_tests.txt CMakeLists.txt

# Configure and build tests only
cmake -B build_test_debug -S . -DCMAKE_TOOLCHAIN_FILE=build_debug/build/generators/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build_test_debug --config Debug

# Run tests
./build_test_debug/bin/Debug/unit_tests.exe

# Restore original CMakeLists.txt
cp CMakeLists_original.txt CMakeLists.txt
```

#### Running Tests with CTest 
```
cd "/d/github/devopsnextgenx/c3d"
ctest --test-dir build -C Release
```

conan install . --output-folder=build --build=missing --settings=build_type=Debug
python -m conans.conan install . --build=missing --settings=build_type=Debug