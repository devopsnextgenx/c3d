#include "c3dRenderer.h"
#include "canvasConfig.h"
#include <epoxy/gl.h>
#include <glm/gtc/matrix_transform.hpp>
#include <iostream>

const char* C3DRenderer::vertexShaderSource_ = R"(
#version 330 core
layout (location = 0) in vec3 aPos;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

void main() {
    gl_Position = projection * view * model * vec4(aPos, 1.0);
}
)";

const char* C3DRenderer::fragmentShaderSource_ = R"(
#version 330 core
out vec4 FragColor;

uniform vec4 color;

void main() {
    FragColor = color;
}
)";

C3DRenderer::C3DRenderer() : shaderProgram_(0), VAO_(0), VBO_(0) {}

C3DRenderer::~C3DRenderer() {
    cleanup();
}

bool C3DRenderer::initialize() {
    if (!createShaders()) {
        std::cerr << "Failed to create shaders!" << std::endl;
        return false;
    }

    // Generate and bind VAO and VBO
    glGenVertexArrays(1, &VAO_);
    glGenBuffers(1, &VBO_);
    
    return true;
}

void C3DRenderer::cleanup() {
    if (shaderProgram_) glDeleteProgram(shaderProgram_);
    if (VAO_) glDeleteVertexArrays(1, &VAO_);
    if (VBO_) glDeleteBuffers(1, &VBO_);
}

bool C3DRenderer::createShaders() {
    unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource_, nullptr);
    glCompileShader(vertexShader);
    
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(vertexShader, 512, nullptr, infoLog);
        std::cerr << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
        return false;
    }

    unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource_, nullptr);
    glCompileShader(fragmentShader);

    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(fragmentShader, 512, nullptr, infoLog);
        std::cerr << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
        return false;
    }

    shaderProgram_ = glCreateProgram();
    glAttachShader(shaderProgram_, vertexShader);
    glAttachShader(shaderProgram_, fragmentShader);
    glLinkProgram(shaderProgram_);

    glGetProgramiv(shaderProgram_, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram_, 512, nullptr, infoLog);
        std::cerr << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
        return false;
    }

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    return true;
}

void C3DRenderer::beginFrame() {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);  // Black background
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void C3DRenderer::endFrame() {
    // Normally swap buffers would happen here, but handled externally
}

void C3DRenderer::setViewport(int width, int height) {
    glViewport(0, 0, width, height);
    CanvasConfig::getInstance().setDimensions(width, height);
    setProjection();
}

void C3DRenderer::setProjection() {
    auto& config = CanvasConfig::getInstance();
    float aspectRatio = config.getAspectRatio();
    float zNear = config.getZNear();
    float zFar = config.getZFar();

    glm::mat4 projection = glm::perspective(glm::radians(45.0f), aspectRatio, zNear, zFar);
    glm::mat4 view = glm::lookAt(glm::vec3(0.0f, 0.0f, 3.0f), 
                                 glm::vec3(0.0f, 0.0f, 0.0f), 
                                 glm::vec3(0.0f, 1.0f, 0.0f));
    glm::mat4 model = glm::mat4(1.0f);
    
    glUseProgram(shaderProgram_);
    unsigned int projLoc = glGetUniformLocation(shaderProgram_, "projection");
    unsigned int viewLoc = glGetUniformLocation(shaderProgram_, "view");
    unsigned int modelLoc = glGetUniformLocation(shaderProgram_, "model");
    
    glUniformMatrix4fv(projLoc, 1, GL_FALSE, &projection[0][0]);
    glUniformMatrix4fv(viewLoc, 1, GL_FALSE, &view[0][0]);
    glUniformMatrix4fv(modelLoc, 1, GL_FALSE, &model[0][0]);
}

void C3DRenderer::setColor(const Color& color) {
    glUseProgram(shaderProgram_);
    unsigned int colorLoc = glGetUniformLocation(shaderProgram_, "color");
    glUniform4f(colorLoc, color.r, color.g, color.b, color.a);
}

void C3DRenderer::drawTriangle(const std::vector<glm::vec3>& vertices, const Color& lineColor, const std::optional<Color>& fillColor) {
    if (vertices.size() < 3) return;
    
    glBindVertexArray(VAO_);
    glBindBuffer(GL_ARRAY_BUFFER, VBO_);

    // Draw fill if specified
    if (fillColor) {
        setColor(*fillColor);
        glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(glm::vec3), &vertices[0], GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(glm::vec3), (void*)0);
        glEnableVertexAttribArray(0);
        glDrawArrays(GL_TRIANGLES, 0, vertices.size());
    }

    // Draw outline
    setColor(lineColor);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(glm::vec3), &vertices[0], GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(glm::vec3), (void*)0);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_LINE_LOOP, 0, vertices.size());
    
    glBindVertexArray(0);
}

void C3DRenderer::drawLine(const glm::vec3& start, const glm::vec3& end, const Color& color) {
    std::vector<glm::vec3> vertices = { start, end };
    setColor(color);
    glBindVertexArray(VAO_);
    glBindBuffer(GL_ARRAY_BUFFER, VBO_);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(glm::vec3), &vertices[0], GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(glm::vec3), (void*)0);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_LINES, 0, 2);
    glBindVertexArray(0);
}

void C3DRenderer::drawPoints(const std::vector<glm::vec3>& points, const Color& color) {
    setColor(color);
    glBindVertexArray(VAO_);
    glBindBuffer(GL_ARRAY_BUFFER, VBO_);
    glBufferData(GL_ARRAY_BUFFER, points.size() * sizeof(glm::vec3), &points[0], GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(glm::vec3), (void*)0);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_POINTS, 0, points.size());
    glBindVertexArray(0);
}
