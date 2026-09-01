
import 'open_settings_plus_example_platform_interface.dart';

class OpenSettingsPlusExample {
  Future<String?> getPlatformVersion() {
    return OpenSettingsPlusExamplePlatform.instance.getPlatformVersion();
  }
}
