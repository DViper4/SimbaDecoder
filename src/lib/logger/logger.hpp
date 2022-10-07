#pragma once

#include <spdlog/spdlog.h>

namespace ksp::log
{

inline void Debug(const std::string& msg)
{
    spdlog::debug(msg);
}

template <typename... Args>
inline void Debug(const std::string& format, Args... args)
{
    spdlog::debug(format, args...);
}

inline void Info(const std::string& msg)
{
    spdlog::info(msg);
}

template <typename... Args>
inline void Info(const std::string& format, Args... args)
{
    spdlog::info(format, args...);
}

inline void Warn(const std::string& msg)
{
    spdlog::warn(msg);
}

template <typename... Args>
inline void Warn(const std::string& format, Args... args)
{
    spdlog::warn(format, args...);
}

inline void Error(const std::string& msg)
{
    spdlog::error(msg);
}

template <typename... Args>
inline void Error(const std::string& format, Args... args)
{
    spdlog::error(format, args...);
}

inline void Critical(const std::string& msg)
{
    spdlog::critical(msg);
}

template <typename... Args>
inline void Critical(const std::string& format, Args... args)
{
    spdlog::critical(format, args...);
}

}  // namespace ksp::log