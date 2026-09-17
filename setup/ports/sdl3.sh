#!/bin/bash

git clone https://github.com/libsdl-org/SDL.git --depth 1 --single-branch build/SDL3

cd build/SDL3

rm -rf build-ngage/ && mkdir build-ngage

cmake -G"Unix Makefiles" -Wno-dev \
  -DCMAKE_TOOLCHAIN_FILE="$NGAGESDK/cmake/ngage-toolchain-sdl3.cmake" \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DSDL_STATIC=ON \
  -DCMAKE_POSITION_INDEPENDENT_CODE=OFF \
  -DSDL_TESTS=OFF -DSDL_TEST_LIBRARY=OFF -DSDL_INSTALL_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX="$NGAGESDK/sdk/extras" \
  -B build-ngage
  
cmake --build build-ngage --config Release
cmake --install build-ngage