### build instructions

```
cd "/d/github/devopsnextgenx/c3d"
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
./build/bin/Debug/unit_tests.exe
./build/bin/Debug/basic_example.exe
./build/bin/Debug/c3d.exe
```