# PRINT_DEBUG - Header-Only Debug Logging Library

A lightweight, header-only C/C++ debugging library that provides conditional debug printing macros with color-coded output based on configurable debug levels. This library is designed to be compiled out (using empty macros) when not needed, resulting in zero runtime overhead.

## Features

- **Header-only**: No compilation or linking required, just include the header
- **Zero overhead**: Debug statements can be completely compiled out when disabled
- **Color-coded output**: ANSI color support for easy log level identification
- **CMake integration**: Easy configuration through CMake build system with helper functions
- **Build-type aware**: Different log levels for Debug and Release builds
- **Global defaults**: Project-wide reference variables for consistent configuration

## Debug Levels

The library supports four debug levels. Each level enables specific macros while disabling others:

### Debug Level Overview

| Level Name                | Value | Description                       | Macros Enabled                                                    |
|---------------------------|-------|-----------------------------------|-------------------------------------------------------------------|
| `PRINT_DEBUG_LEVEL_NONE`  | 0     | All debug output disabled         | *(none)*                                                          |
| `PRINT_DEBUG_LEVEL_ERROR` | 1     | Show only critical errors         | `PRINT_DEBUG_ERROR()`                                             |
| `PRINT_DEBUG_LEVEL_WARN`  | 2     | Show warnings and errors          | `PRINT_DEBUG_ERROR()`, `PRINT_DEBUG_WARN()`                       |
| `PRINT_DEBUG_LEVEL_INFO`  | 3     | Show all messages (max verbosity) | `PRINT_DEBUG_ERROR()`, `PRINT_DEBUG_WARN()`, `PRINT_DEBUG_INFO()` |

### Available Macros Detail

| Macro                         | Min. Level Required           | Output Stream | Color        | Purpose                                          |
|-------------------------------|-------------------------------|---------------|--------------|--------------------------------------------------|
| `PRINT_DEBUG_ERROR(fmt, ...)` | `PRINT_DEBUG_LEVEL_ERROR` (1) | `stderr`      | **Bold Red** | Critical errors that require immediate attention |
| `PRINT_DEBUG_WARN(fmt, ...)`  | `PRINT_DEBUG_LEVEL_WARN` (2)  | `stdout`      | **Yellow**   | Warnings about potential issues                  |
| `PRINT_DEBUG_INFO(fmt, ...)`  | `PRINT_DEBUG_LEVEL_INFO` (3)  | `stdout`      | **Blue**     | Informational messages for debugging             |

## Configuration

### Setting Debug Levels (Required for Each Target)

Debug levels must be configured in CMake using the `define_print_debug_level_for_target()` function. This function automatically sets the `PRINT_DEBUG_LEVEL` compile definition for both Release and Debug builds.

#### Using CMake (Recommended):

```cmake
include(PrintDebug.cmake)

add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE print_debug)

# Set debug levels: RELEASE_LEVEL=1 (ERROR only), DEBUG_LEVEL=3 (INFO)
define_print_debug_level_for_target(my_app ${PRINT_DEBUG_LEVEL_ERROR} ${PRINT_DEBUG_LEVEL_INFO})
```

The function takes three arguments:
- `target`: The CMake target to configure (executable or library)
- `release_level`: Debug level for Release builds (0-3)
- `debug_level`: Debug level for Debug builds (0-3)

#### Default Behavior:

If you do **not** call `define_print_debug_level_for_target()`, `PRINT_DEBUG_LEVEL` defaults to `PRINT_DEBUG_LEVEL_NONE` (0), meaning **all debug macros will be disabled** and produce no output or code.

#### For Non-CMake Projects:

If you're not using CMake, you can set the level manually:

```bash
# Via compiler flag
g++ -DPRINT_DEBUG_LEVEL=3 main.cpp -o main
```


### Basic Example

```cpp
#include <iostream>
#include "print_debug.h"

int main() {
    // ERROR: Always shown when PRINT_DEBUG_LEVEL >= PRINT_DEBUG_LEVEL_ERROR
    // Outputs to stderr in bold red
    PRINT_DEBUG_ERROR("This is an error message\n");
    PRINT_DEBUG_ERROR("Error with value: %d\n", 42);

    // WARN: Shown when PRINT_DEBUG_LEVEL >= PRINT_DEBUG_LEVEL_WARN
    // Outputs to stdout in yellow
    PRINT_DEBUG_WARN("This is a warning message\n");
    PRINT_DEBUG_WARN("Warning with string: %s\n", "important");

    // INFO: Shown when PRINT_DEBUG_LEVEL >= PRINT_DEBUG_LEVEL_INFO
    // Outputs to stdout in blue
    PRINT_DEBUG_INFO("This is an info message\n");
    PRINT_DEBUG_INFO("Info with float: %.2f\n", 3.14159);

    return 0;
}
```
## Output Format

All debug messages include a prefix tag:

```
[DEBUG_ERROR] Your error message here
[DEBUG_WARN]  Your warning message here
[DEBUG_INFO]  Your info message here
```

## Zero-Cost Abstraction

When `PRINT_DEBUG_LEVEL` is set to `PRINT_DEBUG_LEVEL_NONE` or a log level is below the configured threshold:

- Disabled macros are defined as empty statements: `#define PRINT_DEBUG_INFO(format, ...)`
- **No runtime overhead** - zero instructions generated
- **No memory footprint** - no binary size increase

This makes it safe to leave debug statements in production code.


## Best Practices

1. **Use appropriate levels**: ERROR for critical issues, WARN for potential problems, INFO for debugging
2. **Include newlines**: Use `\n` at the end of format strings
3. **Include file/line info**: Use `__FILE__` and `__LINE__` for error messages
4. **Different levels per build**: Use ERROR for release, INFO for debug
5. **Variable arguments**: Use printf-style formatting, not concatenation

## License

This project is provided as-is. Modify and use freely.

## Contributing

This is a personal project. Feel free to fork and adapt for your needs.

---

