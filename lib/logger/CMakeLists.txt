ksp_add_library(logger)

find_package(spdlog REQUIRED)

target_link_libraries(logger spdlog::spdlog)