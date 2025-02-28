#include "pcap/pcap_parser.hpp"

#include "logger/logger.hpp"

int main(int argc, char *argv[])
{
    ksp::log::load_argv_levels(argc, argv);

    PcapParser parser("/home/oded/dev/pcap_eqivalent/2023-10-09.2349-2355.pcap");

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