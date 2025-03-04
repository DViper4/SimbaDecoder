#pragma once

#include <cinttypes>


struct PcapGlobalHeader
{
    static constexpr uint32_t MAGIC_NUMBER_IDENTICAL = 0xa1b2c3d4;
    static constexpr uint32_t MAGIC_NUMBER_SWAPPED = 0xd4c3b2a1;

    uint32_t magic_number;  /* magic number */
    uint16_t version_major; /* major version number */
    uint16_t version_minor; /* minor version number */
    int32_t thiszone;       /* GMT to local correction */
    uint32_t sigfigs;       /* accuracy of timestamps */
    uint32_t snaplen;       /* max length of captured packets, in octets */
    uint32_t network;       /* data link type */
};
static_assert(sizeof(PcapGlobalHeader) == 24);

struct PcapPacketHeader
{
    uint32_t ts_sec;   /* timestamp seconds */
    uint32_t ts_usec;  /* timestamp microseconds */
    uint32_t incl_len; /* number of octets of packet saved in file */
    uint32_t orig_len; /* actual length of packet */
};
static_assert(sizeof(PcapPacketHeader) == 16);