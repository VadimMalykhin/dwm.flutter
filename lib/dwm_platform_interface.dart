import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dwm.dart';
import 'dwm_method_channel.dart';

abstract class DwmPlatform extends PlatformInterface {
  /// Constructs a DwmPlatform.
  DwmPlatform() : super(token: _token);

  static final Object _token = Object();

  static DwmPlatform _instance = MethodChannelDwm();

  /// The default instance of [DwmPlatform] to use.
  ///
  /// Defaults to [MethodChannelDwm].
  static DwmPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DwmPlatform] when
  /// they register themselves.
  static set instance(DwmPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Store event listenters.
  final ObserverList<DwmListener> _listeners = ObserverList<DwmListener>();

  /// Checks whether any assigned event listeners.
  bool get hasListeners => _listeners.isNotEmpty;

  /// Get a list of assigned event listeners.
  List<DwmListener> get listeners => _listeners.toList(growable: false);

  /// Add an event listener.
  static void addListener(DwmListener listener) {
    _instance._listeners.add(listener);
  }

  /// Removes an event listener.
  static void removeListener(DwmListener listener) {
    _instance._listeners.remove(listener);
  }

  Future<bool> ensureInitialized() async {
    throw UnimplementedError('ensureInitialized() has not been implemented.');
  }

  Future<DwmPlatformVersion> get getPlatformVersion {
    throw UnimplementedError('platformVersion has not been implemented.');
  }

  Future<void> setWindowIconAndCationVisibility(bool visibility) async {
    throw UnimplementedError('setWindowIconAndCationVisibility() has not been implemented.');
  }

  Future<void> setWindowCation(String caption) async {
    throw UnimplementedError('setWindowCation() has not been implemented.');
  }

  Future<Size> get getWindowMinSize async {
    throw UnimplementedError('getMinWindowSize has not been implemented.');
  }

  Future<void> setWindowMinSize(Size size) async {
    throw UnimplementedError('setMinWindowSize() has not been implemented.');
  }

  Future<void> resetWindowMinSize() async {
    throw UnimplementedError('removeMinWindowSize() has not been implemented.');
  }

  Future<Size> get getWindowMaxSize async {
    throw UnimplementedError('getWindowMaxSize has not been implemented.');
  }

  Future<void> setWindowMaxSize(Size size) async {
    throw UnimplementedError('setWindowMaxSize() has not been implemented.');
  }

  Future<void> resetWindowMaxSize() async {
    throw UnimplementedError('removeWindowMaxSize() has not been implemented.');
  }

  Future<void> setWindowSize(Size size) async {
    throw UnimplementedError('setWindowSize() has not been implemented.');
  }

  Future<bool> get isWindowMinimized async {
    throw UnimplementedError('isMinimized has not been implemented.');
  }

  Future<void> setWindowMinimized() async {
    throw UnimplementedError('setWindowMinimized() has not been implemented.');
  }

  Future<bool> get isWindowMaximized async {
    throw UnimplementedError('isMaximized has not been implemented.');
  }

  Future<void> setWindowMaximized() async {
    throw UnimplementedError('setWindowMaximized() has not been implemented.');
  }

  Future<void> setWindowRestore() async {
    throw UnimplementedError('setWindowRestore() has not been implemented.');
  }

  Future<void> setWindowResizable(bool resizable) async {
    throw UnimplementedError('setWindowResizable() has not been implemented.');
  }

  Future<void> setWindowMinimizable(bool minimizable) async {
    throw UnimplementedError('setWindowMinimizable() has not been implemented.');
  }

  Future<void> setWindowMaximizable(bool maximizable) async {
    throw UnimplementedError('setWindowMaximizable() has not been implemented.');
  }

  Future<void> setWindowClosable(bool closable) async {
    throw UnimplementedError('setWindowClosable() has not been implemented.');
  }

  Future<DwmColorScheme> get getColorScheme async {
    throw UnimplementedError('getColorScheme has not been implemented.');
  }

  Future<void> setColorScheme(DwmColorScheme colorScheme) async {
    throw UnimplementedError('setColorScheme() has not been implemented.');
  }

  Future<DwmThemeMode> get getThemeMode async {
    throw UnimplementedError('getThemeMode has not been implemented.');
  }

  Future<void> setThemeMode(DwmThemeMode themeMode) async {
    throw UnimplementedError('setThemeMode() has not been implemented.');
  }

  Future<void> setWindowCornerPreference(DwmWindowCornerPreference value) async {
    throw UnimplementedError('setWindowCornerPreference() has not been implemented.');
  }

  Future<DwmDisplayAffinity?> get getContentProtection async {
    throw UnimplementedError('getContentProtection has not been implemented.');
  }

  Future<void> setContentProtection(DwmDisplayAffinity value) async {
    throw UnimplementedError('setContentProtection() has not been implemented.');
  }
}
