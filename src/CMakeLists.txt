# Create c3d library
add_library(c3d_lib calc.cpp)

target_include_directories(c3d_lib PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_include_directories(c3d_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/private
)

# Create main executable
add_executable(c3d main.cpp)

# Link against project libraries
target_link_libraries(c3d PRIVATE
    c3d_lib
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
