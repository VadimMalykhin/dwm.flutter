#include "include/dwm/dwm_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "dwm_plugin.h"

void DwmPluginCApiRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
  dwm::DwmPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()->GetRegistrar<flutter::PluginRegistrarWindows>(
          registrar));
}
