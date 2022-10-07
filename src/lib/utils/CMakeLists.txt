ksp_add_library(utils)

find_package(Boost COMPONENTS system REQUIRED)
find_package(indicators REQUIRED)

get_filename_component(LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)

target_include_directories(utils PUBLIC ${Boost_INCLUDE_DIRS} ${LIB_DIR})
target_link_libraries(utils logger ${Boost_LIBRARIES} indicators::indicators)