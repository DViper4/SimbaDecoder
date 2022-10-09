#pragma once

#include "types.hpp"

#include <string>

std::string Format(const OrderUpdate& msg);

std::string Format(const OrderExecution& msg);

std::string Format(const OrderBookSnapshot& msg);

std::string Format(const OrderBookSnapshot::Entry& msg);