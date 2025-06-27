# Examples
add_executable(basic_example basic_example.cpp)

target_include_directories(basic_example PRIVATE
    ${PROJECT_SOURCE_DIR}/include
)

# Link against c3d library
target_link_libraries(basic_example PRIVATE c3d_lib)
