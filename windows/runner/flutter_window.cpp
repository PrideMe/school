#include "flutter_window.h"

#include <optional>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();
  int width = frame.right - frame.left;
  int height = frame.bottom - frame.top;
  if (width <= 0) width = 1280;
  if (height <= 0) height = 720;

  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      width, height, project_);
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // Window control MethodChannel for native drag, minimize, maximize, and close
  window_control_channel_ = std::make_unique<flutter::MethodChannel<>>(
      flutter_controller_->engine()->messenger(), "window_control",
      &flutter::StandardMethodCodec::GetInstance());

  window_control_channel_->SetMethodCallHandler([this](const flutter::MethodCall<>& call,
                                                        std::unique_ptr<flutter::MethodResult<>> result) {
    HWND hwnd = GetHandle();
    if (call.method_name() == "dragWindow") {
      ::ReleaseCapture();
      ::SendMessage(hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0);
      result->Success();
    } else if (call.method_name() == "minimize") {
      ::ShowWindow(hwnd, SW_MINIMIZE);
      result->Success();
    } else if (call.method_name() == "maximize") {
      if (::IsZoomed(hwnd)) {
        ::ShowWindow(hwnd, SW_RESTORE);
      } else {
        ::ShowWindow(hwnd, SW_MAXIMIZE);
      }
      result->Success();
    } else if (call.method_name() == "close") {
      ::PostMessage(hwnd, WM_CLOSE, 0, 0);
      result->Success();
    } else {
      result->NotImplemented();
    }
  });

  this->Show();

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (window_control_channel_) {
    window_control_channel_ = nullptr;
  }

  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
