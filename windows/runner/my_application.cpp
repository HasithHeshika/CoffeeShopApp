#include "my_application.h"

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter/generated_plugin_registrant.h"

const std::wstring kFlutterWindowTitle = L"restaurant_order_system";
const unsigned int kFlutterWindowOriginX = 10;
const unsigned int kFlutterWindowOriginY = 10;
const unsigned int kFlutterWindowWidth = 1280;
const unsigned int kFlutterWindowHeight = 720;

bool MyApplication::OnCreate() {
  // Configure Flutter project parameters
  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  // Create the view controller
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      kFlutterWindowWidth, kFlutterWindowHeight, project);
  // Ensure that basic setup of the controller was successful
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  return true;
}

void MyApplication::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
MyApplication::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
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
