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

}  // namespace ksp::utils