#include "format.hpp"

#include "logger/logger.hpp"

std::string Format(const OrderUpdate& msg)
{
    return fmt::format("OrderUpdate\n"
                       "{{\n"
                       "    md_entry_id      {},\n"
                       "    md_entry_px      {},\n"
                       "    md_entry_size    {},\n"
                       "    md_flags         {},\n"
                       "    security_id      {},\n"
                       "    rtp_seq          {},\n"
                       "    md_update_action {},\n"
                       "    md_entry_type    {}\n"
                       "}}",
                       msg.md_entry_id,
                       float(msg.md_entry_px.mantissa*msg.md_entry_px.exponent),
                       msg.md_entry_size,
                       uint64_t(msg.md_flags),
                       msg.security_id,
                       msg.rtp_seq,
                       uint8_t(msg.md_update_action),
                       char(msg.md_entry_type));
}

std::string Format(const OrderExecution& msg)
{
    return fmt::format("OrderExecution\n"
                       "{{\n"
                       "    md_entry_id      {},\n"
                       "    md_entry_px      {},\n"
                       "    md_entry_size    {},\n"
                       "    last_px          {},\n"
                       "    last_qty         {},\n"
                       "    trade_id         {},\n"
                       "    md_flags         {},\n"
                       "    security_id      {},\n"
                       "    rtp_seq          {},\n"
                       "    md_update_action {},\n"
                       "    md_entry_type    {}\n"
                       "}}",
                       msg.md_entry_id,
                       float(msg.md_entry_px.mantissa*msg.md_entry_px.exponent),
                       msg.md_entry_size,
                       float(msg.last_px.mantissa*msg.last_px.exponent),
                       msg.last_qty,
                       msg.trade_id,
                       uint64_t(msg.md_flags),
                       msg.security_id,
                       msg.rtp_seq,
                       uint8_t(msg.md_update_action),
                       char(msg.md_entry_type));
}

std::string Format(const OrderBookSnapshot& msg)
{
    return fmt::format("OrderBookSnapshot\n"
                       "{{\n"
                       "    security_id                 {},\n"
                       "    last_msg_seq_num_processed  {},\n"
                       "    rtp_seq                     {},\n"
                       "    exchange_trading_session_id {},\n"
                       "    no_md_entries.num_in_group  {}\n"
                       "}}",
                       msg.security_id,
                       msg.last_msg_seq_num_processed,
                       msg.rtp_seq,
                       msg.exchange_trading_session_id,
                       msg.no_md_entries.num_in_group);
}

std::string Format(const OrderBookSnapshot::Entry& msg)
{
    return fmt::format("OrderBookSnapshotEntry\n"
                    "{{\n"
                    "    md_entry_id   {},\n"
                    "    transact_time {},\n"
                    "    md_entry_px   {},\n"
                    "    md_entry_size {},\n"
                    "    trade_id      {},\n"
                    "    md_flags      {},\n"
                    "    md_entry_type {}\n"
                    "}}",
                    msg.md_entry_id,
                    msg.transact_time,
                    float(msg.md_entry_px.mantissa*msg.md_entry_px.exponent),
                    msg.md_entry_size,
                    msg.trade_id,
                    uint64_t(msg.md_flags),
                    char(msg.md_entry_type));
}