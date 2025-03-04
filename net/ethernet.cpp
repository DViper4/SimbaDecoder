#include "ethernet.hpp"

#include <arpa/inet.h>
#include <iomanip>
#include <sstream>

static std::string ToHexStr(int val)
{
    std::stringstream stream;
    stream << std::setw(2) << std::setfill('0') << std::hex << val;
    return stream.str();
}

static std::string MacToStr(const EthernetHeader::MacAddress& mac)
{
    std::string addr_str;
    addr_str.reserve(18);

    for (auto b : mac)
    {
        addr_str += ToHexStr(b) + ":";
    }
    addr_str.pop_back();

    return addr_str;
}

std::string EthernetHeader::DestAddr() const
{
    return MacToStr(dest_addr);
}

std::string EthernetHeader::SrcAddr() const
{
    return MacToStr(src_addr);
}

EthernetHeader::PayloadType EthernetHeader::Type() const
{
    return PayloadType(ntohs(type));
}