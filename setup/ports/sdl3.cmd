@setlocal

set BUILD_FODLER="build-ngage"

git clone https://github.com/libsdl-org/SDL.git --depth 1 --single-branch build/SDL3

cd build/SDL3

# Build libSDL3.a

rd /s /q %BUILD_FODLER% && mkdir %BUILD_FODLER%

cmake -G"Unix Makefiles" -Wno-dev ^
  -DCMAKE_MAKE_PROGRAM="c:\Program Files (x86)\GnuWin32\bin\make.exe" ^
  -DCMAKE_TOOLCHAIN_FILE=%NGAGESDK%/cmake/ngage-toolchain-sdl3.cmake ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DSDL_STATIC=ON ^
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
  -DSDL_TESTS=OFF -DSDL_TEST_LIBRARY=OFF -DSDL_INSTALL_TESTS=OFF ^
  -DCMAKE_INSTALL_PREFIX="%NGAGESDK%/sdk/extras" ^
  -B %BUILD_FODLER%
  
cmake --build %BUILD_FODLER% --config Release
cmake --install %BUILD_FODLER%

# Build libSDL3debug.a

rd /s /q %BUILD_FODLER% && mkdir %BUILD_FODLER%

cmake -G"Unix Makefiles" -Wno-dev ^
  -DCMAKE_MAKE_PROGRAM="c:\Program Files (x86)\GnuWin32\bin\make.exe" ^
  -DCMAKE_TOOLCHAIN_FILE=%NGAGESDK%/cmake/ngage-toolchain-sdl3.cmake ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DCMAKE_BUILD_TYPE=Debug ^
  -DSDL_STATIC=ON ^
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
  -DSDL_TESTS=OFF -DSDL_TEST_LIBRARY=OFF -DSDL_INSTALL_TESTS=OFF ^
  -DCMAKE_INSTALL_PREFIX="%NGAGESDK%/sdk/extras" ^
  -B %BUILD_FODLER%
  
cmake --build %BUILD_FODLER% --config Release
cmake --install %BUILD_FODLER%
