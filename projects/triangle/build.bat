@setlocal

set BUILD_FODLER="out/build/N-Gage"

rd /s /q %BUILD_FODLER%

cmake -G"Unix Makefiles" -Wno-dev -DCMAKE_MAKE_PROGRAM="c:\Program Files (x86)\GnuWin32\bin\make.exe" -DCMAKE_TOOLCHAIN_FILE="%NGAGESDK%\cmake\ngage-toolchain.cmake" -B %BUILD_FODLER%

cmake --build %BUILD_FODLER% --target launcher
cmake --build %BUILD_FODLER% --target launcher_app_target
cmake --build %BUILD_FODLER% --target launcher.rsc
cmake --build %BUILD_FODLER% --target launcher.aif
cmake --build %BUILD_FODLER% --target triangle
cmake --build %BUILD_FODLER% --target launcher.sis
