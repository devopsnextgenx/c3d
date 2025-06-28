# Create c3d library
add_library(c3d_lib 
    c3d/math/calc.cpp
    c3d/graphics/canvasConfig.cpp
    c3d/graphics/c3dRenderer.cpp
    c3d/graphics/c3dUtils.cpp
)

target_include_directories(c3d_lib PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_include_directories(c3d_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/private
)

# Find GTK and related packages using pkg-config
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
pkg_check_modules(EPOXY REQUIRED epoxy)

# Create main executable
add_executable(c3d main.cpp c3d/appWindow/appWindow.cpp)

# Apply GTK flags and link libraries
target_compile_options(c3d PRIVATE ${GTK3_CFLAGS_OTHER})
target_include_directories(c3d PRIVATE ${GTK3_INCLUDE_DIRS} ${EPOXY_INCLUDE_DIRS})
target_link_directories(c3d PRIVATE ${GTK3_LIBRARY_DIRS} ${EPOXY_LIBRARY_DIRS})

# Find GLM
find_package(glm REQUIRED)

# Link against project libraries
target_link_libraries(c3d_lib PRIVATE
    glm::glm
)

target_link_libraries(c3d PRIVATE
    c3d_lib
    ${GTK3_LIBRARIES}
    ${EPOXY_LIBRARIES}
    glm::glm
)

# Link against external dependencies
if(TARGET boost_external)
    target_link_libraries(c3d PRIVATE boost_external)
endif()

if(TARGET nlohmann_json)
    target_link_libraries(c3d PRIVATE nlohmann_json)
endif()

# Include directories
target_include_directories(c3d PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/private
    ${PROJECT_SOURCE_DIR}/include
)

# Compiler-specific options
if(MSVC)
    target_compile_options(c3d PRIVATE /W4)
else()
    target_compile_options(c3d PRIVATE -Wall -Wextra -Wpedantic)
endif()

# Install the executable
install(TARGETS c3d DESTINATION bin)
