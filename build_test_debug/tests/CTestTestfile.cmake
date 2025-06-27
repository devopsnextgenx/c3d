# CMake generated Testfile for 
# Source directory: D:/github/devopsnextgenx/c3d/tests
# Build directory: D:/github/devopsnextgenx/c3d/build_test_debug/tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
if(CTEST_CONFIGURATION_TYPE MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
  add_test(UnitTests "D:/github/devopsnextgenx/c3d/build_test_debug/bin/Debug/unit_tests.exe")
  set_tests_properties(UnitTests PROPERTIES  _BACKTRACE_TRIPLES "D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;41;add_test;D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;0;")
elseif(CTEST_CONFIGURATION_TYPE MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
  add_test(UnitTests "D:/github/devopsnextgenx/c3d/build_test_debug/bin/Release/unit_tests.exe")
  set_tests_properties(UnitTests PROPERTIES  _BACKTRACE_TRIPLES "D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;41;add_test;D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;0;")
elseif(CTEST_CONFIGURATION_TYPE MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
  add_test(UnitTests "D:/github/devopsnextgenx/c3d/build_test_debug/bin/MinSizeRel/unit_tests.exe")
  set_tests_properties(UnitTests PROPERTIES  _BACKTRACE_TRIPLES "D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;41;add_test;D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;0;")
elseif(CTEST_CONFIGURATION_TYPE MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
  add_test(UnitTests "D:/github/devopsnextgenx/c3d/build_test_debug/bin/RelWithDebInfo/unit_tests.exe")
  set_tests_properties(UnitTests PROPERTIES  _BACKTRACE_TRIPLES "D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;41;add_test;D:/github/devopsnextgenx/c3d/tests/CMakeLists.txt;0;")
else()
  add_test(UnitTests NOT_AVAILABLE)
endif()
