cmake_minimum_required(VERSION 4.2)
project(example_print_debug)

set(CMAKE_CXX_STANDARD 20)

include(print_debug/PrintDebug.cmake)


add_executable(example_print_debug example/main.cpp)

#================================================================================================
set(EXAMPLE_APP_RELEASE_PRINT_DEBUG_LEVEL ${RELEASE_PRINT_DEBUG_LEVEL} CACHE STRING "Debug level for main in release builds")
set(EXAMPLE_APP_DEBUG_PRINT_DEBUG_LEVEL ${DEBUG_PRINT_DEBUG_LEVEL} CACHE STRING "Debug level for main in debug builds")

define_print_debug_level_for_target(example_print_debug ${EXAMPLE_APP_RELEASE_PRINT_DEBUG_LEVEL} ${EXAMPLE_APP_DEBUG_PRINT_DEBUG_LEVEL})
#================================================================================================
