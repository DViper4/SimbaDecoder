########## MACROS ###########################################################################
#############################################################################################

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAMES ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


########### FOUND PACKAGE ###################################################################
#############################################################################################

include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findfmt.cmake")
set(fmt_FOUND 1)
set(fmt_VERSION "8.1.1")

find_package_handle_standard_args(fmt REQUIRED_VARS
                                  fmt_VERSION VERSION_VAR fmt_VERSION)
mark_as_advanced(fmt_FOUND fmt_VERSION)

set(fmt_COMPONENTS fmt::fmt)

if(fmt_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${fmt_FIND_COMPONENTS})
        list(FIND fmt_COMPONENTS "fmt::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'fmt'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'fmt'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(fmt_INCLUDE_DIRS "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/include")
set(fmt_INCLUDE_DIR "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/include")
set(fmt_INCLUDES "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/include")
set(fmt_RES_DIRS )
set(fmt_DEFINITIONS )
set(fmt_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(fmt_COMPILE_DEFINITIONS )
set(fmt_COMPILE_OPTIONS_LIST "" "")
set(fmt_COMPILE_OPTIONS_C "")
set(fmt_COMPILE_OPTIONS_CXX "")
set(fmt_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(fmt_LIBRARIES "") # Will be filled later
set(fmt_LIBS "") # Same as fmt_LIBRARIES
set(fmt_SYSTEM_LIBS m)
set(fmt_FRAMEWORK_DIRS )
set(fmt_FRAMEWORKS )
set(fmt_FRAMEWORKS_FOUND "") # Will be filled later
set(fmt_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(fmt_FRAMEWORKS_FOUND "${fmt_FRAMEWORKS}" "${fmt_FRAMEWORK_DIRS}")

mark_as_advanced(fmt_INCLUDE_DIRS
                 fmt_INCLUDE_DIR
                 fmt_INCLUDES
                 fmt_DEFINITIONS
                 fmt_LINKER_FLAGS_LIST
                 fmt_COMPILE_DEFINITIONS
                 fmt_COMPILE_OPTIONS_LIST
                 fmt_LIBRARIES
                 fmt_LIBS
                 fmt_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to fmt_LIBS and fmt_LIBRARY_LIST
set(fmt_LIBRARY_LIST fmt)
set(fmt_LIB_DIRS "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_fmt_DEPENDENCIES "${fmt_FRAMEWORKS_FOUND} ${fmt_SYSTEM_LIBS} ")

conan_package_library_targets("${fmt_LIBRARY_LIST}"  # libraries
                              "${fmt_LIB_DIRS}"      # package_libdir
                              "${_fmt_DEPENDENCIES}"  # deps
                              fmt_LIBRARIES            # out_libraries
                              fmt_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "fmt")                                      # package_name

set(fmt_LIBS ${fmt_LIBRARIES})

foreach(_FRAMEWORK ${fmt_FRAMEWORKS_FOUND})
    list(APPEND fmt_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND fmt_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${fmt_SYSTEM_LIBS})
    list(APPEND fmt_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND fmt_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(fmt_LIBRARIES_TARGETS "${fmt_LIBRARIES_TARGETS};")
set(fmt_LIBRARIES "${fmt_LIBRARIES};")

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})


########### COMPONENT fmt VARIABLES #############################################

set(fmt_fmt_INCLUDE_DIRS "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/include")
set(fmt_fmt_INCLUDE_DIR "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/include")
set(fmt_fmt_INCLUDES "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/include")
set(fmt_fmt_LIB_DIRS "/home/oded/.conan/data/fmt/8.1.1/_/_/package/bb317a1f4f7069078e967719a5c585f83cd078c2/lib")
set(fmt_fmt_RES_DIRS )
set(fmt_fmt_DEFINITIONS )
set(fmt_fmt_COMPILE_DEFINITIONS )
set(fmt_fmt_COMPILE_OPTIONS_C "")
set(fmt_fmt_COMPILE_OPTIONS_CXX "")
set(fmt_fmt_LIBS fmt)
set(fmt_fmt_SYSTEM_LIBS m)
set(fmt_fmt_FRAMEWORK_DIRS )
set(fmt_fmt_FRAMEWORKS )
set(fmt_fmt_BUILD_MODULES_PATHS )
set(fmt_fmt_DEPENDENCIES )
set(fmt_fmt_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT fmt FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(fmt_fmt_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(fmt_fmt_FRAMEWORKS_FOUND "${fmt_fmt_FRAMEWORKS}" "${fmt_fmt_FRAMEWORK_DIRS}")

set(fmt_fmt_LIB_TARGETS "")
set(fmt_fmt_NOT_USED "")
set(fmt_fmt_LIBS_FRAMEWORKS_DEPS ${fmt_fmt_FRAMEWORKS_FOUND} ${fmt_fmt_SYSTEM_LIBS} ${fmt_fmt_DEPENDENCIES})
conan_package_library_targets("${fmt_fmt_LIBS}"
                              "${fmt_fmt_LIB_DIRS}"
                              "${fmt_fmt_LIBS_FRAMEWORKS_DEPS}"
                              fmt_fmt_NOT_USED
                              fmt_fmt_LIB_TARGETS
                              ""
                              "fmt_fmt")

set(fmt_fmt_LINK_LIBS ${fmt_fmt_LIB_TARGETS} ${fmt_fmt_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT fmt TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET fmt::fmt)
        add_library(fmt::fmt INTERFACE IMPORTED)
        set_target_properties(fmt::fmt PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${fmt_fmt_INCLUDE_DIRS}")
        set_target_properties(fmt::fmt PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${fmt_fmt_LIB_DIRS}")
        set_target_properties(fmt::fmt PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${fmt_fmt_LINK_LIBS};${fmt_fmt_LINKER_FLAGS_LIST}")
        set_target_properties(fmt::fmt PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${fmt_fmt_COMPILE_DEFINITIONS}")
        set_target_properties(fmt::fmt PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${fmt_fmt_COMPILE_OPTIONS_C};${fmt_fmt_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET fmt::fmt)
        add_library(fmt::fmt INTERFACE IMPORTED)
    endif()
    set_property(TARGET fmt::fmt APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${fmt_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT fmt BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${fmt_fmt_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
