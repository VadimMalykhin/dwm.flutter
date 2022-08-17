#include "dwm_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <WinUser.h>
#include <dwmapi.h>
#include <Uxtheme.h>
#include <commctrl.h>

#include <functional>
#include <memory>
#include <sstream>

namespace dwm {

static constexpr auto kChannelName = "flutter/dwm";

static constexpr auto kEnsureInitialized = "ensureInitialized";

static constexpr auto kGetPlatformVersion = "getPlatformVersion";

static constexpr auto kSetWindowIconAndCationVisibility = "setWindowIconAndCationVisibility";
static constexpr auto kSetWindowCation = "setWindowCation";

static constexpr auto kGetWindowMinSize = "getWindowMinSize";
static constexpr auto kSetWindowMinSize = "setWindowMinSize";
static constexpr auto kResetWindowMinSize = "resetWindowMinSize";

static constexpr auto kGetWindowMaxSize = "getWindowMaxSize";
static constexpr auto kSetWindowMaxSize = "setWindowMaxSize";
static constexpr auto kResetWindowMaxSize = "resetWindowMaxSize";

static constexpr auto kSetWindowSize = "setWindowSize";

static constexpr auto kIsWindowMinimized = "isWindowMinimized";
static constexpr auto kSetWindowMinimized = "setWindowMinimized";

static constexpr auto kIsWindowMaximized = "isWindowMaximized";
static constexpr auto kSetWindowMaximized = "setWindowMaximized";

static constexpr auto kSetWindowRestore = "setWindowRestore";

// Control Buttons
static constexpr auto kIsWindowResizable = "isWindowResizable";
static constexpr auto kSetWindowResizable = "setWindowResizable";

static constexpr auto kIsWindowMinimizable = "isWindowMinimizable";
static constexpr auto kSetWindowMinimizable = "setWindowMinimizable";

// static constexpr auto kIsWindowMaximizable = "isWindowMaximizable";
// static constexpr auto kSetWindowMaximizable = "setWindowMaximizable";

static constexpr auto kIsWindowClosable = "isWindowClosable";
static constexpr auto kSetWindowClosable = "setWindowClosable";

static constexpr auto kGetThemeMode = "getThemeMode";
static constexpr auto kSetThemeMode = "setThemeMode";

static constexpr auto kGetContentProtection = "getContentProtection";
static constexpr auto kSetContentProtection = "setContentProtection";

// https://docs.microsoft.com/en-us/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute
constexpr auto kDWMWA_USE_IMMERSIVE_DARK_MODE = static_cast<DWORD>(20);
constexpr auto kDWMWA_BORDER_COLOR = static_cast<DWORD>(34);
constexpr auto kDWMWA_CAPTION_COLOR = static_cast<DWORD>(35);
constexpr auto kDWMWA_TEXT_COLOR = static_cast<DWORD>(36);

// Colors
constexpr COLORREF kLIGHT_CAPTION_COLOR = RGB(243, 243, 243);
constexpr COLORREF kLIGHT_TITLE_COLOR = RGB(0, 0, 0);
constexpr COLORREF kLIGHT_BORDER_COLOR = RGB(19, 19, 19);
constexpr COLORREF kLIGHT_CONTENT_BG = RGB(249, 249, 249);

constexpr COLORREF kDARK_CAPTION_COLOR = RGB(32, 32, 32);
constexpr COLORREF kDARK_TITLE_COLOR = RGB(249, 249, 249);
constexpr COLORREF kDARK_BORDER_COLOR = RGB(19, 19, 19);
constexpr COLORREF kDARK_CONTENT_BG = RGB(39, 39, 39);

// Get the preferred theme mode
bool isDarkTheme() {
  DWORD use_light_theme;
  DWORD use_light_theme_size = sizeof(use_light_theme);
  LONG result = RegGetValue(
      HKEY_CURRENT_USER, L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
      L"AppsUseLightTheme", RRF_RT_REG_DWORD, nullptr, &use_light_theme, &use_light_theme_size);
  if (result == 0) {
    return use_light_theme ? false : true;
  } else {
    return false;
  }
}

HBRUSH GetPreferredThemeMode() {
  COLORREF color = isDarkTheme() ? kDARK_CONTENT_BG : kLIGHT_CONTENT_BG;
  return reinterpret_cast<HBRUSH>(CreateSolidBrush(color));
}

void setTitleBarThemeMode(HWND hwnd, bool isDark) {
  // if (isDark) {
  //   return;
  // }

  COLORREF captionColor = kDARK_CAPTION_COLOR;
  DwmSetWindowAttribute(hwnd, kDWMWA_CAPTION_COLOR, &captionColor, sizeof(captionColor));
  COLORREF titleColor = RGB(255, 255, 255);
  DwmSetWindowAttribute(hwnd, kDWMWA_TEXT_COLOR, &titleColor, sizeof(titleColor));
  COLORREF borderColor = RGB(25, 25, 25);
  DwmSetWindowAttribute(hwnd, kDWMWA_BORDER_COLOR, &borderColor, sizeof(borderColor));
  enum class DWM_BOOL { kFalse, kTrue };
  DWM_BOOL darkPreference = isDarkTheme() ? DWM_BOOL::kFalse : DWM_BOOL::kTrue;
  DwmSetWindowAttribute(hwnd, kDWMWA_USE_IMMERSIVE_DARK_MODE, &darkPreference,
                        sizeof(darkPreference));
}

// void setTitleBarThemeMode(HWND hwnd, bool isDark) {

// }

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
  // if (!IsWindow(root_window_)) {
  // if (!root_window_) {
  // }

  window_proc_id_ = registrar_->RegisterTopLevelWindowProcDelegate(
      [this](HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
        return HandleWindowProc(hwnd, message, wparam, lparam);
      });
}

DwmPlugin::~DwmPlugin() {
  registrar_->UnregisterTopLevelWindowProcDelegate(window_proc_id_);
}

// Sends a message to the Flutter engine on this channel.
// todo add argument
void DwmPlugin::InvokeMethod(std::string eventName, flutter::EncodableValue eventValue) {
  flutter::EncodableMap map = flutter::EncodableMap();
  map[flutter::EncodableValue("eventName")] = eventName;
  map[flutter::EncodableValue("eventValue")] = eventValue;
  method_channel_->InvokeMethod("onEvent", std::make_unique<flutter::EncodableValue>(map));
}

// // Windows 10+
// if (IsWindows10OrGreater()) {
//   // Hide an icon and title bar caption
//   setTitleBarIconAndCaptionVisible(hwnd, false);
//   // Set the dark mode
//   setTitleBarThemeMode(hwnd, true);
// }

void DwmPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare(kEnsureInitialized) == 0) {
    root_window_ = ::GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kGetPlatformVersion) == 0) {
    OSVERSIONINFOEX osvi;
    ZeroMemory(&osvi, sizeof(OSVERSIONINFOEX));
    osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
#pragma warning(suppress : 4996)
    if (GetVersionEx(reinterpret_cast<LPOSVERSIONINFO>(&osvi)) == 0) {
      // todo add error
      return;
    }

    result->Success(flutter::EncodableValue(flutter::EncodableMap{
        {flutter::EncodableValue("major"),
         flutter::EncodableValue(static_cast<int>(osvi.dwMajorVersion))},
        {flutter::EncodableValue("minor"),
         flutter::EncodableValue(static_cast<int>(osvi.dwMinorVersion))},
        {flutter::EncodableValue("build"),
         flutter::EncodableValue(static_cast<int>(osvi.dwBuildNumber))},
        {flutter::EncodableValue("platformId"),
         flutter::EncodableValue(static_cast<int>(osvi.dwPlatformId))},
        {flutter::EncodableValue("isServer"),
         flutter::EncodableValue(static_cast<bool>(IsWindowsServer()))},
    }));
  } else if (method_call.method_name().compare(kSetWindowIconAndCationVisibility) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());
    bool visible = std::get<bool>(args.at(flutter::EncodableValue("visibility")));

    WTA_OPTIONS opt;
    opt.dwFlags = WTNCA_NODRAWICON | WTNCA_NODRAWCAPTION;
    if (visible) {
      opt.dwMask = 0;
    } else {
      opt.dwMask = WTNCA_NODRAWICON | WTNCA_NODRAWCAPTION;
    }
    ::SetWindowThemeAttribute(root_window_, WTA_NONCLIENT, &opt, sizeof(WTA_OPTIONS));

    result->Success();
  } else if (method_call.method_name().compare(kSetWindowCation) == 0) {
    result->Success();
  } else if (method_call.method_name().compare(kGetWindowMinSize) == 0) {
    result->Success(flutter::EncodableValue(flutter::EncodableMap{
        {flutter::EncodableValue("width"),
         flutter::EncodableValue(static_cast<double>(min_wnd_size_.x))},
        {flutter::EncodableValue("height"),
         flutter::EncodableValue(static_cast<double>(min_wnd_size_.y))},
    }));
  } else if (method_call.method_name().compare(kSetWindowMinSize) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());

    double devicePixelRatio = std::get<double>(args.at(flutter::EncodableValue("dpr")));
    double width = std::get<double>(args.at(flutter::EncodableValue("width")));
    double height = std::get<double>(args.at(flutter::EncodableValue("height")));

    if (width >= 0 && height >= 0) {
      POINT point = {};
      point.x = static_cast<LONG>(width * devicePixelRatio);
      point.y = static_cast<LONG>(height * devicePixelRatio);
      min_wnd_size_ = point;
    }
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kResetWindowMinSize) == 0) {
    min_wnd_size_ = {0, 0};
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kGetWindowMaxSize) == 0) {
    result->Success(flutter::EncodableValue(flutter::EncodableMap{
        {flutter::EncodableValue("width"),
         flutter::EncodableValue(static_cast<double>(max_wnd_size_.x))},
        {flutter::EncodableValue("height"),
         flutter::EncodableValue(static_cast<double>(max_wnd_size_.y))},
    }));
  } else if (method_call.method_name().compare(kSetWindowMaxSize) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());

    double devicePixelRatio = std::get<double>(args.at(flutter::EncodableValue("dpr")));
    double width = std::get<double>(args.at(flutter::EncodableValue("width")));
    double height = std::get<double>(args.at(flutter::EncodableValue("height")));

    if (width >= 0 && height >= 0) {
      POINT point = {};
      point.x = static_cast<LONG>(width * devicePixelRatio);
      point.y = static_cast<LONG>(height * devicePixelRatio);
      max_wnd_size_ = point;
    }

    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kResetWindowMaxSize) == 0) {
    max_wnd_size_ = {-1, -1};
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kSetWindowSize) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());

    double devicePixelRatio = std::get<double>(args.at(flutter::EncodableValue("dpr")));
    double width = std::get<double>(args.at(flutter::EncodableValue("width")));
    double height = std::get<double>(args.at(flutter::EncodableValue("height")));

    LONG new_width = static_cast<LONG>(width * devicePixelRatio);
    LONG new_height = static_cast<LONG>(height * devicePixelRatio);

    if (::SetWindowPos(root_window_, HWND_TOP, 0, 0, new_width, new_height, SWP_NOMOVE)) {
      InvokeMethod("onWindowSize", flutter::EncodableValue(true));
    }

    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kIsWindowMinimized) == 0) {
    bool isMinimized = IsIconic(root_window_);
    result->Success(flutter::EncodableValue(isMinimized));
  } else if (method_call.method_name().compare(kSetWindowMinimized) == 0) {
    ::GetWindowPlacement(root_window_, &window_placement_);
    if (window_placement_.showCmd != SW_SHOWMINIMIZED) {
      ::PostMessage(root_window_, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    }
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kIsWindowMaximized) == 0) {
    bool isMaximized = IsZoomed(root_window_);
    result->Success(flutter::EncodableValue(isMaximized));
  } else if (method_call.method_name().compare(kSetWindowMaximized) == 0) {
    if (root_window_ == nullptr) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    ::GetWindowPlacement(root_window_, &window_placement_);
    if (window_placement_.showCmd != SW_MAXIMIZE) {
      ::PostMessage(root_window_, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    }
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kSetWindowRestore) == 0) {
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kIsWindowResizable) == 0) {
    result->Success(flutter::EncodableValue(is_wnd_resizable_));
  } else if (method_call.method_name().compare(kSetWindowResizable) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());
    bool is_window_resizable = std::get<bool>(args.at(flutter::EncodableValue("resizable")));
    is_wnd_resizable_ = is_window_resizable;
    result->Success();
  } else if (method_call.method_name().compare(kIsWindowMinimizable) == 0) {
    DWORD style = GetWindowLong(root_window_, GWL_STYLE);
    bool is_minimizable = (style & WS_MINIMIZEBOX) != 0;
    result->Success(flutter::EncodableValue(is_minimizable));
  } else if (method_call.method_name().compare(kSetWindowMinimizable) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());
    bool is_minimizable = std::get<bool>(args.at(flutter::EncodableValue("minimizable")));

    DWORD style = GetWindowLong(root_window_, GWL_STYLE);
    style = is_minimizable ? style | WS_MINIMIZEBOX : style & ~WS_MINIMIZEBOX;
    ::SetWindowLong(root_window_, GWL_STYLE, style);

    result->Success();

    //  todo not working. Fix or remove.
    // } else if (method_call.method_name().compare(kIsWindowMaximizable) == 0) {
    //   result->Success();

    // } else if (method_call.method_name().compare(kSetWindowMaximizable) == 0) {
    //   const flutter::EncodableMap& args =
    //   std::get<flutter::EncodableMap>(*method_call.arguments()); bool is_maximizable =
    //   std::get<bool>(args.at(flutter::EncodableValue("maximizable")));

    //   DWORD style = GetWindowLong(root_window_, GCL_STYLE);
    //   style = is_maximizable ? style | WS_MAXIMIZEBOX : style & ~WS_MAXIMIZEBOX;
    //   ::SetWindowLongPtr(root_window_, GWL_STYLE, style);

    //   result->Success();
  } else if (method_call.method_name().compare(kIsWindowClosable) == 0) {
    result->Success();
  } else if (method_call.method_name().compare(kSetWindowClosable) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());
    bool is_closable = std::get<bool>(args.at(flutter::EncodableValue("closable")));

    DWORD style = GetClassLong(root_window_, GCL_STYLE);
    style = is_closable ? style & ~CS_NOCLOSE : style | CS_NOCLOSE;
    ::SetClassLong(root_window_, GCL_STYLE, style);

    result->Success();
  } else if (method_call.method_name().compare(kGetThemeMode) == 0) {
    // todo
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kSetThemeMode) == 0) {
    const flutter::EncodableMap& args = std::get<flutter::EncodableMap>(*method_call.arguments());

    int theme_mode = std::get<int>(args.at(flutter::EncodableValue("themeMode")));

    enum class DWM_BOOL { kFalse, kTrue };

    switch (theme_mode) {
      // system
      case 0: {
        // Windows 10+
        if (::IsWindows10OrGreater()) {
          bool is_dark_ = isDarkTheme();

          COLORREF captionColor = is_dark_ ? kDARK_CAPTION_COLOR : kLIGHT_CAPTION_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_CAPTION_COLOR, &captionColor,
                                  sizeof(captionColor));

          COLORREF titleColor = is_dark_ ? kDARK_TITLE_COLOR : kLIGHT_TITLE_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_TEXT_COLOR, &titleColor, sizeof(titleColor));

          COLORREF borderColor = is_dark_ ? kDARK_BORDER_COLOR : kLIGHT_BORDER_COLOR;

          ::DwmSetWindowAttribute(root_window_, kDWMWA_BORDER_COLOR, &borderColor,
                                  sizeof(borderColor));

          DWM_BOOL darkPreference = is_dark_ ? DWM_BOOL::kFalse : DWM_BOOL::kTrue;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_USE_IMMERSIVE_DARK_MODE, &darkPreference,
                                  sizeof(darkPreference));
        }
        break;
      }
      // light
      case 1: {
        // Windows 10+
        if (IsWindows10OrGreater()) {
          COLORREF captionColor = kLIGHT_CAPTION_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_CAPTION_COLOR, &captionColor,
                                  sizeof(captionColor));

          COLORREF titleColor = kLIGHT_TITLE_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_TEXT_COLOR, &titleColor, sizeof(titleColor));

          COLORREF borderColor = kLIGHT_BORDER_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_BORDER_COLOR, &borderColor,
                                  sizeof(borderColor));

          DWM_BOOL darkPreference = DWM_BOOL::kTrue;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_USE_IMMERSIVE_DARK_MODE, &darkPreference,
                                  sizeof(darkPreference));
        }
        break;
      }
      // dark
      case 2: {
        // Windows 10+
        if (IsWindows10OrGreater()) {
          COLORREF captionColor = kDARK_CAPTION_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_CAPTION_COLOR, &captionColor,
                                  sizeof(captionColor));

          COLORREF titleColor = kDARK_TITLE_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_TEXT_COLOR, &titleColor, sizeof(titleColor));

          COLORREF borderColor = kDARK_BORDER_COLOR;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_BORDER_COLOR, &borderColor,
                                  sizeof(borderColor));

          DWM_BOOL darkPreference = DWM_BOOL::kFalse;
          ::DwmSetWindowAttribute(root_window_, kDWMWA_USE_IMMERSIVE_DARK_MODE, &darkPreference,
                                  sizeof(darkPreference));

          InvokeMethod("onThemeModeChanged", flutter::EncodableValue(true));
        }
        break;
      }
    }

    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare("minimize") == 0) {
    ::GetWindowPlacement(root_window_, &window_placement_);
    if (window_placement_.showCmd != SW_SHOWMINIMIZED) {
      PostMessage(root_window_, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    }
    result->Success(flutter::EncodableValue(true));
    // todo remove code
    // } else if (method_call.method_name().compare(kGetContentProtection) == 0) {
    //   // Retrieves the current display affinity setting, from any process, for a given window.
    //   //
    //   https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowdisplayaffinity

    //   DWORD dwa;
    //   if (!GetWindowDisplayAffinity(root_window_, &dwa)) {
    //     result->Success(flutter::EncodableValue(false));
    //     return;
    //   }
    //   if (dwa == WDA_MONITOR || dwa == WDA_EXCLUDEFROMCAPTURE) {
    //     result->Success(flutter::EncodableValue(true));
    //   } else {
    //     result->Success(flutter::EncodableValue(false));
    //   }
  } else if (method_call.method_name().compare("maximize") == 0) {
    if (root_window_ == nullptr) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    ::GetWindowPlacement(root_window_, &window_placement_);
    if (window_placement_.showCmd != SW_MAXIMIZE) {
      ::PostMessage(root_window_, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    }
    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare(kGetContentProtection) == 0) {
    // Retrieves the current display affinity setting, from any process, for a given window.
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowdisplayaffinity

    DWORD windowDisplayAffinity;
    if (!GetWindowDisplayAffinity(root_window_, &windowDisplayAffinity)) {
      result->Success(flutter::EncodableValue(nullptr));
      return;
    }

    if (windowDisplayAffinity == WDA_NONE) {
      result->Success(flutter::EncodableValue(static_cast<int>(WDA_NONE)));
    } else if (windowDisplayAffinity == WDA_MONITOR) {
      result->Success(flutter::EncodableValue(static_cast<int>(WDA_MONITOR)));
    } else if (windowDisplayAffinity == WDA_EXCLUDEFROMCAPTURE) {
      result->Success(flutter::EncodableValue(static_cast<int>(WDA_EXCLUDEFROMCAPTURE)));
    } else {
      result->Success(flutter::EncodableValue(nullptr));
    }

    // switch (windowDisplayAffinity) {
    //   case WDA_NONE: {
    //     result->Success(flutter::EncodableValue(static_cast<int>(WDA_NONE)));
    //     return;
    //   }
    //   case WDA_MONITOR: {
    //     result->Success(flutter::EncodableValue(static_cast<int>(WDA_MONITOR)));
    //     return;
    //   }
    //   case WDA_EXCLUDEFROMCAPTURE: {
    //     result->Success(flutter::EncodableValue(static_cast<int>(WDA_EXCLUDEFROMCAPTURE)));
    //     return;
    //   }
    //   default: {
    //     result->Success(flutter::EncodableValue(nullptr));
    //     return;
    //   }
    // }
  } else if (method_call.method_name().compare(kSetContentProtection) == 0) {
    // Specifies where the content of the window can be displayed.
    // https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowdisplayaffinity

    auto methodArguments = std::get<flutter::EncodableMap>(*method_call.arguments());
    auto value = std::get<int32_t>(methodArguments[flutter::EncodableValue("value")]);

    if (value == WDA_NONE) {
      if (::SetWindowDisplayAffinity(root_window_, WDA_NONE)) {
        InvokeMethod("onContentProtectionChanged",
                     flutter::EncodableValue(static_cast<int>(WDA_NONE)));
      }
      // if (!SetWindowDisplayAffinity(root_window_, WDA_NONE)) {
      //   InvokeMethod("onContentProtectionError",
      //                flutter::EncodableValue(static_cast<int>(WDA_NONE)));
      // }
    } else if (value == WDA_MONITOR || value == 1) {
      ::SetWindowDisplayAffinity(root_window_, WDA_NONE);
      if (::SetWindowDisplayAffinity(root_window_, WDA_MONITOR)) {
        InvokeMethod("onContentProtectionChanged",
                     flutter::EncodableValue(static_cast<int>(WDA_MONITOR)));
      }
      // if (!SetWindowDisplayAffinity(root_window_, WDA_MONITOR)) {
      //   InvokeMethod("onContentProtectionError",
      //                flutter::EncodableValue(static_cast<int>(WDA_MONITOR)));
      // }
    } else if (value == WDA_EXCLUDEFROMCAPTURE) {
      ::SetWindowDisplayAffinity(root_window_, WDA_NONE);
      if (::SetWindowDisplayAffinity(root_window_, WDA_EXCLUDEFROMCAPTURE)) {
        InvokeMethod("onContentProtectionChanged",
                     flutter::EncodableValue(static_cast<int>(WDA_EXCLUDEFROMCAPTURE)));
      }

      // if (!SetWindowDisplayAffinity(root_window_, WDA_EXCLUDEFROMCAPTURE)) {
      //   InvokeMethod("onContentProtectionError",
      //                flutter::EncodableValue(static_cast<int>(WDA_EXCLUDEFROMCAPTURE)));
      // }
    }

    result->Success(flutter::EncodableValue(true));
  } else {
    result->NotImplemented();
  }
}

// https://docs.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues#system-defined-messages
std::optional<LRESULT> DwmPlugin::HandleWindowProc(HWND hwnd,
                                                   UINT message,
                                                   WPARAM wparam,
                                                   LPARAM lparam) noexcept {
  std::optional<LRESULT> result = std::nullopt;
  if (message == WM_ERASEBKGND) {
    return 1;
  } else if (message == WM_GETMINMAXINFO) {
    MINMAXINFO* minMaxInfo = reinterpret_cast<MINMAXINFO*>(lparam);

    if (min_wnd_size_.x != 0) {
      minMaxInfo->ptMinTrackSize.x = min_wnd_size_.x;
    }
    if (min_wnd_size_.y != 0) {
      minMaxInfo->ptMinTrackSize.y = min_wnd_size_.y;
    }

    if (max_wnd_size_.x != -1) {
      minMaxInfo->ptMaxTrackSize.x = max_wnd_size_.x;
    }
    if (max_wnd_size_.y != -1) {
      minMaxInfo->ptMaxTrackSize.y = max_wnd_size_.y;
    }

    return 0;
    // } else if (message == WM_DPICHANGED) {
    // todo
  } else if (message == WM_NCHITTEST) {
    if (!is_wnd_resizable_) {
      return HTNOWHERE;
    }
  } else if (message == WM_NCACTIVATE) {
    // Sent to a window when its nonclient area needs to be changed to indicate an active or
    // inactive state.
    // https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-ncactivate
    if (wparam == TRUE) {
      InvokeMethod("onWindowState", flutter::EncodableValue(true));
    } else {
      InvokeMethod("onWindowState", flutter::EncodableValue(false));
    }
  } else if (message == WM_SETTINGCHANGE) {
    if (!lstrcmp(reinterpret_cast<LPCTSTR>(lparam), L"ImmersiveColorSet")) {
      InvokeMethod("onThemeChanged", flutter::EncodableValue(true));
    }
    // } else if (message == WDA_NONE) {
    //   InvokeMethod("onContentProtectionChanged",
    //                flutter::EncodableValue(static_cast<int>(WDA_MONITOR)));
    //   return 0;
    // } else if (message == WDA_MONITOR) {
    //   InvokeMethod("onContentProtectionChanged",
    //                flutter::EncodableValue(static_cast<int>(WDA_MONITOR)));
    //   return 0;
    // } else if (message == WDA_EXCLUDEFROMCAPTURE) {
    //   InvokeMethod("onContentProtectionChanged",
    //                flutter::EncodableValue(static_cast<int>(WDA_EXCLUDEFROMCAPTURE)));
    //   return 0;
  } else if (message == WM_SIZE) {
    if (wparam == SIZE_RESTORED) {
      is_wnd_maximized_ = false;
      is_wnd_minimized_ = false;

      if (is_wnd_maximized_) {
        InvokeMethod("onWindowUnmaximized", flutter::EncodableValue(true));
      } else if (is_wnd_minimized_) {
        InvokeMethod("onWindowRestored", flutter::EncodableValue(true));
      }
    } else if (wparam == SIZE_MINIMIZED) {
      is_wnd_maximized_ = true;
      is_wnd_minimized_ = false;
      InvokeMethod("onWindowMinimized", flutter::EncodableValue(true));
    } else if (wparam == SIZE_MAXIMIZED) {
      is_wnd_maximized_ = false;
      is_wnd_minimized_ = true;
      InvokeMethod("onWindowMaximized", flutter::EncodableValue(true));
    } else {
      UINT width = LOWORD(lparam);
      UINT height = HIWORD(lparam);

      InvokeMethod(
          "onWindowResized",
          flutter::EncodableValue(flutter::EncodableValue(flutter::EncodableMap{
              {flutter::EncodableValue("width"), flutter::EncodableValue(static_cast<int>(width))},
              {flutter::EncodableValue("height"),
               flutter::EncodableValue(static_cast<int>(height))},
          })));

      return 0;
    }
  } else if (message == WM_SYSCOMMAND) {
    if (wparam == SC_MINIMIZE) {
      InvokeMethod("onWindowMinimizable", flutter::EncodableValue(""));
    } else if (wparam == SC_MAXIMIZE) {
    } else if (wparam == SC_RESTORE) {
    }
    return DefWindowProc(hwnd, message, wparam, lparam);
  } else if (message == WM_DESTROY) {
    // https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-destroy
    InvokeMethod("onDestroy", flutter::EncodableValue(true));
    root_window_ = nullptr;
    PostQuitMessage(0);
  }
  return result;
}

}  // namespace dwm
