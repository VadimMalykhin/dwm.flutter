import 'dwm.dart';

abstract class DwmListener {}

/// [DwmWindowSizeListener]
abstract class DwmWindowSizeListener implements DwmListener {
  /// [onWindowMinSize] Event
  void onWindowMinSize() {}

  /// [onWindowMaxSize] Event
  void onWindowMaxSize() {}

  /// [onWindowSize] Event
  void onWindowSize() {}

  /// [onWindowResized] Event
  void onWindowResized() {}
}

/// [DwmWindowStateListener]
abstract class DwmWindowStateListener implements DwmListener {
  /// [onWindowRestore]
  void onWindowRestored() {}

  /// [onWindowMinimized]
  void onWindowMinimized() {}

  /// [onWindowMaximized]
  void onWindowMaximized() {}

  /// [onWindowState] Indicates an active or inactive state.
  void onWindowState(bool state) {}
}

/// [DwmColorSchemeListener]
abstract class DwmColorSchemeListener implements DwmListener {
  /// [onColorSchemeChanged]
  void onColorSchemeChanged(DwmColorScheme colorScheme) {}
}

/// [DwmThemeModeListener]
abstract class DwmThemeModeListener implements DwmListener {
  /// [onThemeModeChanged]
  void onThemeModeChanged(DwmThemeMode themeMode) {}
}

/// [DwmContentProtectionListener]
abstract class DwmContentProtectionListener implements DwmListener {
  /// [onContentProtectionChanged]
  void onContentProtectionChanged(DwmDisplayAffinity displayAffinity) {}
}
