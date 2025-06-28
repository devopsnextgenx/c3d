cmake_minimum_required(VERSION 3.15)
project(c3d VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set default build type to Release if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Enhanced debug symbol generation for Linux
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    # Generate full debug information with DWARF-4 format
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS_DEBUG "-g3 -gdwarf-4 -O0 -fno-omit-frame-pointer")
        set(CMAKE_C_FLAGS_DEBUG "-g3 -gdwarf-4 -O0 -fno-omit-frame-pointer")
        
        # Additional debugging aids
        add_compile_definitions(DEBUG=1)
        add_compile_definitions(_DEBUG=1)
        
        # Enable runtime checks (if supported)
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fstack-protector-all")
            set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fstack-protector-all")
        endif()
        
        message(STATUS "Enhanced debug symbols enabled: ${CMAKE_CXX_FLAGS_DEBUG}")
    endif()
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    # Ensure release builds are optimized and stripped of debug info
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG -s")
        set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -s")
        message(STATUS "Release optimization enabled: ${CMAKE_CXX_FLAGS_RELEASE}")
    endif()
endif()

# Output directories - build type specific
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE})

# For multi-config generators (Visual Studio, Xcode)
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/bin/${OUTPUTCONFIG})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/${OUTPUTCONFIG})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${CMAKE_BINARY_DIR}/lib/${OUTPUTCONFIG})
endforeach()

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
