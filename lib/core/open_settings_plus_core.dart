import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';

import '../android/open_settings_plus_android.dart';
import '../ios/open_settings_plus_ios.dart';

abstract class OpenSettingsPlus {
  const OpenSettingsPlus();
  const factory OpenSettingsPlus.iOS() = OpenSettingsPlusIOS;
  const factory OpenSettingsPlus.android() = OpenSettingsPlusAndroid;

  Future<bool> sendCustomMessage(String message) {
    return OpenSettingsPlusPlatform.instance.sendMessageToNative(message);
  }
}
