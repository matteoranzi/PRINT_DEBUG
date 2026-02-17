include_guard(DIRECTORY)

if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColourReset "${Esc}[0;m")
    set(ColourBold  "${Esc}[0;1m")
    set(Red         "${Esc}[0;31m")
    set(Green       "${Esc}[0;32m")
    set(Yellow      "${Esc}[0;33m")
    set(Blue        "${Esc}[0;34m")
    set(Magenta     "${Esc}[0;35m")
    set(Cyan        "${Esc}[0;36m")
    set(White       "${Esc}[0;39m")
    set(BoldRed     "${Esc}[1;31m")
    set(BoldGreen   "${Esc}[1;32m")
    set(BoldYellow  "${Esc}[1;33m")
    set(BoldBlue    "${Esc}[1;34m")
    set(BoldMagenta "${Esc}[1;35m")
    set(BoldCyan    "${Esc}[1;36m")
    set(BoldWhite   "${Esc}[1;38m")
else()
    set(ColourReset "")
    set(ColourBold  "")
    set(Red         "")
    set(Green       "")
    set(Yellow      "")
    set(Blue        "")
    set(Magenta     "")
    set(Cyan        "")
    set(White       "")
    set(BoldRed     "")
    set(BoldGreen   "")
    set(BoldYellow  "")
    set(BoldBlue    "")
    set(BoldMagenta "")
    set(BoldCyan    "")
    set(BoldWhite   "")
endif()


function(colored_message color message)
    message("${color}${message}${ColourReset}")
endfunction()


add_library(print_debug INTERFACE)

target_include_directories(print_debug INTERFACE ${CMAKE_SOURCE_DIR}/include)

#[[
 Available log levels - set PRINT_DEBUG_LEVEL to one of:
    PRINT_DEBUG_LEVEL_NONE   → disable all logs
    PRINT_DEBUG_LEVEL_ERROR  → show only errors
    PRINT_DEBUG_LEVEL_WARN   → show warnings and errors
    PRINT_DEBUG_LEVEL_INFO   → show info, warnings, and errors
]]
set(PRINT_DEBUG_LEVEL_NONE  0)
set(PRINT_DEBUG_LEVEL_ERROR 1)
set(PRINT_DEBUG_LEVEL_WARN  2)
set(PRINT_DEBUG_LEVEL_INFO  3)



#------------- CUSTOM PRINT DEBUG LEVELS (for console print) -----------------
function(define_print_debug_level_for_target target release_build_level debug_build_level)
    target_compile_definitions(${target} PRIVATE
        $<$<CONFIG:Release>:PRINT_DEBUG_LEVEL=${release_build_level}>
        $<$<CONFIG:Debug>:PRINT_DEBUG_LEVEL=${debug_build_level}>
    )

    show_print_debug_level_for_target(${target} ${release_build_level} ${debug_build_level})
endfunction()

function(show_print_debug_level_for_target target release_level debug_level)
    get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

    if (isMultiConfig)
        set(configs Release Debug)
    else()
        set(configs ${CMAKE_BUILD_TYPE})
    endif()

    foreach(conf IN ITEMS ${configs})
        if(conf STREQUAL Release)
            set(level "${release_level}")
            set(color ${Green})
        elseif(conf STREQUAL Debug)
            set(level "${debug_level}")
            set(color ${BoldMagenta})
        else()
            message(FATAL_ERROR "[print_debug] Unknown build configuration: ${conf}")
        endif()

        set(_level_name "")
        if(${level} EQUAL PRINT_DEBUG_LEVEL_NONE)
            set(_level_name "${_level_name}|NONE")
        endif()
        if(${level} GREATER_EQUAL PRINT_DEBUG_LEVEL_ERROR)
            set(_level_name "${_level_name}|ERROR")
        endif()
        if(${level} GREATER_EQUAL PRINT_DEBUG_LEVEL_WARN)
            set(_level_name "${_level_name}|WARN")
        endif()
        if(${level} EQUAL PRINT_DEBUG_LEVEL_INFO)
            set(_level_name "${_level_name}|INFO")
        endif()
        set(_level_name "${_level_name}|")

        colored_message("${color}" "[print_debug] Module [${target}] >>> ${conf} PRINT_DEBUG_LEVEL: (${_level_name})")
    endforeach()
endfunction()



#================================================================================================
# Global debug levels that can be used as a reference for modules
set(RELEASE_PRINT_DEBUG_LEVEL ${PRINT_DEBUG_LEVEL_ERROR} CACHE STRING "Global debug level for all modules in release builds")
set(DEBUG_PRINT_DEBUG_LEVEL ${PRINT_DEBUG_LEVEL_INFO} CACHE STRING "Global debug level for all modules in debug builds")
#================================================================================================