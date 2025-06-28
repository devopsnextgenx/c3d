#include <gtk/gtk.h>
#include <epoxy/gl.h>
#include <epoxy/glx.h>
#include <iostream>
#include <memory>
#include "../graphics/c3dRenderer.h"
#include "../graphics/canvasConfig.h"

class AppWindow {
public:
    AppWindow() : renderer_initialized_(false) {}
    ~AppWindow() = default;
    
    bool initialize(int argc, char *argv[]);
    void run();
    
private:
    GtkWidget *window_ = nullptr;
    GtkWidget *gl_area_ = nullptr;
    std::unique_ptr<C3DRenderer> renderer_;
    bool renderer_initialized_;
    
    static void on_realize(GtkGLArea *area, gpointer user_data);
    static gboolean on_render(GtkGLArea *area, GdkGLContext *context, gpointer user_data);
    static void on_destroy(GtkWidget *widget, gpointer user_data);
    static gboolean on_delete_event(GtkWidget *widget, GdkEvent *event, gpointer user_data);
    
    void setup_opengl();
    void render_frame();
};

bool AppWindow::initialize(int argc, char *argv[]) {
    gtk_init(&argc, &argv);
    
    // Create main window
    window_ = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    if (!window_) {
        std::cerr << "Failed to create GTK window" << std::endl;
        return false;
    }
    
    gtk_window_set_title(GTK_WINDOW(window_), "C3D App Window - OpenGL Canvas");
    gtk_window_set_default_size(GTK_WINDOW(window_), 800, 600);
    gtk_window_set_position(GTK_WINDOW(window_), GTK_WIN_POS_CENTER);
    
    // Enable window decorations (title bar with minimize/maximize/close buttons)
    gtk_window_set_decorated(GTK_WINDOW(window_), TRUE);
    gtk_window_set_resizable(GTK_WINDOW(window_), TRUE);
    
    // Create OpenGL area
    gl_area_ = gtk_gl_area_new();
    if (!gl_area_) {
        std::cerr << "Failed to create GTK GL Area" << std::endl;
        return false;
    }
    
    // Set OpenGL requirements
    gtk_gl_area_set_required_version(GTK_GL_AREA(gl_area_), 3, 3);
    gtk_gl_area_set_has_depth_buffer(GTK_GL_AREA(gl_area_), TRUE);
    
    // Connect signals
    g_signal_connect(gl_area_, "render", G_CALLBACK(on_render), this);
    g_signal_connect(gl_area_, "realize", G_CALLBACK(on_realize), this);
    g_signal_connect(window_, "destroy", G_CALLBACK(on_destroy), this);
    g_signal_connect(window_, "delete-event", G_CALLBACK(on_delete_event), this);
    
    // Add GL area to window
    gtk_container_add(GTK_CONTAINER(window_), gl_area_);
    
    return true;
}

void AppWindow::run() {
    gtk_widget_show_all(window_);
    gtk_main();
}

void AppWindow::on_realize(GtkGLArea *area, gpointer user_data) {
    AppWindow *app = static_cast<AppWindow*>(user_data);
    gtk_gl_area_make_current(area);
    
    if (gtk_gl_area_get_error(area) != NULL) {
        std::cerr << "Error in GL area realize" << std::endl;
        return;
    }
    
    app->setup_opengl();
}

gboolean AppWindow::on_render(GtkGLArea *area, GdkGLContext *context, gpointer user_data) {
    AppWindow *app = static_cast<AppWindow*>(user_data);
    
    if (gtk_gl_area_get_error(area) != NULL) {
        return FALSE;
    }
    
    app->render_frame();
    return TRUE;
}

void AppWindow::on_destroy(GtkWidget *widget, gpointer user_data) {
    gtk_main_quit();
}

gboolean AppWindow::on_delete_event(GtkWidget *widget, GdkEvent *event, gpointer user_data) {
    // Return FALSE to allow the default handler to destroy the window
    return FALSE;
}

void AppWindow::setup_opengl() {
    std::cout << "OpenGL Version: " << glGetString(GL_VERSION) << std::endl;
    std::cout << "OpenGL Vendor: " << glGetString(GL_VENDOR) << std::endl;
    std::cout << "OpenGL Renderer: " << glGetString(GL_RENDERER) << std::endl;
    
    // Enable depth testing
    glEnable(GL_DEPTH_TEST);
    
    // Initialize canvas config with default window size
    auto& config = CanvasConfig::getInstance();
    config.setDimensions(900, 600);
    
    std::cout << "OpenGL setup completed!" << std::endl;
}

void AppWindow::render_frame() {
    // Initialize renderer on first call (when OpenGL context is active)
    if (!renderer_initialized_) {
        renderer_ = std::make_unique<C3DRenderer>();
        if (!renderer_->initialize()) {
            std::cerr << "Failed to initialize renderer!" << std::endl;
            return;
        }
        renderer_initialized_ = true;
        std::cout << "C3D Renderer initialized successfully!" << std::endl;
    }
    
    if (!renderer_) return;
    
    // Set viewport
    int width = gtk_widget_get_allocated_width(gl_area_);
    int height = gtk_widget_get_allocated_height(gl_area_);
    renderer_->setViewport(width, height);
    
    // Begin frame rendering
    renderer_->beginFrame();
    
    // Draw the triangle with coordinates (0,1), (-1,0), (1,0)
    std::vector<glm::vec3> triangleVertices = {
        glm::vec3(0.0f, 1.0f, 0.0f),   // Top vertex
        glm::vec3(-1.0f, 0.0f, 0.0f),  // Bottom left
        glm::vec3(1.0f, 0.0f, 0.0f)    // Bottom right
    };
    
    // Draw triangle outline in white with optional red fill
    renderer_->drawTriangle(triangleVertices, Color::white(), Color::red());
    
    // End frame rendering
    renderer_->endFrame();
    
    // Flush the OpenGL commands
    glFlush();
}

int main(int argc, char *argv[]) {
    AppWindow app;
    
    if (!app.initialize(argc, argv)) {
        std::cerr << "Failed to initialize application" << std::endl;
        return 1;
    }
    
    std::cout << "Starting C3D Application with GTK+OpenGL..." << std::endl;
    app.run();
    
    return 0;
}
