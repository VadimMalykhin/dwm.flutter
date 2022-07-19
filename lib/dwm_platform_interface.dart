import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
