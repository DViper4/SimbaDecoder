ksp_add_library(pcap_parser)

target_link_libraries(pcap_parser logger utils)

add_subdirectory(tests)