#include "utils.hpp"

#include <boost/asio/ip/host_name.hpp>
#include <boost/date_time.hpp>

#include "logger/logger.hpp"

namespace ksp::utils
{

void Assert(bool expr)
{
    if (not expr)
    {
        ksp::log::Critical("Assert failed");
        abort();
    }
}

void Assert(bool expr, const std::string& err)
{
    if (not expr)
    {
        ksp::log::Critical("Assert failed: {}", err);
        abort();
    }
}

const char* GetEnvRequired(const std::string& name)
{
    const char* value = std::getenv(name.c_str());
    Assert(value != nullptr, fmt::format("Env is required: name=[{}]", name));
    return value;
}

const char* GetEnvWithDefault(const std::string& name, const char* def)
{
    const char* value = std::getenv(name.c_str());
    return value == nullptr ? def : value;
}

int GetEnvIntRequired(const std::string& name)
{
    const char* value = std::getenv(name.c_str());
    Assert(value != nullptr, fmt::format("Env is required: name=[{}]", name));
    return std::atoi(value);
}

int GetEnvIntWithDefault(const std::string& name, int def)
{
    const char* value = std::getenv(name.c_str());
    return value == nullptr ? def : std::atoi(value);
}

std::string GenerateUUID()
{
    boost::uuids::uuid uuid = boost::uuids::random_generator()();
    return boost::uuids::to_string(uuid);
}

std::string GetHostname()
{
    return boost::asio::ip::host_name();
}

int64_t TimestampFromDateString(const std::string& s)
{
    auto format = std::locale(std::locale::classic(), new boost::posix_time::time_input_facet("%Y-%m-%d"));

    boost::posix_time::ptime pt;
    std::istringstream is(s);
    is.imbue(format);
    is >> pt;

    boost::posix_time::ptime timet_start(boost::gregorian::date(1970, 1, 1));
    boost::posix_time::time_duration diff = pt - timet_start;

    return diff.ticks() / boost::posix_time::time_duration::rep_type::ticks_per_second;
}

indicators::ProgressBar ProgressBar(size_t size, const std::string& postfix_text)
{
    return indicators::ProgressBar
    {
        indicators::option::ShowElapsedTime{true},
        indicators::option::BarWidth{80},
        indicators::option::PostfixText{postfix_text},
        indicators::option::ForegroundColor{indicators::Color::white},
        indicators::option::FontStyles{std::vector<indicators::FontStyle>{indicators::FontStyle::bold}},
        indicators::option::MaxProgress{size}
    };
}

std::string ByteStringToCharString(const std::basic_string<std::byte>& byte_str)
{
    std::string char_str;
    char_str.resize(byte_str.size());
    std::transform(byte_str.begin(), byte_str.end(), char_str.begin(),
                   [] (std::byte c) { return char(c); });
    return char_str;
}

}  // namespace ksp::utils
