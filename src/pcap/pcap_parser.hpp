#pragma once

#include "types.hpp"

#include <fstream>
#include <optional>
#include <string>
#include <vector>

class PcapParser
{
   public:
    struct Packet
    {
        PcapPacketHeader header;
        std::vector<uint8_t> data;
    };

   public:
    PcapParser(const std::string& filename);
    ~PcapParser() = default;

   public:
    std::optional<Packet*> Next();

   private:
    void ParseGlobalHeader();

   private:
    std::ifstream ifs;
    Packet packet;
};