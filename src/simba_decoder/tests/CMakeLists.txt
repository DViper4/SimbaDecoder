ksp_add_executable(simba_decoder_test)

target_include_directories(simba_decoder_test PUBLIC ../../)

target_link_libraries(simba_decoder_test simba_decoder pcap_parser)