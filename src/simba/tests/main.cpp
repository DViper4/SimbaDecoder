#include "net/ethernet.hpp"
#include "net/ip.hpp"
#include "net/udp.hpp"
#include "pcap/pcap_parser.hpp"
#include "simba/format.hpp"
#include "simba/simba_decoder.hpp"
#include "simba/types.hpp"

#include "logger/logger.hpp"
#include "utils/utils.hpp"

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

    std::ofstream ofs("out2.txt");

    size_t cnt_udp = 0;

    while (true)
    {
        auto packet_opt = parser.Next();
        if (not packet_opt.has_value())
        {
            break;
        }

        auto& [header, data] = *(packet_opt.value());

        ksp::log::Debug("Parsed packet: ts_sec=[{}], ts_usec=[{}], incl_len=[{}], orig_len=[{}]",
                        header.ts_sec, header.ts_usec, header.incl_len, header.orig_len);

        auto reader = ksp::utils::ByteArrayReader(data);

        auto eth = reader.ReadAs<EthernetHeader>();
        if (eth.Type() != EthernetHeader::IP)
        {
            ksp::log::Warn("VLAN parsing not implemented - skipping packet");
            continue;
        }

        auto ip = reader.ReadAs<IpHeader>();
        if (ip.Protocol() != IpHeader::UDP)
        {
            ksp::log::Warn("Non UDP parsing not implemented - skipping packet");
            continue;
        }

        auto udp = reader.ReadAs<UdpHeader>();
        ++cnt_udp;

        bool unsupported_msg = true;
        SimbaDecoder::Decode(reader, [&](const auto& msg)
        {
            std::cout << Format(msg) << "\n\n";
            unsupported_msg = false;
        });

        ksp::utils::Assert(unsupported_msg || not reader.HasMore());
    }

    ksp::utils::Assert(cnt_udp == 3467814, fmt::format("Got {}, should be {}", cnt_udp, 3467814));

    return 0;
}