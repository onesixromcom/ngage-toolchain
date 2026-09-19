cmake_minimum_required(VERSION 3.10)

project(triangle C CXX)

add_executable(triangle
  src/main.c
)

set(CMAKE_EXECUTABLE_SUFFIX     ".exe")
set(CMAKE_IMPORT_LIBRARY_SUFFIX ".lib")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
set(CMAKE_SHARED_MODULE_SUFFIX  ".dll")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".lib")

set(UID1 0x1000007a) # KExecutableImageUidValue, e32uid.h
set(UID2 0x100039ce) # KAppUidValue16, apadef.h
set(UID3     0x1000c37e) # triangle.exe UID
set(APP_UID  0x10005888) # launcher.app UID
set(APP_NAME "triangle")

set(GCC_COMN_DEFS -D__SYMBIAN32__ -D__GCC32__ -D__EPOC32__ -D__MARM__ -D__MARM_ARMI__)
set(GCC_MODE_DEFS -DNDEBUG -D_UNICODE)
set(GCC_DEFS      ${GCC_COMN_DEFS} ${GCC_MODE_DEFS})

set_property(TARGET triangle PROPERTY C_STANDARD 99)

target_link_libraries(triangle PRIVATE
  SDL3
  NRenderer
  3dtypes
  # cone
  libgcc
  libgcc_ngage
  mediaclientaudiostream
  charconv
  bitgdi
  euser
  estlib
  ws32
  hal
  fbscli
  efsrv
  # scdv
  gdi
)

target_compile_definitions(
  triangle
  PUBLIC
  __EXE__
  FUNCTION_NAME=__FUNCTION__
  STBI_NO_THREAD_LOCALS
  ${GCC_DEFS}
  UID1=${UID1}
  UID2=${UID2}
  UID3=${UID3})

target_link_options(game PRIVATE "SHELL:-s UID1=${UID1}") # KExecutableImageUidValue, e32uid.h
target_link_options(game PRIVATE "SHELL:-s UID2=${UID2}") # KAppUidValue16, apadef.h
target_link_options(game PRIVATE "SHELL:-s UID3=${UID3}") # triangle.exe UID

set(SRC_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(DATA_DIR     "${CMAKE_CURRENT_SOURCE_DIR}/data")
set(RES_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/res")

set(launcher_libs
  ${EPOC_LIB}/euser.lib
  ${EPOC_LIB}/apparc.lib
  ${EPOC_LIB}/cone.lib
  ${EPOC_LIB}/eikcore.lib
  ${EPOC_LIB}/avkon.lib)

set(launcher_sources
  "${SRC_DIR}/ngage.cpp"
  "${SRC_DIR}/ngage_application.cpp"
  "${SRC_DIR}/ngage_appui.cpp"
  "${SRC_DIR}/ngage_appview.cpp"
  "${SRC_DIR}/ngage_document.cpp")

add_library(launcher STATIC ${launcher_sources})

target_compile_definitions(
  launcher
  PUBLIC
  __DLL__
  APP_NAME=${APP_NAME}
  ${GCC_DEFS}
  UID1=${UID1}
  UID2=${UID2}
  UID3=${APP_UID})

target_compile_options(
  launcher
  PUBLIC
  -O3)

target_include_directories(
  launcher
  PUBLIC
  ${SRC_DIR})

build_dll(launcher launcher app ${UID1} ${UID2} ${APP_UID} "${launcher_libs}")
build_resource(${RES_DIR} launcher "")
build_aif(${RES_DIR} launcher ${APP_UID})
build_sis(${RES_DIR} launcher triangle_app)
