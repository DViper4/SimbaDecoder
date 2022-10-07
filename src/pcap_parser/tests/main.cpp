#include "pcap_parser.hpp"

#include "logger/logger.hpp"

int main()
{
    PcapParser parser("/workdir/Corvil-13052-1636559040000000000-1636560600000000000.pcap");

    while (true)
    {
        auto packet_opt = parser.Next();
        if (not packet_opt.has_value())
        {
            break;
        }

        auto& [header, data] = packet_opt.value();

        ksp::log::Debug("Parsed packet: ts_sec=[{}], ts_usec=[{}], incl_len=[{}], orig_len=[{}]",
                        header.ts_sec, header.ts_usec, header.incl_len, header.incl_len);
    }

    return 0;
}