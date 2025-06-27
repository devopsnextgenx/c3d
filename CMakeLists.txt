cmake_minimum_required(VERSION 3.15)
project(c3d VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set default build type to Release if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Find vcpkg toolchain file
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    find_program(VCPKG_EXECUTABLE vcpkg PATHS "$ENV{VCPKG_ROOT}" "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg" NO_DEFAULT_PATH)
    if(VCPKG_EXECUTABLE)
        get_filename_component(VCPKG_ROOT "${VCPKG_EXECUTABLE}" DIRECTORY)
        set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
        message(STATUS "Found vcpkg toolchain: ${CMAKE_TOOLCHAIN_FILE}")
    else()
        message(WARNING "vcpkg not found. Please set VCPKG_ROOT environment variable or install vcpkg.")
    endif()
endif()

# Include external dependencies
include(external/cmake/external_deps.cmake)

# Add subdirectories
add_subdirectory(src)
add_subdirectory(libs)

# Add examples
add_subdirectory(examples)

# Enable testing
enable_testing()
add_subdirectory(tests)

# Installation rules
install(DIRECTORY include/ DESTINATION include)
install(FILES README.md DESTINATION .)
