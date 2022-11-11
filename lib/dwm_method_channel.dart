import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dwm.dart';
import 'dwm_platform_interface.dart';

/// An implementation of [DwmPlatform] that uses method channels.
class MethodChannelDwm extends DwmPlatform {
  static const channelName = 'flutter/dwm';

  static const ensureInitializedMethod = 'ensureInitialized';

  static const getPlatformVersionMethod = 'getPlatformVersion';

  static const kSetWindowIconAndCationVisibility = 'setWindowIconAndCationVisibility';

  static const setWindowCationMethod = 'setWindowCation';

  static const getWindowMinSizeMethod = 'getWindowMinSize';
  static const setWindowMinSizeMethod = 'setWindowMinSize';
  static const resetWindowMinSizeMethod = 'resetWindowMinSize';

  static const getWindowMaxSizeMethod = 'getWindowMaxSize';
  static const setWindowMaxSizeMethod = 'setWindowMaxSize';
  static const resetWindowMaxSizeMethod = 'removeWindowMaxSize';

  static const setWindowSizeMethod = 'setWindowSize';

  static const isWindowMinimizedMethod = 'isWindowMinimized';
  static const setWindowMinimizedMethod = 'setWindowMinimized';

  static const isWindowMaximizedMethod = 'isWindowMaximized';
  static const setWindowMaximizedMethod = 'setWindowMaximized';

  static const setWindowRestoreMethod = 'setWindowRestore';

  static const isWindowResizableMethod = 'isWindowResizable';
  static const setWindowResizableMethod = 'setWindowResizable';

  static const isWindowMinimizableMethod = 'isWindowMinimizable';
  static const setWindowMinimizableMethod = 'setWindowMinimizable';

  static const isWindowMaximizableMethod = 'isWindowMaximizable';
  static const setWindowMaximizableMethod = 'setWindowMaximizable';

  static const isWindowClosableMethod = 'isWindowClosable';
  static const setWindowClosableMethod = 'setWindowClosable';

  static const setColorSchemeMethod = 'setColorScheme';

  static const getThemeModeMethod = 'getThemeMode';
  static const setThemeModeMethod = 'setThemeMode';

  static const setWindowCornerPreferenceMethod = 'setWindowCornerPreference';

  static const setDarkCaptionColorMethod = 'setDarkCaptionColor';

  static const getContentProtectionMethod = 'getContentProtection';
  static const setContentProtectionMethod = 'setContentProtection';

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(channelName);

  MethodChannelDwm() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  /// [ensureInitialized] Initialize the dwm plugin.
  @override
  Future<bool> ensureInitialized() async {
    return await methodChannel.invokeMethod(ensureInitializedMethod) ?? false;
  }

  /// Store event listenters.
  final ObserverList<DwmListener> _listeners = ObserverList<DwmListener>();

  /// Checks whether any assigned event listeners.
  bool get hasListeners => _listeners.isNotEmpty;

  /// Get a list of assigned event listeners.
  List<DwmListener> get listeners => _listeners.toList(growable: false);

  /// Add an event listener.
  @override
  void addListener(DwmListener listener) {
    _listeners.add(listener);
  }

  /// Removes an event listener.
  @override
  void removeListener(DwmListener listener) {
    _listeners.remove(listener);
  }

  /// [getPlatformVersion]
  @override
  Future<DwmPlatformVersion> get getPlatformVersion async {
    final version = await methodChannel.invokeMethod(getPlatformVersionMethod);
    return DwmPlatformVersion(
      major: version['major'] ?? 0,
      minor: version['minor'] ?? 0,
      build: version['build'] ?? 0,
      platformId: version['platformId'] ?? 0,
      isServer: version['isServer'] ?? false,
    );
  }

  @override
  Future<void> setWindowIconAndCationVisibility(bool visibility) async {
    await methodChannel.invokeMethod('setWindowIconAndCationVisibility', <String, dynamic>{
      'visibility': visibility,
    });
  }

  @override
  Future<void> setWindowCation(String caption) async {
    await methodChannel.invokeMethod(setWindowCationMethod, <String, dynamic>{
      'caption': caption,
    });
  }

  /// [getWindowMinSize]
  @override
  Future<Size> get getWindowMinSize async {
    final result = Map<String, double>.from(await methodChannel.invokeMethod(getWindowMinSizeMethod));
    final width = result['width'] ?? 0.0;
    final height = result['height'] ?? 0.0;
    return Size(width, height);
  }

  /// [setWindowMinSize] Set the minimum window size.
  @override
  Future<void> setWindowMinSize(Size size) async {
    await methodChannel.invokeMethod(setWindowMinSizeMethod, <String, dynamic>{
      'dpr': window.devicePixelRatio,
      'width': size.width,
      'height': size.height,
    });
  }

  /// [setWindowMinSize] Set the minimum window size.
  @override
  Future<void> resetWindowMinSize() async {
    await methodChannel.invokeMethod(resetWindowMinSizeMethod);
  }

  /// Get the maximum windows size.
  @override
  Future<Size> get getWindowMaxSize async {
    final out = await methodChannel.invokeMethod(getWindowMaxSizeMethod);
    final result = Map<String, double>.from(out);

    final width = result['width'] ?? 0.0;
    final height = result['height'] ?? 0.0;

    return Size(width, height);
  }

  /// [setWindowMaxSize] Set the maximum window size.
  @override
  Future<void> setWindowMaxSize(Size size) async {
    await methodChannel.invokeMethod(setWindowMaxSizeMethod, <String, dynamic>{
      'dpr': window.devicePixelRatio,
      'width': size.width,
      'height': size.height,
    });
  }

  /// [setWindowMaxSize] Set the maximum window size.
  @override
  Future<void> resetWindowMaxSize() async {
    await methodChannel.invokeMethod(resetWindowMaxSizeMethod);
  }

  /// [setWindowSize] Set the window size.
  @override
  Future<void> setWindowSize(Size size) async {
    await methodChannel.invokeMethod(setWindowSizeMethod, <String, dynamic>{
      'dpr': window.devicePixelRatio,
      'width': size.width,
      'height': size.height,
    });
  }

  ///
  @override
  Future<bool> get isWindowMinimized async {
    return await methodChannel.invokeMethod(isWindowMinimizedMethod);
  }

  ///
  @override
  Future<void> setWindowMinimized() async {
    await methodChannel.invokeMethod(setWindowMinimizedMethod);
  }

  ///
  @override
  Future<bool> get isWindowMaximized async {
    return await methodChannel.invokeMethod(isWindowMaximizedMethod);
  }

  ///
  @override
  Future<void> setWindowMaximized() async {
    await methodChannel.invokeMethod(setWindowMaximizedMethod);
  }

  ///
  @override
  Future<void> setWindowRestore() async {
    await methodChannel.invokeMethod(setWindowRestoreMethod);
  }

  ///
  @override
  Future<void> setWindowResizable(bool resizable) async {
    await methodChannel.invokeMethod(setWindowResizableMethod, <String, dynamic>{
      'resizable': resizable,
    });
  }

  ///
  @override
  Future<void> setWindowMinimizable(bool minimizable) async {
    await methodChannel.invokeMethod(setWindowMinimizableMethod, <String, dynamic>{
      'minimizable': minimizable,
    });
  }

  ///
  @override
  Future<void> setWindowMaximizable(bool maximizable) async {
    await methodChannel.invokeMethod(setWindowMaximizableMethod, <String, dynamic>{
      'maximizable': maximizable,
    });
  }

  /// [setWindowClosable]
  @override
  Future<void> setWindowClosable(bool closable) async {
    await methodChannel.invokeMethod(setWindowClosableMethod, <String, dynamic>{
      'closable': closable,
    });
  }

  ///
  @override
  Future<DwmColorScheme> get getColorScheme async {
    return const DwmColorScheme.dark();
  }

  /// [setColorScheme]
  @override
  Future<void> setColorScheme(DwmColorScheme colorScheme) async {
    final args = <String, dynamic>{
      'brightness': colorScheme.brightness.index,
      'border': colorScheme.border.value,
      'borderInactive': colorScheme.borderInactive.value,
      'caption': colorScheme.caption.value,
      'captionInactive': colorScheme.captionInactive.value,
      'text': colorScheme.text.value,
      'textInactive': colorScheme.textInactive.value,
    };
    await methodChannel.invokeMethod(setColorSchemeMethod, args);
  }

  /// [getThemeMode] Get the window theme mode.
  @override
  Future<DwmThemeMode> get getThemeMode async {
    final result = await methodChannel.invokeMethod(getThemeModeMethod);
    return DwmThemeMode.system;
  }

  /// [setThemeMode] Set the window theme mode.
  @override
  Future<void> setThemeMode(DwmThemeMode themeMode) async {
    await methodChannel.invokeMethod(setThemeModeMethod, <String, dynamic>{
      'themeMode': themeMode.index,
    });
  }

  /// [setWindowCornerPreference] Set the window corner preference.
  @override
  Future<void> setWindowCornerPreference(DwmWindowCornerPreference value) async {
    await methodChannel.invokeMethod(setWindowCornerPreferenceMethod, <String, dynamic>{
      'value': value.index,
    });
  }

  /// [getContentProtection] Retrieves the current display affinity setting, from any process, for a given window.
  @override
  Future<DwmDisplayAffinity?> get getContentProtection async {
    final result = await methodChannel.invokeMethod(getContentProtectionMethod);
    if (result == DwmDisplayAffinity.none.dword) {
      return DwmDisplayAffinity.none;
    } else if (result == DwmDisplayAffinity.monitor.dword) {
      return DwmDisplayAffinity.monitor;
    } else if (result == DwmDisplayAffinity.excludeFromCapture.dword) {
      return DwmDisplayAffinity.excludeFromCapture;
    }

    return null;
  }

  /// [setContentProtection] Specifies where the content of the window can be displayed.
  @override
  Future<void> setContentProtection(DwmDisplayAffinity value) async {
    await methodChannel.invokeMethod(setContentProtectionMethod, <String, dynamic>{
      'value': value.dword,
    });
  }

  /// Platform Method Call Handler
  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method.compareTo('onEvent') == 0) {
      final eventName = call.arguments['eventName'];
      final eventValue = call.arguments['eventValue'];

      if (listeners.isNotEmpty) {
        for (final DwmListener? listener in listeners) {
          if (listeners.contains(listener)) {
            if (listener is DwmWindowSizeListener) {
              if (eventName.compareTo('onWindowSize') == 0) {
                listener.onWindowSize();
              } else if (eventName.compareTo('onWindowResized') == 0) {
                listener.onWindowResized();
              }
            }

            if (listener is DwmWindowStateListener) {
              listener.onWindowState(eventValue);
            }

            if (listener is DwmThemeModeListener) {
              if (eventName.compareTo('onThemeModeChanged') == 0) {
                listener.onThemeModeChanged(eventValue);
              }
            }

            if (listener is DwmContentProtectionListener) {
              if (eventName.compareTo('onContentProtectionChanged') == 0) {
                final DwmDisplayAffinity displayAffinity = eventValue;
                listener.onContentProtectionChanged(DwmDisplayAffinity.none);
              }
            }
          }
        }
      }
    }
  }
}
