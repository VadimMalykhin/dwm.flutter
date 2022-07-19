import 'dwm_listener.dart';
import 'dwm_platform_interface.dart';

export './dwm_listener.dart';

class Dwm {
  /// [ensureInitialized]
  static Future<void> ensureInitialized() async {
    await DwmPlatform.instance.ensureInitialized();
  }

  /// [addListener] Add the Event Listener
  static void addListener(DwmListener listener) {
    DwmPlatform.addListener(listener);
  }

  /// [removeListener] Remove the Event Listener
  static void removeListener(DwmListener listener) {
    DwmPlatform.removeListener(listener);
  }

  /// [getContentProtection] Retrieves the current display affinity setting, from any process, for a given window.
  Future<bool?> get getContentProtection async {
    return DwmPlatform.instance.getContentProtection;
  }

  /// [setContentProtection] Specifies where the content of the window can be displayed.
  Future<void> setContentProtection(bool value) async {
    return DwmPlatform.instance.setContentProtection(value);
  }

  Future<String?> getPlatformVersion() {
    return DwmPlatform.instance.getPlatformVersion();
  }
}
