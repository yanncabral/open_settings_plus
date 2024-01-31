import 'dart:io';

import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';

part 'open_settings_plus_android.dart';
part 'open_settings_plus_ios.dart';

/// {@template open_settings_plus}
/// Singleton used to create a [OpenSettingsPlus] instance.
/// You can get iOS or android instance of [OpenSettingsPlus] using this class.
/// {@endtemplate}
class OpenSettingsPlus {
  /// {@macro open_settings_plus}
  const OpenSettingsPlus();

  /// Returns a singleton instance of [OpenSettingsPlus] for iOS.
  const factory OpenSettingsPlus.iOS() = OpenSettingsPlusIOS;

  /// Returns a singleton instance of [OpenSettingsPlus] for android.
  const factory OpenSettingsPlus.android() = OpenSettingsPlusAndroid;

  /// {@macro open_settings_plus_core}
  static OpenSettingsPlus? build() {
    if (Platform.isAndroid) {
      return const OpenSettingsPlus.android();
    } else if (Platform.isIOS) {
      return const OpenSettingsPlus.iOS();
    } else {
      return null;
    }
  }

  /// Singleton instance of [OpenSettingsPlus].
  /// You can use this instance to open settings in iOS or android.
  static final OpenSettingsPlus? shared = OpenSettingsPlus.build();

  /// Method used to pass custom message to native side.
  Future<bool> sendCustomMessage(String message) {
    return OpenSettingsPlusPlatform.instance.sendMessageToNative(message);
  }
}
