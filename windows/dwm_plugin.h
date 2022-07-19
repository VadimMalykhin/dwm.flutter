#ifndef FLUTTER_PLUGIN_DWM_PLUGIN_H_
#define FLUTTER_PLUGIN_DWM_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace dwm {

class DwmPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DwmPlugin();

  virtual ~DwmPlugin();

  // Disallow copy and assign.
  DwmPlugin(const DwmPlugin&) = delete;
  DwmPlugin& operator=(const DwmPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace dwm

#endif  // FLUTTER_PLUGIN_DWM_PLUGIN_H_
