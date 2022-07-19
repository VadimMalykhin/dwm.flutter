import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dwm_listener.dart';
import 'dwm_platform_interface.dart';

/// An implementation of [DwmPlatform] that uses method channels.
class MethodChannelDwm extends DwmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dwm');

  MethodChannelDwm() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  /// [ensureInitialized]
  @override
  Future<void> ensureInitialized() async {
    await methodChannel.invokeMethod('ensureInitialized');
  }

  /// [getContentProtection] Retrieves the current display affinity setting, from any process, for a given window.
  @override
  Future<bool?> get getContentProtection async {
    return methodChannel.invokeMethod<bool>('getContentProtection');
  }

  /// [setContentProtection] Specifies where the content of the window can be displayed.
  @override
  Future<void> setContentProtection(bool value) async {
    await methodChannel.invokeMethod<bool>('setContentProtection', <String, dynamic>{
      'value': value,
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Platform Method Call Handler
  Future<void> _methodCallHandler(MethodCall call) async {
    if (listeners.isNotEmpty) {
      for (final DwmListener? listener in listeners) {
        if (listeners.contains(listener)) {
          if (call.method == 'onContentProtectionDisabled') {
            listener?.onContentProtectionDisabled();
          } else if (call.method == 'onContentProtectionEnabled') {
            listener?.onContentProtectionEnabled();
          }
        }
      }
    }
  }
}
