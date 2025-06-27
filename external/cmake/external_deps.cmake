# External Dependencies Configuration

# Function to add external library with both debug and release versions
function(add_external_library target_name include_dir)
    add_library(${target_name} INTERFACE)
    target_include_directories(${target_name} INTERFACE ${include_dir})
    
    # Add debug libraries if they exist
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/external/installed/lib/debug")
        file(GLOB DEBUG_LIBS "${CMAKE_CURRENT_SOURCE_DIR}/external/installed/lib/debug/*${target_name}*")
        if(DEBUG_LIBS)
            target_link_libraries(${target_name} INTERFACE 
                $<$<CONFIG:Debug>:${DEBUG_LIBS}>
            )
        endif()
    endif()
    
    # Add release libraries if they exist
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/external/installed/lib/release")
        file(GLOB RELEASE_LIBS "${CMAKE_CURRENT_SOURCE_DIR}/external/installed/lib/release/*${target_name}*")
        if(RELEASE_LIBS)
            target_link_libraries(${target_name} INTERFACE 
                $<$<CONFIG:Release>:${RELEASE_LIBS}>
                $<$<CONFIG:RelWithDebInfo>:${RELEASE_LIBS}>
                $<$<CONFIG:MinSizeRel>:${RELEASE_LIBS}>
            )
        endif()
    endif()
endfunction()

# Add common external dependencies
set(EXTERNAL_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/external/installed/include")

# Example: Add Boost (if available)
if(EXISTS "${EXTERNAL_INCLUDE_DIR}/boost")
    add_external_library(boost_external "${EXTERNAL_INCLUDE_DIR}")
endif()

# Example: Add OpenCV (if available)
if(EXISTS "${EXTERNAL_INCLUDE_DIR}/opencv2")
    add_external_library(opencv_external "${EXTERNAL_INCLUDE_DIR}")
endif()

# Add header-only libraries from source
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/external/source/json")
    add_library(nlohmann_json INTERFACE)
    target_include_directories(nlohmann_json INTERFACE 
        "${CMAKE_CURRENT_SOURCE_DIR}/external/source/json/single_include"
    )
endif()

# Try to find Google Test first
find_package(GTest QUIET)
if(NOT GTest_FOUND)
    # Try to download and build googletest if not found
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        v1.14.0
    )
    
    # For Windows: Prevent overriding the parent project's compiler/linker settings
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    
    FetchContent_MakeAvailable(googletest)
    
    message(STATUS "GoogleTest downloaded and built from source")
endif()

# Add source-based libraries
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/external/source/googletest")
    add_subdirectory(external/source/googletest)
endif()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/external/source/eigen")
    add_subdirectory(external/source/eigen)
endif()

# Use system package manager (vcpkg, conan, etc.) as fallback
find_package(PkgConfig QUIET)

# Try to find common packages
find_package(Boost QUIET)
if(Boost_FOUND AND NOT TARGET boost_external)
    add_library(boost_external INTERFACE)
    target_link_libraries(boost_external INTERFACE Boost::boost)
endif()

find_package(OpenCV QUIET)
if(OpenCV_FOUND AND NOT TARGET opencv_external)
    add_library(opencv_external INTERFACE)
    target_link_libraries(opencv_external INTERFACE ${OpenCV_LIBS})
    target_include_directories(opencv_external INTERFACE ${OpenCV_INCLUDE_DIRS})
endif()
