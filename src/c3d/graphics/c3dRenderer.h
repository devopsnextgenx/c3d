#pragma once
#include <glm/glm.hpp>
#include <vector>
#include <optional>

struct Color {
    float r, g, b, a;
    
    Color(float red = 1.0f, float green = 1.0f, float blue = 1.0f, float alpha = 1.0f)
        : r(red), g(green), b(blue), a(alpha) {}
    
    static Color white() { return Color(1.0f, 1.0f, 1.0f, 1.0f); }
    static Color black() { return Color(0.0f, 0.0f, 0.0f, 1.0f); }
    static Color red() { return Color(1.0f, 0.0f, 0.0f, 1.0f); }
    static Color green() { return Color(0.0f, 1.0f, 0.0f, 1.0f); }
    static Color blue() { return Color(0.0f, 0.0f, 1.0f, 1.0f); }
};

class C3DRenderer {
public:
    C3DRenderer();
    ~C3DRenderer();
    
    bool initialize();
    void cleanup();
    
    void beginFrame();
    void endFrame();
    
    void setViewport(int width, int height);
    void setProjection();
    
    // Drawing functions
    void drawTriangle(const std::vector<glm::vec3>& vertices, 
                     const Color& lineColor = Color::white(),
                     const std::optional<Color>& fillColor = std::nullopt);
    
    void drawLine(const glm::vec3& start, const glm::vec3& end, 
                  const Color& color = Color::white());
    
    void drawPoints(const std::vector<glm::vec3>& points, 
                    const Color& color = Color::white());
    
private:
    unsigned int shaderProgram_;
    unsigned int VAO_;
    unsigned int VBO_;
    
    bool createShaders();
    void setColor(const Color& color);
    
    // Shader source code
    static const char* vertexShaderSource_;
    static const char* fragmentShaderSource_;
};
