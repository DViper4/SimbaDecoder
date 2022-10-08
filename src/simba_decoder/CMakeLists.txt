ksp_add_library(simba_decoder)

target_link_libraries(simba_decoder net logger utils)

add_subdirectory(tests)