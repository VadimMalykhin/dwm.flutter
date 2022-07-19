import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dwm_platform_interface.dart';

/// An implementation of [DwmPlatform] that uses method channels.
class MethodChannelDwm extends DwmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dwm');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
