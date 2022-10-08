#include "net/ethernet.hpp"
#include "net/ip.hpp"
#include "net/udp.hpp"
#include "pcap_parser/pcap_parser.hpp"
#include "simba_decoder/simba_decoder.hpp"
#include "simba_decoder/types.hpp"

#include "logger/logger.hpp"

template <typename T>
T& Read(uint8_t*& cur)
{
    auto data = reinterpret_cast<T*>(cur);
    cur += sizeof(T);
    return *data;
}

int main()
{
    PcapParser parser("/workdir/Corvil-13052-1636559040000000000-1636560600000000000.pcap");

    std::vector<std::string> out_log;

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

        auto cur = data.data();

        auto& eth = Read<EthernetHeader>(cur);
        if (eth.Type() != EthernetHeader::IP)
        {
            ksp::log::Warn("VLAN parsing not implemented - skipping packet");
            continue;
        }

        auto& ip = Read<IpHeader>(cur);
        if (ip.Protocol() != IpHeader::UDP)
        {
            ksp::log::Warn("Non UDP parsing not implemented - skipping packet");
            continue;
        }

        auto& udp = Read<UdpHeader>(cur);

        auto& mdph = Read<MarketDataPacketHeader>(cur);
        ksp::log::Debug("{}, {}", mdph.sending_time, mdph.msg_seq_num);

        if (mdph.IsIncremental())
        {
            auto& iph = Read<IncrementalPacketHeader>(cur);
            ksp::log::Debug("{}", iph.transact_time);

            while (cur < &*data.end())
            {
                auto& sbeh = Read<SBEHeader>(cur);
                ksp::log::Debug("{}, {}, {}, {}",
                                sbeh.schema_id, sbeh.template_id, sbeh.version, sbeh.block_length);

                switch (sbeh.template_id)
                {
                    case OrderUpdate::TEMPLATE_ID:
                    {
                        auto& ou = Read<OrderUpdate>(cur);
                        ksp::log::Info("{}, {}", ou.rtp_seq, 5);
                        // out_log.emplace_back(fmt::format("{}, {}", ou.rtp_seq, 5));
                        break;
                    }
                    case OrderExecution::TEMPLATE_ID:
                    {
                        auto& oe = Read<OrderExecution>(cur);
                        ksp::log::Info("{}, {}", oe.rtp_seq, 6);
                        // out_log.emplace_back(fmt::format("{}, {}", oe.rtp_seq, 6));
                        break;
                    }
                    default:
                    {
                        cur += sbeh.block_length;
                        break;
                    }
                }
            }
        }
        else
        {
        }
    }

    return 0;
}