#pragma once

#include "types.hpp"

#include "logger/logger.hpp"
#include "utils/utils.hpp"

class SimbaDecoder
{
   public:
    template <typename F>
    static void Decode(ksp::utils::ByteArrayReader& reader, F msg_processor)
    {
        auto mdph = reader.ReadAs<MarketDataPacketHeader>();
        ksp::log::Debug("{}, {}", mdph.sending_time, mdph.msg_seq_num);

        if (mdph.IsIncremental())
        {
            DecodeIncremental(reader, msg_processor);
        }
        else
        {
            DecodeSnapshot(reader, msg_processor);
        }

        return;
    }

   private:
    template <typename F>
    static void DecodeIncremental(ksp::utils::ByteArrayReader& reader, F msg_processor)
    {
        auto iph = reader.ReadAs<IncrementalPacketHeader>();
        ksp::log::Debug("DecodeIncremental {}", iph.transact_time);

        while (reader.HasMore())
        {
            auto sbeh = reader.ReadAs<SBEHeader>();
            ksp::log::Debug("DecodeIncremental {}, {}, {}, {}",
                            sbeh.schema_id, sbeh.template_id, sbeh.version, sbeh.block_length);
            
            switch (sbeh.template_id)
            {
                case OrderUpdate::TEMPLATE_ID:
                {
                    auto ou = reader.ReadAs<OrderUpdate>();
                    msg_processor(ou);
                    break;
                }
                case OrderExecution::TEMPLATE_ID:
                {
                    auto oe = reader.ReadAs<OrderExecution>();
                    msg_processor(oe);
                    break;
                }
                case BestPrices::TEMPLATE_ID:
                {
                    auto no_md_entries = reader.ReadAs<GroupSize>();
                    reader.Skip(no_md_entries.block_length * no_md_entries.num_in_group);
                    break;
                }
                default:
                {
                    ksp::log::Info("Skipping {}", sbeh.block_length);
                    reader.Skip(sbeh.block_length);
                    break;
                }
            }
        }
    }

    template <typename F>
    static void DecodeSnapshot(ksp::utils::ByteArrayReader& reader, F msg_processor)
    {
        auto sbeh = reader.ReadAs<SBEHeader>();
        ksp::log::Debug("DecodeSnapshot {}, {}, {}, {}",
                        sbeh.schema_id, sbeh.template_id, sbeh.version, sbeh.block_length);

        switch (sbeh.template_id)
        {
            case OrderBookSnapshot::TEMPLATE_ID:
            {
                auto obs = reader.ReadAs<OrderBookSnapshot>();
                msg_processor(obs);

                for (size_t i = 0; i < obs.no_md_entries.num_in_group; ++i)
                {
                    auto entry = reader.ReadAs<OrderBookSnapshot::Entry>();
                    msg_processor(entry);
                }

                break;
            }
            default:
            {
                break;
            }
        }
    }
};