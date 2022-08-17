import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'dwm_listener.dart';
import 'dwm_platform_interface.dart';
import 'dwm_platform_version.dart';

export 'dwm_listener.dart';
export 'dwm_platform_version.dart';

// todo
/// [DwmColorScheme]
class DwmColorScheme with Diagnosticable {
  /// The overall brightness of this color scheme.
  final Brightness brightness;

  final Color titleBar;

  DwmColorScheme({
    required this.brightness,
    required this.titleBar,
  });

  const DwmColorScheme.light({
    this.brightness = Brightness.light,
    this.titleBar = const Color(0xffcccccc),
  });

  const DwmColorScheme.dark({
    this.brightness = Brightness.dark,
    this.titleBar = const Color(0xff272727),
  });

  /// https://api.flutter.dev/flutter/material/ColorScheme/debugFillProperties.html
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const defaultScheme = DwmColorScheme.light();
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: defaultScheme.brightness));
    properties.add(ColorProperty('titleBar', titleBar, defaultValue: defaultScheme.titleBar));
  }
}

/// Describes which theme will be used by [MaterialApp].
enum DwmThemeMode {
  /// Use either the light or dark theme based on what the user has selected in the system settings.
  system,

  /// Always use the light mode regardless of system preference.
  light,

  /// Always use the dark mode (if available) regardless of system preference.
  dark,
}

// TODO
/// [WDA] Window Display Affinity.
///
/// https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowdisplayaffinity
enum DwmDisplayAffinity {
  /// Imposes no restrictions on where the window can be displayed.
  none,

  /// The window content is displayed only on a monitor. Everywhere else, the window appears with no content.
  monitor,

  /// The window is displayed only on a monitor. Everywhere else, the window does not appear at all.
  /// One use for this affinity is for windows that show video recording controls, so that the controls are not included in the capture.
  ///
  /// Introduced in Windows 10 Version 2004. See remarks about compatibility regarding previous versions of Windows.
  excludeFromCapture;

  /// Get the DWORD value
  int get dword {
    switch (this) {
      case DwmDisplayAffinity.none:
        return 0x00000000;
      case DwmDisplayAffinity.monitor:
        return 0x00000001;
      case DwmDisplayAffinity.excludeFromCapture:
        return 0x00000011;
    }
  }
}

/// Desktop Window Manager
class Dwm {
  /// [ensureInitialized] Initialize the dwm plugin.
  static Future<bool> ensureInitialized() async {
    return DwmPlatform.instance.ensureInitialized();
  }

  /// [addListener] Add the Event Listener.
  static void addListener(DwmListener listener) {
    return DwmPlatform.addListener(listener);
  }

  /// [removeListener] Remove the Event Listener.
  static void removeListener(DwmListener listener) {
    return DwmPlatform.removeListener(listener);
  }

  /// Get the platform version.
  static Future<DwmPlatformVersion> get getPlatformVersion async {
    return DwmPlatform.instance.getPlatformVersion;
  }

  ///
  static Future<void> setWindowIconAndCationVisibility(bool visibility) async {
    return DwmPlatform.instance.setWindowIconAndCationVisibility(visibility);
  }

  static Future<void> setWindowCation(String caption) async {
    return DwmPlatform.instance.setWindowCation(caption);
  }

  /// Get the minimum window size.
  static Future<Size> get getWindowMinSize async {
    return DwmPlatform.instance.getWindowMinSize;
  }

  /// [setWindowMinSize] Set the minimum window size.
  static Future<void> setWindowMinSize(Size size) async {
    return DwmPlatform.instance.setWindowMinSize(size);
  }

  /// [resetWindowMinSize] Reset the minimum window size.
  static Future<void> resetWindowMinSize() async {
    return DwmPlatform.instance.resetWindowMinSize();
  }

  /// Get the maximum window size.
  static Future<Size> get getWindowMaxSize async {
    return DwmPlatform.instance.getWindowMaxSize;
  }

  /// [setWindowMaxSize] Set the maximum window size.
  static Future<void> setWindowMaxSize(Size size) async {
    return DwmPlatform.instance.setWindowMaxSize(size);
  }

  /// [resetWindowMaxSize] Reset the maximum window size.
  static Future<void> resetWindowMaxSize() async {
    return DwmPlatform.instance.resetWindowMaxSize();
  }

  /// [setWindowSize] Set the window size.
  static Future<void> setWindowSize(Size size) async {
    return DwmPlatform.instance.setWindowSize(size);
  }

  /// Indicating whether the window is minimized.
  static Future<bool> get isWindowMinimized async {
    return DwmPlatform.instance.isWindowMinimized;
  }

  /// [setWindowMinimized]
  static Future<void> setWindowMinimized() async {
    return DwmPlatform.instance.setWindowMinimized();
  }

  /// [isWindowMaximized] Indicating whether the window is maximized.
  static Future<bool> get isWindowMaximized async {
    return DwmPlatform.instance.isWindowMaximized;
  }

  /// [setWindowMaximized]
  static Future<void> setWindowMaximized() async {
    return DwmPlatform.instance.setWindowMaximized();
  }

  ///
  static Future<void> setWindowRestore() async {
    return DwmPlatform.instance.setWindowRestore();
  }

  /// [setWindowResizable]
  static Future<void> setWindowResizable(bool resizable) async {
    return DwmPlatform.instance.setWindowResizable(resizable);
  }

  /// [setWindowMinimizable]
  static Future<void> setWindowMinimizable(bool minimizable) async {
    return DwmPlatform.instance.setWindowMinimizable(minimizable);
  }

  /// [setWindowMaximizable]
  // static Future<void> setWindowMaximizable(bool maximizable) async {
  //   return DwmPlatform.instance.setWindowMaximizable(maximizable);
  // }

  /// [setWindowClosable]
  static Future<void> setWindowClosable(bool closable) async {
    return DwmPlatform.instance.setWindowClosable(closable);
  }

  /// [getThemeMode] Get the window color scheme.
  static Future<DwmColorScheme> get getColorScheme async {
    return DwmPlatform.instance.getColorScheme;
  }

  /// [setColorScheme] Set the window color scheme.
  static Future<void> setColorScheme(DwmColorScheme colorScheme) async {
    return DwmPlatform.instance.setColorScheme(colorScheme);
  }

  /// [getThemeMode] Get the window theme mode.
  static Future<DwmThemeMode> get getThemeMode async {
    return DwmPlatform.instance.getThemeMode;
  }

  /// [setThemeMode] Set the window theme mode.
  static Future<void> setThemeMode(DwmThemeMode themeMode) async {
    return DwmPlatform.instance.setThemeMode(themeMode);
  }

  /// [getContentProtection] Retrieves the current display affinity setting, from any process, for a given window.
  // static Future<bool?> get getContentProtection async {
  //   return DwmPlatform.instance.getContentProtection;
  // }

  // /// [setContentProtection] Specifies where the content of the window can be displayed.
  // static Future<void> setContentProtection(bool value) async {
  //   return DwmPlatform.instance.setContentProtection(value);
  // }

  /// [getContentProtection] Retrieves the current display affinity setting, from any process, for a given window.
  static Future<DwmDisplayAffinity?> get getContentProtection async {
    return DwmPlatform.instance.getContentProtection;
  }

  static Future<void> setContentProtection(DwmDisplayAffinity value) async {
    return DwmPlatform.instance.setContentProtection(value);
  }
}
