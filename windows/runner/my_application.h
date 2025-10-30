#ifndef RUNNER_MY_APPLICATION_H_
#define RUNNER_MY_APPLICATION_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include "win32_window.h"

// A window that does nothing but host a Flutter view.
class MyApplication : public Win32Window {
 public:
  // Creates a new MyApplication.
  explicit MyApplication(const flutter::DartProject& project);
  virtual ~MyApplication();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
};

#endif  // RUNNER_MY_APPLICATION_H_
