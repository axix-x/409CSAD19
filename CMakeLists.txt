cmake_minimum_required(VERSION 3.16)

project(hello LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FetchContent)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
)
FetchContent_MakeAvailable(googletest)

add_library(add_lib src/add.cpp)
target_include_directories(add_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_executable(hello src/main.cpp)
target_link_libraries(hello PRIVATE add_lib)

enable_testing()

add_executable(test_add tests/test_add.cpp)
target_link_libraries(test_add PRIVATE add_lib GTest::gtest_main)
include(GoogleTest)
gtest_discover_tests(test_add)
