#pragma once

class CanvasConfig {
public:
    static CanvasConfig& getInstance();
    
    // Getters
    float getAspectRatio() const { return aspectRatio_; }
    float getZNear() const { return zNear_; }
    float getZFar() const { return zFar_; }
    int getWidth() const { return width_; }
    int getHeight() const { return height_; }
    
    // Setters
    void setDimensions(int width, int height);
    void setZRange(float zNear, float zFar);
    
private:
    CanvasConfig();
    ~CanvasConfig() = default;
    
    // Non-copyable
    CanvasConfig(const CanvasConfig&) = delete;
    CanvasConfig& operator=(const CanvasConfig&) = delete;
    
    float aspectRatio_;
    float zNear_;
    float zFar_;
    int width_;
    int height_;
    
    void updateAspectRatio();
};
