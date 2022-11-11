import 'package:flutter/widgets.dart';

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

/// [DwmListeners] Widget
class DwmListeners extends StatefulWidget {
  final Function(bool state)? onWindowState;
  final VoidCallback? onWindowMinimized;
  final VoidCallback? onWindowMaximized;
  final Widget child;

  const DwmListeners({
    super.key,
    this.onWindowState,
    this.onWindowMinimized,
    this.onWindowMaximized,
    required this.child,
  });

  @override
  State<DwmListeners> createState() => _DwmListenersState();
}

class _DwmListenersState extends State<DwmListeners>
    with
        DwmWindowSizeListener,
        DwmWindowStateListener,
        DwmColorSchemeListener,
        DwmThemeModeListener,
        DwmContentProtectionListener {
  @override
  void onWindowMinimized() {
    if (widget.onWindowMinimized != null) {
      widget.onWindowMinimized!();
    }
  }

  @override
  void onWindowMaximized() {
    if (widget.onWindowMaximized != null) {
      widget.onWindowMaximized!();
    }
  }

  @override
  void onWindowState(bool state) {
    if (widget.onWindowState != null) {
      widget.onWindowState!(state);
    }
  }

  @override
  void initState() {
    super.initState();
    Dwm.addListener(this);
  }

  @override
  void dispose() {
    Dwm.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
