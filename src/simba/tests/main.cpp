#include "net/ethernet.hpp"
#include "net/ip.hpp"
#include "net/udp.hpp"
#include "pcap/pcap_parser.hpp"
#include "simba/format.hpp"
#include "simba/simba_decoder.hpp"
#include "simba/types.hpp"

#include "logger/logger.hpp"
#include "utils/utils.hpp"

int main()
{
    PcapParser parser("/workdir/Corvil-13052-1636559040000000000-1636560600000000000.pcap");

    std::ofstream ofs("out2.txt");
    SimbaDecoder decoder;

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
                        header.ts_sec, header.ts_usec, header.incl_len, header.incl_len);

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

        decoder.Decode(reader, [&] (const auto& msg)
        {
            ofs << Format(msg) << "\n\n";
        });
    }

    ksp::utils::Assert(cnt_udp == 3467814, fmt::format("Got {}, should be {}", cnt_udp, 3467814));

    return 0;
}