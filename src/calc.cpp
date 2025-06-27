#include <iostream>
#include "c3d/api.h"

namespace c3d {
    int add(int x, int y) {
        std::cout << "Adding " << x << " and " << y << std::endl;
        return x + y;
    }
} // namespace c3d
