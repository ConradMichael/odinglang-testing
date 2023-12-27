echo "Building"

IF not exist "build" (
    mkdir "build"
)

odin build .
move odintesting.exe ./build/odintesting.exe

echo "Done"
