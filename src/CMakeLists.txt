cmake_minimum_required(VERSION 3.17.3)

project(simba-decoder)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_compile_options(-O3 -ffast-math)

include(${CMAKE_CURRENT_SOURCE_DIR}/lib/cmake/utils.cmake)

set(CONAN_CMAKE_SILENT_OUTPUT ON)
ksp_conan_setup()
ksp_conan_run()

add_subdirectory(lib/logger)
add_subdirectory(lib/utils)
add_subdirectory(pcap_parser)
add_subdirectory(net)
add_subdirectory(simba_decoder)