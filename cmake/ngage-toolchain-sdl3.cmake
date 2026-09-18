cmake_minimum_required(VERSION 3.19)

set(NGAGE 1)
set(NGAGESDK 1)

set(CMAKE_SYSTEM_NAME NGage)
set(CMAKE_SYSTEM_PROCESSOR ARMV4)

set(CMAKE_DISABLE_PRECOMPILE_HEADERS ON)

set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")

# Compiler is working by default in linux.
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_CXX_COMPILER_WORKS TRUE)

if(NOT DEFINED ENV{NGAGESDK})
  message(FATAL_ERROR "The environment variable NGAGESDK needs to be defined.")
endif()

file(TO_CMAKE_PATH "$ENV{NGAGESDK}" NGAGESDK)

set(SDK_ROOT ${NGAGESDK}/sdk)
set(S60_SDK_ROOT ${SDK_ROOT}/sdk/6.1)
set(EPOC_PLATFORM ${S60_SDK_ROOT}/Shared/EPOC32)
set(EPOC_LIB ${S60_SDK_ROOT}/Series60/Epoc32/Release/armi/urel)
set(EPOC_EXTRAS ${SDK_ROOT}/extras)

if(WIN32)
	set(CMAKE_C_COMPILER "${EPOC_PLATFORM}/ngagesdk/bin/arm-epoc-pe-gcc.exe")
	set(CMAKE_C_LINKER "${EPOC_PLATFORM}/gcc/bin/gcc.exe")
	set(CMAKE_CXX_COMPILER "${EPOC_PLATFORM}/gcc/bin/g++.exe")
	set(CMAKE_CXX_LINKER "${EPOC_PLATFORM}/gcc/bin/cpp.exe")

	set(CMAKE_OBJCOPY "${EPOC_PLATFORM}/gcc/bin/objcopy.exe")
	set(CMAKE_OBJDUMP "${EPOC_PLATFORM}/gcc/bin/objdump.exe")

	set(CMAKE_C_COMPILER_RANLIB "${EPOC_PLATFORM}/gcc/bin/ranlib.exe")
elseif(UNIX)
	set(CMAKE_C_COMPILER "${EPOC_PLATFORM}/ngagesdk/bin/arm-epoc-pe-gcc")
	set(CMAKE_C_LINKER "${EPOC_PLATFORM}/gcc/bin/arm-epoc-pe-gcc")
	set(CMAKE_CXX_COMPILER "${EPOC_PLATFORM}/gcc/bin/arm-epoc-pe-g++")
	set(CMAKE_CXX_LINKER "${EPOC_PLATFORM}/gcc/bin/arm-epoc-pe-cpp")

	set(CMAKE_OBJCOPY "${EPOC_PLATFORM}/gcc/bin/arm-epoc-pe-objcopy")
	set(CMAKE_OBJDUMP "${EPOC_PLATFORM}/gcc/bin/arm-epoc-pe-objdump")

	set(CMAKE_C_COMPILER_RANLIB "${EPOC_PLATFORM}/gcc/bin/arm-epoc-pe-ranlib")
endif()

# file log enabled by default. TODO: fix debug builds.
set(NGAGE_CPPFLAGS "-DFUNCTION_NAME=__FUNCTION__ -D__NGAGE__=1 -D__SYMBIAN32__ -D__GCC32__ -D__EPOC32__  -D__MARM__ -D__MARM_ARMI__ -D_UNICODE -DENABLE_FILE_LOG" )
# Use file log for Debug build.
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(NGAGE_CPPFLAGS "${NGAGE_CPPFLAGS} -DENABLE_FILE_LOG")
endif()

set(NGAGE_CPPFLAGS "${NGAGE_CPPFLAGS} -I ${EPOC_PLATFORM}/include -I ${EPOC_EXTRAS}/include -I ${S60_SDK_ROOT}/Series60/Epoc32/Include -I ${S60_SDK_ROOT}/Series60/Epoc32/Include/libc -I ${S60_SDK_ROOT}/Shared/EPOC32/ngagesdk/include -I ${S60_SDK_ROOT}/Shared/EPOC32/ngagesdk/lib/gcc/arm-epoc-pe/4.6.4/include")

set(NGAGE_NO_ERRORS "-Wno-shadow -Wno-implicit-function-declaration")

if(WIN32)
	set(NGAGE_CFLAGS "${NGAGE_CPPFLAGS} -fno-leading-underscore -std=gnu99 -s -mthumb-interwork")
	# Fix incorrect "as" program selector.
	set(NGAGE_CFLAGS "${NGAGE_CFLAGS} -B ${EPOC_PLATFORM}/gcc/bin")

	# Disable pic to pass test compilation.
	add_compile_options(-fno-pic)
elseif(UNIX)
	set(NGAGE_CFLAGS "${NGAGE_CPPFLAGS} -fno-leading-underscore -std=gnu99 -s -mthumb-interwork -Dssize_t=long -DSIZE_MAX=0xFFFFFFFFU")
	
	# Fix incorrect "as" program selector.
	set(NGAGE_CFLAGS "${NGAGE_CFLAGS} -B ${EPOC_PLATFORM}/gcc/arm-epoc-pe/bin")
endif()

set(NGAGE_CPPFLAGS "${NGAGE_CPPFLAGS} -D__FLT_EPSILON__=1.19209290e-7F -fomit-frame-pointer -O2 -mthumb-interwork")

set(CMAKE_C_FLAGS_INIT "${NGAGE_CFLAGS} ${NGAGE_NO_ERRORS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_INIT "${NGAGE_CPPFLAGS} ${NGAGE_NO_ERRORS}" CACHE STRING "" FORCE)

if (NGAGE_LEGACY)
  set(CMAKE_C_COMPILER_ID_RUN TRUE)
  set(CMAKE_C_COMPILER_FORCED TRUE)
  set(CMAKE_C_COMPILER_WORKS TRUE)
endif()

set(CMAKE_CXX_COMPILER_ID_RUN TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_WORKS TRUE)

# fix Fatal error: Symbol L2 already defined for ld.
set(EPOC32_BIN
    "/usr/local/ngagedev/sdk/6.1/Shared/EPOC32/gcc/arm-epoc-pe/bin"
)
