#include <iostream>
#include "../print_debug/print_debug.h"

int main() {
    // PRINT_DEBUG_ERROR: Always shown when PRINT_DEBUG_LEVEL >= PRINT_DEBUG_LEVEL_ERROR
    // - Outputs to stderr in bold red
    PRINT_DEBUG_ERROR("This is an error message\n");
    PRINT_DEBUG_ERROR("Error with value: %d\n", 42);

    // PRINT_DEBUG_WARN: Shown when PRINT_DEBUG_LEVEL >= PRINT_DEBUG_LEVEL_WARN
    // - Outputs to stdout in yellow
    PRINT_DEBUG_WARN("This is a warning message\n");
    PRINT_DEBUG_WARN("Warning with string: %s\n", "important");

    // PRINT_DEBUG_INFO: Shown when PRINT_DEBUG_LEVEL >= PRINT_DEBUG_LEVEL_INFO
    // - Outputs to stdout in blue
    PRINT_DEBUG_INFO("This is an info message\n");
    PRINT_DEBUG_INFO("Info with float: %.2f\n", 3.14159);


    // Combined example with multiple variables
    int count = 5;
    const char* status = "active";
    float percentage = 85.5f;

    PRINT_DEBUG_INFO("Status report: %s, Count: %d, Progress: %.1f%%\n",
                     status, count, percentage);
    PRINT_DEBUG_WARN("Warning threshold reached at %d%%\n", 75);
    PRINT_DEBUG_ERROR("Critical error in %s at line %d\n", __FILE__, __LINE__);

    return 0;
}