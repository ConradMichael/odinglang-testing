echo "Building"

IF not exist "build" (
    mkdir "build"
)

@REM Windows Build
@REM odin build .
@REM move odinlang-testing.exe ./build/odinlang-testing.exe

@REM Mac Build
odin run . -extra-linker-flags="-L/opt/homebrew/opt/sdl2/lib -L/opt/homebrew/opt/sdl2_image/lib"
move odinlang-testing ./build/odinlang-testing

echo "Done"
