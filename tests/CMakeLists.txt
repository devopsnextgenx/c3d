find_package(GTest QUIET)

if(GTest_FOUND)
    # Use system-installed Google Test
    set(GTEST_LIBRARIES GTest::gtest GTest::gtest_main)
    message(STATUS "Using system Google Test")
elseif(TARGET gtest AND TARGET gtest_main)
    # Use downloaded/built Google Test
    set(GTEST_LIBRARIES gtest gtest_main)
    message(STATUS "Using downloaded Google Test")
else()
    message(WARNING "GoogleTest not found. Tests will not be built.")
    return()
endif()

# Unit tests
add_executable(unit_tests
    unit/test_main.cpp
    # Add more test files here
)

target_link_libraries(unit_tests PRIVATE
    ${GTEST_LIBRARIES}
    c3d_lib
)

target_include_directories(unit_tests PRIVATE
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/src
)

# Integration tests (if the file exists)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/integration/integration_tests.cpp")
    add_executable(integration_tests
        integration/integration_tests.cpp
    )
    
    target_link_libraries(integration_tests PRIVATE
        ${GTEST_LIBRARIES}
        # Link against your libraries to test
    )
    
    target_include_directories(integration_tests PRIVATE
        ${PROJECT_SOURCE_DIR}/include
    )
    
    # Register integration tests with CTest
    add_test(NAME IntegrationTests COMMAND integration_tests)
endif()

# Register tests with CTest
add_test(NAME UnitTests COMMAND unit_tests)
