# Change the final lib filename.

cmake_language(DEFER CALL _set_sdl3_output_name)

function(_set_sdl3_output_name)
    if(TARGET SDL3-static)
        set(t SDL3-static)
    elseif(TARGET SDL3)
        set(t SDL3)
    else()
        return()
    endif()

    if(CMAKE_BUILD_TYPE_ORIGINAL STREQUAL "Debug")
        set_target_properties(${t} PROPERTIES OUTPUT_NAME "SDL3debug")
    else()
        set_target_properties(${t} PROPERTIES OUTPUT_NAME "SDL3")
    endif()
endfunction()