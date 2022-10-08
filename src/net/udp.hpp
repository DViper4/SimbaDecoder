#pragma once

#include <cinttypes>

class UdpHeader
{
   public:
    uint16_t SrcPort() const;
    uint16_t DstPort() const;
    uint16_t Length() const;
    uint16_t Checksum() const;

   private:
    uint16_t src_port;
    uint16_t dst_port;
    uint16_t length;
    uint16_t checksum;
};
static_assert(sizeof(UdpHeader) == 8);