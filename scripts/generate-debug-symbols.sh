#!/bin/bash

# Generate separate debug symbol files for enhanced debugging
# Usage: ./scripts/generate-debug-symbols.sh

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEBUG_DIR="${PROJECT_ROOT}/build/debug"

echo "Generating separate debug symbol files..."

if [[ ! -d "${DEBUG_DIR}/bin/Debug" ]]; then
    echo "Error: Debug build not found. Please run './scripts/build-debug.sh' first."
    exit 1
fi

# Create debug symbols directory
DEBUG_SYMBOLS_DIR="${DEBUG_DIR}/debug_symbols"
mkdir -p "${DEBUG_SYMBOLS_DIR}"

# Process all executables in Debug build
find "${DEBUG_DIR}/bin/Debug" -type f -executable -print0 | while IFS= read -r -d '' executable; do
    filename=$(basename "$executable")
    symbol_file="${DEBUG_SYMBOLS_DIR}/${filename}.debug"
    
    echo "Processing: $filename"
    
    # Extract debug symbols to separate file
    objcopy --only-keep-debug "$executable" "$symbol_file"
    
    # Strip debug symbols from main executable (optional - creates smaller runtime binary)
    # objcopy --strip-debug "$executable"
    
    # Add debug link (so debugger can find symbols)
    # objcopy --add-gnu-debuglink="$symbol_file" "$executable"
    
    echo "  → Debug symbols: $symbol_file"
done

# Generate core dump analysis helper
cat > "${DEBUG_SYMBOLS_DIR}/gdb_commands.txt" << 'EOF'
# GDB Commands for debugging with separate symbols
# Usage: gdb -x debug_symbols/gdb_commands.txt ./bin/Debug/c3d

# Load debug symbols
set debug-file-directory debug_symbols

# Enhanced debugging settings
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3

# Useful debugging commands:
# (gdb) bt          - backtrace
# (gdb) bt full     - backtrace with local variables
# (gdb) info locals - show local variables
# (gdb) info args   - show function arguments
# (gdb) list        - show source code
# (gdb) frame N     - switch to frame N
# (gdb) up/down     - move up/down stack frames

echo "Debug environment loaded. Happy debugging!"
EOF

echo ""
echo "Debug symbol generation completed!"
echo "Debug symbols directory: ${DEBUG_SYMBOLS_DIR}"
echo ""
echo "To debug with GDB:"
echo "  cd ${DEBUG_DIR}"
echo "  gdb -x debug_symbols/gdb_commands.txt ./bin/Debug/c3d"
echo ""
echo "To debug with LLDB:"
echo "  cd ${DEBUG_DIR}"
echo "  lldb ./bin/Debug/c3d"
echo ""
echo "For VS Code debugging, use the enhanced launch configuration."
