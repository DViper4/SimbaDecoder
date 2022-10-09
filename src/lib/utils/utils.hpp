#pragma once

#include "logger/logger.hpp"

#include <boost/uuid/uuid_generators.hpp>
#include <boost/uuid/uuid_io.hpp>
#include <indicators/block_progress_bar.hpp>
#include <indicators/progress_bar.hpp>

#include <string>

namespace ksp::utils
{

void Assert(bool expr);
void Assert(bool expr, const std::string& err);

const char* GetEnvRequired(const std::string& name);
const char* GetEnvWithDefault(const std::string& name, const char* def = "");

int GetEnvIntRequired(const std::string& name);
int GetEnvIntWithDefault(const std::string& name, int def = 0);

std::string GenerateUUID();

std::string GetHostname();

int64_t TimestampFromDateString(const std::string& s);

indicators::ProgressBar ProgressBar(size_t size, const std::string& postfix_text);

std::string ByteStringToCharString(const std::basic_string<std::byte>& byte_str);

template <typename F>
class Defer
{
   public:
    Defer(F f) : f(f) {}
    ~Defer()
    {
        try
        {
            f();
        }
        catch (const std::exception& e)
        {
            ksp::log::Error("Defer failed", e.what());
        }
    }

   private:
    F f;
};

class ByteArrayReader
{
   public:
    ByteArrayReader(const std::vector<uint8_t>& data) : data_ref(data), data_cur(data_ref.cbegin()) {}
    ~ByteArrayReader() = default;

   public:
    template <typename T>
    T ReadAs()
    {
        T val;

        // memcpy is done to prevent potential aliasing problems,
        // compiler may optimize that memcpy away though,
        // and just do the same thing as reinterpret_cast would do
        std:memcpy(&val, &*data_cur, sizeof(T));
        Skip(sizeof(T));

        return val;
    }

    void Skip(size_t n)
    {
        std::advance(data_cur, n);
        ksp::utils::Assert(std::distance(data_cur, data_ref.cend()) >= 0);
    }

    bool More() const
    {
        return data_cur != data_ref.cend();
    }

   private:
    const std::vector<uint8_t>& data_ref;
    std::vector<uint8_t>::const_iterator data_cur;
};

}  // namespace ksp::utils