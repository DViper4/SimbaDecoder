function(debug_vars)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()

function(ksp_add_executable EXE_NAME)
    file(GLOB EXE_SOURCES
        "*.hpp"
        "*.cpp"
    )
    add_executable(${EXE_NAME} ${EXE_SOURCES})
    set_target_properties(${EXE_NAME} PROPERTIES LINKER_LANGUAGE CXX)
endfunction()


function(ksp_add_library LIB_NAME)
    file(GLOB LIB_SOURCES
        "*.hpp"
        "*.cpp"
    )
    add_library(${LIB_NAME} ${LIB_SOURCES})
    set_target_properties(${LIB_NAME} PROPERTIES LINKER_LANGUAGE CXX)
endfunction()


macro(ksp_conan_setup)
    # Download automatically, you can also just copy the conan.cmake file
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
        message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
        file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
                      "${CMAKE_BINARY_DIR}/conan.cmake")
    endif()

    include(${CMAKE_BINARY_DIR}/conan.cmake)
endmacro()

macro(ksp_conan_run)
    conan_cmake_run(CONANFILE conanfile.txt
                    BASIC_SETUP CMAKE_TARGETS
                    BUILD missing)

    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
endmacro()