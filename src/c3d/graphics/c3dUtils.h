#pragma once
#include <glm/glm.hpp>
#include <vector>

class C3DUtils {
public:
    static glm::vec3 translate(const glm::vec3& point, const glm::vec3& offset);
    static glm::vec3 rotate(const glm::vec3& point, float angle, const glm::vec3& axis);
    static glm::vec3 scale(const glm::vec3& point, const glm::vec3& scaleFactors);

    static std::vector<glm::vec3> translate(const std::vector<glm::vec3>& points, const glm::vec3& offset);
    static std::vector<glm::vec3> rotate(const std::vector<glm::vec3>& points, float angle, const glm::vec3& axis);
    static std::vector<glm::vec3> scale(const std::vector<glm::vec3>& points, const glm::vec3& scaleFactors);
};
