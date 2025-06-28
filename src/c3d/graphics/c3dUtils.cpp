#include "c3dUtils.h"
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtx/transform.hpp>

glm::vec3 C3DUtils::translate(const glm::vec3& point, const glm::vec3& offset) {
    return point + offset;
}

glm::vec3 C3DUtils::rotate(const glm::vec3& point, float angle, const glm::vec3& axis) {
    glm::mat4 rotationMatrix = glm::rotate(angle, axis);
    glm::vec4 rotatedPoint = rotationMatrix * glm::vec4(point, 1.0f);
    return glm::vec3(rotatedPoint);
}

glm::vec3 C3DUtils::scale(const glm::vec3& point, const glm::vec3& scaleFactors) {
    return point * scaleFactors;
}

std::vector<glm::vec3> C3DUtils::translate(const std::vector<glm::vec3>& points, const glm::vec3& offset) {
    std::vector<glm::vec3> result;
    result.reserve(points.size());
    for (const auto& point : points) {
        result.push_back(translate(point, offset));
    }
    return result;
}

std::vector<glm::vec3> C3DUtils::rotate(const std::vector<glm::vec3>& points, float angle, const glm::vec3& axis) {
    std::vector<glm::vec3> result;
    result.reserve(points.size());
    for (const auto& point : points) {
        result.push_back(rotate(point, angle, axis));
    }
    return result;
}

std::vector<glm::vec3> C3DUtils::scale(const std::vector<glm::vec3>& points, const glm::vec3& scaleFactors) {
    std::vector<glm::vec3> result;
    result.reserve(points.size());
    for (const auto& point : points) {
        result.push_back(scale(point, scaleFactors));
    }
    return result;
}
