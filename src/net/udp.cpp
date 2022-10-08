#include "udp.hpp"

#include <arpa/inet.h>

uint16_t UdpHeader::SrcPort() const
{
    return ntohs(src_port);
}

uint16_t UdpHeader::DstPort() const
{
    return ntohs(dst_port);
}

uint16_t UdpHeader::Length() const
{
    return ntohs(length);
}

uint16_t UdpHeader::Checksum() const
{
    return ntohs(checksum);
}