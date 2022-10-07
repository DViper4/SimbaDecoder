#include "pcap_parser.hpp"

#include "logger/logger.hpp"
#include "utils/utils.hpp"

#include <fstream>


PcapParser::PcapParser(const std::string& filename)
: ifs(filename, std::ios::binary)
{
    if (not ifs.is_open())
    {
        throw std::runtime_error("Could not open file");
    }

    ParseGlobalHeader();
}

void PcapParser::ParseGlobalHeader()
{
    PcapGlobalHeader pcap;

    auto cnt = ifs.read(reinterpret_cast<char*>(&pcap), sizeof(pcap)).gcount();
    if (cnt != sizeof(pcap))
    {
        throw std::runtime_error("Could not parse global header: not enough bytes");
    }

    ksp::log::Info("Parsed global header: "
                   "magic_number=[{}], version_major=[{}], version_minor=[{}], "
                   "thiszone=[{}], sigfigs=[{}], snaplen=[{}], network=[{}]",
                   pcap.magic_number, pcap.version_major, pcap.version_minor,
                   pcap.thiszone, pcap.sigfigs, pcap.snaplen, pcap.network);
}

std::optional<PcapParser::Packet> PcapParser::Next()
{
    Packet packet;

    auto cnt = ifs.read(reinterpret_cast<char*>(&packet.header), sizeof(packet.header)).gcount();
    if (cnt != sizeof(packet.header))
    {
        if (cnt > 0)
        {
            throw std::runtime_error("Could not parse packet header: not enough bytes");
        }

        return std::nullopt;
    }

    packet.data.resize(packet.header.incl_len);

    cnt = ifs.read(reinterpret_cast<char*>(packet.data.data()), packet.header.incl_len).gcount();
    if (cnt != packet.header.incl_len)
    {
        throw std::runtime_error("Could not read packet data: not enough bytes");
    }

    return packet;
}