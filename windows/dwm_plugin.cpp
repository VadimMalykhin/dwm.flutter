#include "dwm_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace dwm {

const char kChannelName[] = "dwm";
const char kEnsureInitialized[] = "ensureInitialized";
const char kGetContentProtection[] = "getContentProtection";
const char kSetContentProtection[] = "setContentProtection";

// Method channel.
std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>,
                std::default_delete<flutter::MethodChannel<flutter::EncodableValue>>>
    method_channel_ = nullptr;

// static
void DwmPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
  method_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), kChannelName, &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DwmPlugin>(registrar);

  method_channel_->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

DwmPlugin::DwmPlugin(flutter::PluginRegistrarWindows* registrar) : registrar_(registrar) {
  window_proc_id_ = registrar_->RegisterTopLevelWindowProcDelegate(
      [this](HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
        return HandleWindowProc(hwnd, message, wparam, lparam);
      });
}

DwmPlugin::~DwmPlugin() {
  registrar_->UnregisterTopLevelWindowProcDelegate(window_proc_id_);
}

void DwmPlugin::InvokeEvent(std::string eventName) {
  method_channel_->InvokeMethod(eventName, nullptr);
}

void DwmPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare(kEnsureInitialized) == 0) {
    if (!IsWindow(root_window_)) {
      root_window_ = ::GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
    }
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kGetContentProtection) == 0) {
    // Retrieves the current display affinity setting, from any process, for a given window.
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowdisplayaffinity

    DWORD dwa;
    if (!GetWindowDisplayAffinity(root_window_, &dwa)) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    if (dwa == WDA_MONITOR || dwa == WDA_EXCLUDEFROMCAPTURE) {
      result->Success(flutter::EncodableValue(true));
    } else {
      result->Success(flutter::EncodableValue(false));
    }
  } else if (method_call.method_name().compare(kSetContentProtection) == 0) {
    // Specifies where the content of the window can be displayed.
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowdisplayaffinity

    auto methodArguments = std::get<flutter::EncodableMap>(*method_call.arguments());
    auto value = std::get<bool>(methodArguments[flutter::EncodableValue("value")]);
    if (!value) {
      if (SetWindowDisplayAffinity(root_window_, WDA_NONE)) {
        InvokeEvent("onContentProtectionDisabled");
      }
    } else {
      if (SetWindowDisplayAffinity(root_window_, WDA_EXCLUDEFROMCAPTURE)) {
        InvokeEvent("onContentProtectionEnabled");
      }
    }
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else {
    result->NotImplemented();
  }
}

// https://docs.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues#system-defined-messages
std::optional<LRESULT> DwmPlugin::HandleWindowProc(HWND hwnd,
                                                   UINT message,
                                                   WPARAM wparam,
                                                   LPARAM lparam) {
  std::optional<LRESULT> result = std::nullopt;
  return result;
}

}  // namespace dwm
