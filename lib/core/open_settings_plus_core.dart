import 'package:open_settings_plus/android/open_settings_plus_android.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/ios/open_settings_plus_ios.dart';

/// {@template open_settings_plus_core}
/// Singleton used to create a [OpenSettingsPlus] instance.
/// You can get iOS or android instance of [OpenSettingsPlus] using this class.
/// {@endtemplate}
abstract class OpenSettingsPlus {
  /// {@macro open_settings_plus_core}
  const OpenSettingsPlus();

  /// Returns a singleton instance of [OpenSettingsPlus] for iOS.
  const factory OpenSettingsPlus.iOS() = OpenSettingsPlusIOS;

  /// Returns a singleton instance of [OpenSettingsPlus] for android.
  const factory OpenSettingsPlus.android() = OpenSettingsPlusAndroid;

  /// Method used to pass custom message to native side.
  Future<bool> sendCustomMessage(String message) {
    return OpenSettingsPlusPlatform.instance.sendMessageToNative(message);
  }
}
