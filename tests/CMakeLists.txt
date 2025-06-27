find_package(GTest REQUIRED)

# Unit tests
add_executable(unit_tests
    unit/test_main.cpp
    # Add more test files here
)

target_link_libraries(unit_tests PRIVATE
    GTest::gtest
    GTest::gtest_main
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
        GTest::gtest
        GTest::gtest_main
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
