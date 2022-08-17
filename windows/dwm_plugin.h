#ifndef FLUTTER_PLUGIN_DWM_PLUGIN_H_
#define FLUTTER_PLUGIN_DWM_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <stdio.h>
#include <windows.h>
#include <windowsx.h>
#include <dwmapi.h>
#include <math.h>

#include <memory>

namespace dwm {

class DwmPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  explicit DwmPlugin(flutter::PluginRegistrarWindows* registrar);

  virtual ~DwmPlugin();

  // Disallow copy and assign.
  DwmPlugin(const DwmPlugin&) = delete;
  DwmPlugin& operator=(const DwmPlugin&) = delete;

 private:
  // The registrar for this plugin for accessing the window.
  flutter::PluginRegistrarWindows* registrar_;

  // Returns an ID of the WindowProc delegate registration that can be used to unregister the
  // handler.
  int window_proc_id_ = -1;

  // The root window.
  HWND root_window_;

  // A window placement
  WINDOWPLACEMENT window_placement_;

  POINT min_wnd_size_ = {0, 0};
  POINT max_wnd_size_ = {-1, -1};

  bool is_wnd_maximized_ = false;
  bool is_wnd_minimized_ = false;
  bool is_wnd_resizable_ = true;

  int theme_mode_;

  // Sends a message to the Flutter engine on this channel.
  void InvokeMethod(std::string eventName, flutter::EncodableValue eventValue);

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue>& method_call,
                        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // Called for top-level WindowProc delegation.
  std::optional<LRESULT> HandleWindowProc(HWND hwnd,
                                          UINT message,
                                          WPARAM wparam,
                                          LPARAM lparam) noexcept;
};

}  // namespace dwm

#endif  // FLUTTER_PLUGIN_DWM_PLUGIN_H_
