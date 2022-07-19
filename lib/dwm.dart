
import 'dwm_platform_interface.dart';

class Dwm {
  Future<String?> getPlatformVersion() {
    return DwmPlatform.instance.getPlatformVersion();
  }
}
