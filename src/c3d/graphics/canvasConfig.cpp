#include "canvasConfig.h"

CanvasConfig& CanvasConfig::getInstance() {
    static CanvasConfig instance;
    return instance;
}

CanvasConfig::CanvasConfig()
    : width_(900)
    , height_(600)
    , zNear_(0.1f)
    , zFar_(100.0f) {
    updateAspectRatio();
}

void CanvasConfig::setDimensions(int width, int height) {
    width_ = width;
    height_ = height;
    updateAspectRatio();
}

void CanvasConfig::setZRange(float zNear, float zFar) {
    zNear_ = zNear;
    zFar_ = zFar;
}

void CanvasConfig::updateAspectRatio() {
    if (height_ > 0) {
        aspectRatio_ = static_cast<float>(width_) / static_cast<float>(height_);
    } else {
        aspectRatio_ = 1.0f;
    }
}
