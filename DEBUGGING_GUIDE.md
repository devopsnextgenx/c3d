# Linux Debugging Guide - C3D Project

## Overview

On Linux, debugging symbols are generated in **DWARF format** (not PDB files). This guide shows how to effectively debug C3D applications on Linux.

## ✅ Debug Symbols Available

The C3D project now generates **enhanced debug symbols** with the following features:

- **Format**: DWARF-4 (Linux standard)
- **Level**: `-g3` (maximum debug information)
- **Optimization**: `-O0` (no optimization for debugging)
- **Frame pointers**: Preserved for better stack traces
- **Stack protection**: Enabled for runtime error detection

## Debug Build Configuration

### Enhanced Debug Flags
```cmake
CMAKE_CXX_FLAGS_DEBUG = "-g3 -gdwarf-4 -O0 -fno-omit-frame-pointer -fstack-protector-all"
```

### What Each Flag Does:
- **`-g3`**: Maximum debug information (includes macros)
- **`-gdwarf-4`**: Use DWARF-4 debug format
- **`-O0`**: No optimization (preserves variable values)
- **`-fno-omit-frame-pointer`**: Keep frame pointers for better backtraces
- **`-fstack-protector-all`**: Runtime stack overflow detection

## Quick Start Debugging

### 1. Build Debug Configuration
```bash
./scripts/build-debug.sh
```

### 2. Generate Separate Debug Symbols (Optional)
```bash
./scripts/generate-debug-symbols.sh
```

### 3. Debug with GDB
```bash
cd build/debug
gdb ./bin/Debug/c3d
```

### 4. Debug with VS Code
- Open VS Code in project root
- Press F5 or go to Run → Start Debugging
- Select "Debug C3D (GDB)" configuration

## Debugging Methods

### Method 1: Command Line GDB

#### Basic GDB Session
```bash
cd build/debug
gdb ./bin/Debug/c3d

# GDB commands:
(gdb) break main           # Set breakpoint at main
(gdb) run                  # Start program
(gdb) step                 # Step through code
(gdb) print variable_name  # Print variable value
(gdb) backtrace           # Show call stack
(gdb) list                # Show source code
(gdb) continue            # Continue execution
(gdb) quit                # Exit GDB
```

#### Enhanced GDB Session
```bash
cd build/debug
gdb -x debug_symbols/gdb_commands.txt ./bin/Debug/c3d
```

#### GDB with TUI (Text User Interface)
```bash
gdb -tui ./bin/Debug/c3d
```

### Method 2: VS Code Debugging

#### Available Configurations:
- **Debug C3D (GDB)**: Main application
- **Debug C3D Unit Tests (GDB)**: Test suite  
- **Debug C3D Basic Example (GDB)**: Example application

#### Features:
- ✅ Graphical interface with source code view
- ✅ Breakpoint management
- ✅ Variable inspection
- ✅ Call stack navigation
- ✅ Integrated terminal
- ✅ Auto-build before debugging

### Method 3: LLDB (Alternative Debugger)
```bash
cd build/debug
lldb ./bin/Debug/c3d

# LLDB commands:
(lldb) breakpoint set --name main
(lldb) run
(lldb) step
(lldb) print variable_name
(lldb) bt
(lldb) quit
```

## Advanced Debugging Features

### Core Dump Analysis
```bash
# Enable core dumps
ulimit -c unlimited

# After crash, analyze core dump
gdb ./bin/Debug/c3d core

# Commands in GDB:
(gdb) backtrace full      # Full stack trace with variables
(gdb) info registers      # CPU register states
(gdb) thread apply all bt # All thread backtraces
```

### Memory Debugging with Valgrind
```bash
# Memory leak detection
valgrind --leak-check=full ./bin/Debug/c3d

# Memory error detection
valgrind --tool=memcheck --track-origins=yes ./bin/Debug/c3d
```

### AddressSanitizer (Build-time)
```bash
# Add to CMake flags for enhanced memory debugging
export CMAKE_CXX_FLAGS_DEBUG="-g3 -gdwarf-4 -O0 -fsanitize=address -fno-omit-frame-pointer"
./scripts/build-debug.sh clean
```

## Debugging Different Components

### Debug Main Application
```bash
gdb ./bin/Debug/c3d
```

### Debug Unit Tests
```bash
gdb ./bin/Debug/unit_tests
```

### Debug with Arguments
```bash
gdb --args ./bin/Debug/c3d arg1 arg2
```

### Debug Library Functions
```bash
gdb ./bin/Debug/c3d
(gdb) break c3d::add     # Set breakpoint in library function
(gdb) run
```

## Debug Symbol Information

### Verify Debug Symbols
```bash
# Check if debug symbols are present
file ./bin/Debug/c3d
# Output should show: "with debug_info, not stripped"

# List debug sections
readelf -S ./bin/Debug/c3d | grep debug

# View debug info size
size ./bin/Debug/c3d
```

### Available Debug Sections
- **`.debug_info`**: Variable and type information
- **`.debug_line`**: Source line mapping
- **`.debug_str`**: String table
- **`.debug_abbrev`**: Abbreviation table
- **`.debug_aranges`**: Address ranges
- **`.debug_macro`**: Macro definitions (with -g3)

## Common Debugging Scenarios

### 1. Segmentation Fault
```bash
gdb ./bin/Debug/c3d
(gdb) run
# Program crashes
(gdb) backtrace           # See where it crashed
(gdb) frame 0             # Examine crash frame
(gdb) print *pointer      # Check pointer values
```

### 2. Infinite Loop
```bash
gdb ./bin/Debug/c3d
(gdb) run
# Press Ctrl+C when stuck
(gdb) backtrace           # See where it's stuck
(gdb) print variables     # Check loop variables
```

### 3. Wrong Results
```bash
gdb ./bin/Debug/c3d
(gdb) break function_name
(gdb) run
(gdb) step               # Step through function
(gdb) print variable     # Check intermediate values
```

### 4. Performance Issues
```bash
# Profile with perf
perf record ./bin/Debug/c3d
perf report

# Or use gprof (requires -pg flag)
./bin/Debug/c3d
gprof ./bin/Debug/c3d gmon.out
```

## Debugging Build Issues

### CMake Configuration Problems
```bash
# Check CMake configuration
cd build/debug
cmake -LAH .

# Verify compiler flags
grep "CMAKE_CXX_FLAGS" CMakeCache.txt
```

### Conan Dependency Issues
```bash
# Check Conan packages
cd build/debug
conan info .

# Verify toolchain
cat conan_toolchain.cmake
```

## IDE Integration

### VS Code Extensions (Recommended)
- **C/C++** by Microsoft
- **C/C++ Extension Pack** by Microsoft  
- **CodeLLDB** (alternative debugger)
- **Native Debug** (GDB support)

### CLion Configuration
1. File → Settings → Build → CMake
2. Add Debug profile:
   - Build type: Debug
   - Build directory: build/debug
   - CMake options: `-DCMAKE_TOOLCHAIN_FILE=build/debug/conan_toolchain.cmake`

### Qt Creator Configuration
1. Projects → Build & Run → Kit
2. Debugger: System GDB
3. CMake Tool: System CMake
4. Build directory: build/debug

## Troubleshooting

### "No debugging symbols found"
```bash
# Check if stripped
file ./bin/Debug/c3d

# Rebuild with debug symbols
./scripts/clean.sh Debug
./scripts/build-debug.sh
```

### "Cannot find source file"
```bash
# Set source directory in GDB
(gdb) directory /path/to/source

# Or use absolute paths in CMake
set(CMAKE_BUILD_TYPE Debug)
```

### "Optimized out" Variables
```bash
# Ensure -O0 is used
grep -r "CMAKE_CXX_FLAGS_DEBUG" build/debug/

# Should show: -O0
```

## Summary

✅ **Debug symbols**: DWARF-4 format (not PDB)  
✅ **Enhanced debug info**: `-g3` level with macros  
✅ **GDB ready**: Command line and VS Code integration  
✅ **Source code access**: Full source-level debugging  
✅ **Multiple tools**: GDB, LLDB, Valgrind support  
✅ **Separate symbols**: Optional external debug files  

The C3D project is now fully equipped for comprehensive Linux debugging! 🐛🔍
