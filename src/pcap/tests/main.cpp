#include "pcap/pcap_parser.hpp"

#include "logger/logger.hpp"

int main(int argc, char *argv[])
{
    if (argc < 2 || argc > 3)
    {
        ksp::log::Critical("./binary [path to pcap file] [log level (optional)]");
        ksp::log::Critical("example: ./..../2023-10-10.0845-0905.pcap ./bin/simba_decoder_test SPDLOG_LEVEL=info,mylogger=info");
        return 1;
    }

    PcapParser parser(argv[1]);

    ksp::log::load_argv_levels(argc, argv);


    while (true)
    {
        auto packet_opt = parser.Next();
        if (not packet_opt.has_value())
        {
            break;
        }

        auto& [header, data] = *(packet_opt.value());

        ksp::log::Debug("Parsed packet: ts_sec=[{}], ts_usec=[{}], incl_len=[{}], orig_len=[{}]",
                        header.ts_sec, header.ts_usec, header.incl_len, header.incl_len);
    }

    return 0;
}