#pragma once

#include <cinttypes>
#include <string>

class EthernetHeader
{
   public:
    using MacAddress = uint8_t[6];

    enum PayloadType : uint16_t
    {
        IP = 0x0800,
        VLAN = 0x8100
    };

   public:
    std::string DestAddr() const;
    std::string SrcAddr() const;
    PayloadType Type() const;

   private:
    MacAddress dest_addr;
    MacAddress src_addr;
    uint16_t type;
};
static_assert(sizeof(EthernetHeader) == 14);