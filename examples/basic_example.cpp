#include <iostream>
#include "c3d/api.h"

int main() {
    std::cout << "C3D Example Application" << std::endl;
    
    // Test the add function
    int result = c3d::add(3, 4);
    std::cout << "3 + 4 = " << result << std::endl;
    
    std::cout << "Example completed successfully!" << std::endl;
    
    return 0;
}
