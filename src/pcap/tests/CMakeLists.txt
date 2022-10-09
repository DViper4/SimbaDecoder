ksp_add_executable(pcap_parser_test)

target_include_directories(pcap_parser_test PUBLIC ../..)

target_link_libraries(pcap_parser_test pcap_parser)