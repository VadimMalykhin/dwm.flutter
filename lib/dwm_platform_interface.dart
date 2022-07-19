import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dwm_listener.dart';
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

  /// Event Listenters.
  final ObserverList<DwmListener> _listeners = ObserverList<DwmListener>();

  bool get hasListeners => _listeners.isNotEmpty;

  List<DwmListener> get listeners => List<DwmListener>.from(_listeners);

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DwmPlatform] when
  /// they register themselves.
  static set instance(DwmPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static void addListener(DwmListener listener) {
    _instance._listeners.add(listener);
  }

  static void removeListener(DwmListener listener) {
    _instance._listeners.remove(listener);
  }

  Future<void> ensureInitialized() async {
    throw UnimplementedError('ensureInitialized() has not been implemented.');
  }

  Future<bool?> get getContentProtection async {
    throw UnimplementedError('getContentProtection has not been implemented.');
  }

  Future<void> setContentProtection(bool value) async {
    throw UnimplementedError('setContentProtection() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
