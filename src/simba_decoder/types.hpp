#pragma once

#include <cinttypes>

#pragma pack(1)

struct Decimal5
{
    int64_t mantissa;
    static constexpr double exponent = 1e-5;
};

struct Decimal5NULL
{
    // static constexpr int64_t MIN_VALUE = -9223372036854775808;
    static constexpr int64_t MAX_VALUE = 9223372036854775806;
    static constexpr int64_t NULL_VALUE = 9223372036854775807;

    int64_t mantissa;
    static constexpr double exponent = 1e-5;
};

enum class MsgFlagsSet : uint16_t
{
    LastFragment = 0x1,
    StartOfSnapshot = 0x2,
    EndOfSnapshot = 0x4,
    IncrementalPacket = 0x8,
    PossDupFlag = 0x10
};

struct MarketDataPacketHeader
{
    bool IsIncremental() const { return msg_flags & 0x8; }

    uint32_t msg_seq_num;
    uint16_t msg_size;
    uint16_t msg_flags;
    uint64_t sending_time;
};
static_assert(sizeof(MarketDataPacketHeader) == 16);

struct IncrementalPacketHeader
{
    static constexpr uint32_t EXCHANGE_TRADING_SESSION_ID_NULL = 4294967295;

    uint64_t transact_time;
    uint32_t exchange_trading_session_id;
};
static_assert(sizeof(IncrementalPacketHeader) == 12);

struct SBEHeader
{
    uint16_t block_length;
    uint16_t template_id;
    uint16_t schema_id;
    uint16_t version;
};
static_assert(sizeof(SBEHeader) == 8);

enum class MDFlagsSet : uint64_t
{
    Day = 0x1,
    IOC = 0x2,
    NonQuote = 0x4,
    EndOfTransaction = 0x1000,
    SecondLeg = 0x4000,
    FOK = 0x80000,
    Replace = 0x100000,
    Cancel = 0x200000,
    MassCancel = 0x400000,
    Negotiated = 0x4000000,
    MultiLeg = 0x8000000,
    CrossTrade = 0x20000000,
    COD = 0x100000000,
    ActiveSide = 0x20000000000,
    PassiveSide = 0x40000000000,
    Synthetic = 0x200000000000,
    RFS = 0x400000000000,
    SyntheticPassive = 0x200000000000000,
};

enum class MDUpdateAction : uint8_t
{
    New = 0,
    Change = 1,
    Delete = 2,
};

enum class MDEntryType : char
{
    Bid = '0',
    Offer = '1',
    EmptyBook = 'J',
};

struct OrderUpdate
{
    static constexpr uint16_t TEMPLATE_ID = 5;

    int64_t md_entry_id;
    Decimal5 md_entry_px;
    int64_t md_entry_size;
    MDFlagsSet md_flags;
    int32_t security_id;
    uint32_t rtp_seq;
    MDUpdateAction md_update_action;
    MDEntryType md_entry_type;
};
static_assert(sizeof(OrderUpdate) == 42);

struct OrderExecution
{
    static constexpr uint16_t TEMPLATE_ID = 6;

    int64_t md_entry_id;
    Decimal5NULL md_entry_px;
    int64_t md_entry_size;
    Decimal5 last_px;
    int64_t last_qty;
    int64_t trade_id;
    uint64_t md_flags;
    int32_t security_id;
    uint32_t rtp_seq;
    MDUpdateAction md_update_action;
    MDEntryType md_entry_type;
};

#pragma pack(0)