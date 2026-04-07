# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    CmakeLists.txt                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/07 15:24:49 by abelov            #+#    #+#              #
#    Updated: 2026/04/07 15:24:49 by abelov           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

cmake_minimum_required(VERSION 3.12)

#set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER gcc)

set(CMAKE_ASM_NASM_SOURCE_FILE_EXTENSIONS "asm;nasm;s")

set(CMAKE_C_STANDARD 99)
include_directories(include)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project("libasm" VERSION 0.1.0 LANGUAGES C ASM ASM_NASM)

set(FT_CFLAGS -Wall -Wextra -Werror)

set(PROJECT_CFLAGS
        -Og
        -g3
        -Wa,-L
        -fno-tree-vectorize
        -fno-builtin-memcpy
        -fno-builtin-memmove
        -fno-unroll-loops
        -fcf-protection=none
        -fno-stack-protector
        -fno-verbose-asm
        -fno-omit-frame-pointer
)

IF(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    LIST(APPEND PROJECT_CFLAGS
            -fno-thread-jumps
            -fno-reorder-blocks
            -fno-reorder-blocks-and-partition
            -fif-conversion
            -fif-conversion2
            -mmanual-endbr
            -mno-red-zone
            -minline-all-stringops
            -mstringop-strategy=libcall
            -mmemcpy-strategy=loop:0:align,libcall:-1:align
    )
ENDIF()


set(NASM_FLAGS -f elf64 -g -F dwarf -w+all -w-reloc-rel-dword)

set(TARGET_CFLAGS ${PROJECT_CFLAGS})
set(TARGET_ASM_FLAGS ${NASM_FLAGS})

set(TARGET_LIBSOURCES)
file(GLOB TARGET_LIB_HEADERS "${PROJECT_SOURCE_DIR}/src/*.h")

file(GLOB TARGET_LIB_ASM_SOURCES "${PROJECT_SOURCE_DIR}/src/*.s")
foreach(X IN ITEMS ${TARGET_LIB_ASM_SOURCES})
    set_source_files_properties(${X} PROPERTIES LANGUAGE ASM_NASM)
endforeach()

file(GLOB TARGET_LIB_C_SOURCES "${PROJECT_SOURCE_DIR}/src/*.c")

list(APPEND TARGET_LIB_SOURCES "${TARGET_LIB_ASM_SOURCES};${TARGET_LIB_C_SOURCES}")

#Generate static library from sources
set(TARGET_LIB_NAME "${PROJECT_NAME}")
add_library(${TARGET_LIB_NAME} STATIC ${TARGET_LIB_HEADERS} ${TARGET_LIB_SOURCES})

target_include_directories(${TARGET_LIB_NAME} PRIVATE include)
target_compile_options(${TARGET_LIB_NAME}
        PUBLIC
        ${FT_CFLAGS}
        PRIVATE
        $<$<COMPILE_LANGUAGE:ASM_NASM>:
        ${TARGET_ASM_FLAGS}>
        $<$<COMPILE_LANGUAGE:C>:
        ${TARGET_CFLAGS}>)

file(GLOB_RECURSE TEST_TARGET_HEADERS "${PROJECT_SOURCE_DIR}/tests/*.h")
file(GLOB_RECURSE TEST_TARGET_SOURCES "${PROJECT_SOURCE_DIR}/tests/*.c")

set(TEST_TARGET_NAME "${PROJECT_NAME}_test")

set(TEST_TARGET_CFLAGS
        -MMD
        ${PROJECT_CFLAGS}
)

add_executable(${TEST_TARGET_NAME}
        ${TEST_TARGET_HEADERS}
        ${TEST_TARGET_SOURCES})

target_include_directories(${TEST_TARGET_NAME} PRIVATE
        /usr/include
        /usr/include/x86_64-linux-gnu
        ${PROJECT_SOURCE_DIR}/src
)

target_compile_options(${TEST_TARGET_NAME}
        PUBLIC
        ${FT_CFLAGS}
        PRIVATE
        $<$<COMPILE_LANGUAGE:ASM_NASM>:
        ${TEST_TARGET_ASM_FLAGS}>
        $<$<COMPILE_LANGUAGE:C>:
        ${TEST_TARGET_CFLAGS}>
)

target_link_libraries(${TEST_TARGET_NAME} bsd ${TARGET_LIB_NAME})

set_target_properties(${TEST_TARGET_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}"
        OUTPUT_NAME "${TEST_TARGET_NAME}")

#==============================================================================#
# Custom targets
#==============================================================================#
add_custom_target(fclean
        COMMAND make -C ${PROJECT_SOURCE_DIR} fclean)

add_custom_target(re
        COMMAND make -C ${PROJECT_SOURCE_DIR} re)
