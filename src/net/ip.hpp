#pragma once

#include <cinttypes>

struct IpHeader
{
    enum ProtocolNumber : uint8_t
    {
        UDP = 17,
    };

   public:
    ProtocolNumber Protocol() const { return protocol; }

   private:
    uint8_t ihl : 4;
    uint8_t version : 4;
    uint8_t tos;
    uint16_t total_length;
    uint16_t id;
    uint16_t flags_fo;
    uint8_t ttl;
    ProtocolNumber protocol;
    uint16_t checksum;
    uint32_t src_addr;
    uint32_t dest_addr;
};
static_assert(sizeof(IpHeader) == 20);