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

conan_message(STATUS "Conan: Using autogenerated Findspdlog.cmake")
set(spdlog_FOUND 1)
set(spdlog_VERSION "1.10.0")

find_package_handle_standard_args(spdlog REQUIRED_VARS
                                  spdlog_VERSION VERSION_VAR spdlog_VERSION)
mark_as_advanced(spdlog_FOUND spdlog_VERSION)

set(spdlog_COMPONENTS spdlog::spdlog)

if(spdlog_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${spdlog_FIND_COMPONENTS})
        list(FIND spdlog_COMPONENTS "spdlog::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'spdlog'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'spdlog'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(spdlog_INCLUDE_DIRS "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/include")
set(spdlog_INCLUDE_DIR "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/include")
set(spdlog_INCLUDES "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/include")
set(spdlog_RES_DIRS )
set(spdlog_DEFINITIONS "-DSPDLOG_FMT_EXTERNAL"
			"-DSPDLOG_COMPILED_LIB")
set(spdlog_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(spdlog_COMPILE_DEFINITIONS "SPDLOG_FMT_EXTERNAL"
			"SPDLOG_COMPILED_LIB")
set(spdlog_COMPILE_OPTIONS_LIST "" "")
set(spdlog_COMPILE_OPTIONS_C "")
set(spdlog_COMPILE_OPTIONS_CXX "")
set(spdlog_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(spdlog_LIBRARIES "") # Will be filled later
set(spdlog_LIBS "") # Same as spdlog_LIBRARIES
set(spdlog_SYSTEM_LIBS pthread)
set(spdlog_FRAMEWORK_DIRS )
set(spdlog_FRAMEWORKS )
set(spdlog_FRAMEWORKS_FOUND "") # Will be filled later
set(spdlog_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(spdlog_FRAMEWORKS_FOUND "${spdlog_FRAMEWORKS}" "${spdlog_FRAMEWORK_DIRS}")

mark_as_advanced(spdlog_INCLUDE_DIRS
                 spdlog_INCLUDE_DIR
                 spdlog_INCLUDES
                 spdlog_DEFINITIONS
                 spdlog_LINKER_FLAGS_LIST
                 spdlog_COMPILE_DEFINITIONS
                 spdlog_COMPILE_OPTIONS_LIST
                 spdlog_LIBRARIES
                 spdlog_LIBS
                 spdlog_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to spdlog_LIBS and spdlog_LIBRARY_LIST
set(spdlog_LIBRARY_LIST spdlog)
set(spdlog_LIB_DIRS "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_spdlog_DEPENDENCIES "${spdlog_FRAMEWORKS_FOUND} ${spdlog_SYSTEM_LIBS} fmt::fmt")

conan_package_library_targets("${spdlog_LIBRARY_LIST}"  # libraries
                              "${spdlog_LIB_DIRS}"      # package_libdir
                              "${_spdlog_DEPENDENCIES}"  # deps
                              spdlog_LIBRARIES            # out_libraries
                              spdlog_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "spdlog")                                      # package_name

set(spdlog_LIBS ${spdlog_LIBRARIES})

foreach(_FRAMEWORK ${spdlog_FRAMEWORKS_FOUND})
    list(APPEND spdlog_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND spdlog_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${spdlog_SYSTEM_LIBS})
    list(APPEND spdlog_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND spdlog_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(spdlog_LIBRARIES_TARGETS "${spdlog_LIBRARIES_TARGETS};fmt::fmt")
set(spdlog_LIBRARIES "${spdlog_LIBRARIES};fmt::fmt")

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})


########### COMPONENT spdlog VARIABLES #############################################

set(spdlog_spdlog_INCLUDE_DIRS "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/include")
set(spdlog_spdlog_INCLUDE_DIR "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/include")
set(spdlog_spdlog_INCLUDES "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/include")
set(spdlog_spdlog_LIB_DIRS "/home/oded/.conan/data/spdlog/1.10.0/_/_/package/ff0052ef32311f77d1f5378b4fcec36de434e6b3/lib")
set(spdlog_spdlog_RES_DIRS )
set(spdlog_spdlog_DEFINITIONS "-DSPDLOG_FMT_EXTERNAL"
			"-DSPDLOG_COMPILED_LIB")
set(spdlog_spdlog_COMPILE_DEFINITIONS "SPDLOG_FMT_EXTERNAL"
			"SPDLOG_COMPILED_LIB")
set(spdlog_spdlog_COMPILE_OPTIONS_C "")
set(spdlog_spdlog_COMPILE_OPTIONS_CXX "")
set(spdlog_spdlog_LIBS spdlog)
set(spdlog_spdlog_SYSTEM_LIBS pthread)
set(spdlog_spdlog_FRAMEWORK_DIRS )
set(spdlog_spdlog_FRAMEWORKS )
set(spdlog_spdlog_BUILD_MODULES_PATHS )
set(spdlog_spdlog_DEPENDENCIES fmt::fmt)
set(spdlog_spdlog_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)

if(NOT fmt_FOUND)
    find_dependency(fmt REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency fmt already found")
endif()


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT spdlog FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(spdlog_spdlog_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(spdlog_spdlog_FRAMEWORKS_FOUND "${spdlog_spdlog_FRAMEWORKS}" "${spdlog_spdlog_FRAMEWORK_DIRS}")

set(spdlog_spdlog_LIB_TARGETS "")
set(spdlog_spdlog_NOT_USED "")
set(spdlog_spdlog_LIBS_FRAMEWORKS_DEPS ${spdlog_spdlog_FRAMEWORKS_FOUND} ${spdlog_spdlog_SYSTEM_LIBS} ${spdlog_spdlog_DEPENDENCIES})
conan_package_library_targets("${spdlog_spdlog_LIBS}"
                              "${spdlog_spdlog_LIB_DIRS}"
                              "${spdlog_spdlog_LIBS_FRAMEWORKS_DEPS}"
                              spdlog_spdlog_NOT_USED
                              spdlog_spdlog_LIB_TARGETS
                              ""
                              "spdlog_spdlog")

set(spdlog_spdlog_LINK_LIBS ${spdlog_spdlog_LIB_TARGETS} ${spdlog_spdlog_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT spdlog TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET spdlog::spdlog)
        add_library(spdlog::spdlog INTERFACE IMPORTED)
        set_target_properties(spdlog::spdlog PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${spdlog_spdlog_INCLUDE_DIRS}")
        set_target_properties(spdlog::spdlog PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${spdlog_spdlog_LIB_DIRS}")
        set_target_properties(spdlog::spdlog PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${spdlog_spdlog_LINK_LIBS};${spdlog_spdlog_LINKER_FLAGS_LIST}")
        set_target_properties(spdlog::spdlog PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${spdlog_spdlog_COMPILE_DEFINITIONS}")
        set_target_properties(spdlog::spdlog PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${spdlog_spdlog_COMPILE_OPTIONS_C};${spdlog_spdlog_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET spdlog::spdlog)
        add_library(spdlog::spdlog INTERFACE IMPORTED)
    endif()
    set_property(TARGET spdlog::spdlog APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${spdlog_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT spdlog BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${spdlog_spdlog_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
