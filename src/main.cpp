#include <iostream>
#include "c3d/api.h"

int main() {
    std::cout << "C3D Application" << std::endl;
    std::cout << "7 + 4 = " << c3d::add(7, 4) << std::endl;
    std::cout << "C3D Application finished" << std::endl;
    return 0;
}