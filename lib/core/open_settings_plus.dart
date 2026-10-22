import 'dart:io';

import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/core/settings_open_result.dart';
import 'package:open_settings_plus/core/settings_target.dart';

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

  /// Opens a common settings destination on the current platform.
  ///
  /// On iOS, Wi-Fi, Bluetooth and location lack a public settings destination.
  /// They return [SettingsOpenResult.unsupported], or open this app's settings
  /// and return [SettingsOpenResult.fallbackOpened] when fallback is enabled.
  /// Opening settings never confirms a permission or preference change.
  static Future<SettingsOpenResult> open(
    SettingsTarget target, {
    bool asAnotherTask = true,
    bool fallbackToAppSettings = true,
  }) async =>
      await shared?.openTarget(
        target,
        asAnotherTask: asAnotherTask,
        fallbackToAppSettings: fallbackToAppSettings,
      ) ??
      SettingsOpenResult.unsupported;

  /// Opens a common destination using this instance's platform.
  ///
  /// [asAnotherTask] affects Android only. The base instance has no platform
  /// and returns [SettingsOpenResult.unsupported].
  Future<SettingsOpenResult> openTarget(
    SettingsTarget target, {
    bool asAnotherTask = true,
    bool fallbackToAppSettings = true,
  }) async {
    final String nativeTarget;
    var appSpecific = false;
    if (this is OpenSettingsPlusAndroid) {
      nativeTarget = switch (target) {
        SettingsTarget.appSettings =>
          'android.settings.APPLICATION_DETAILS_SETTINGS',
        SettingsTarget.notifications =>
          'android.settings.APP_NOTIFICATION_SETTINGS',
        SettingsTarget.wifi => 'android.settings.WIFI_SETTINGS',
        SettingsTarget.bluetooth => 'android.settings.BLUETOOTH_SETTINGS',
        SettingsTarget.location => 'android.settings.LOCATION_SOURCE_SETTINGS',
      };
      appSpecific =
          target == SettingsTarget.appSettings ||
          target == SettingsTarget.notifications;
    } else if (this is OpenSettingsPlusIOS) {
      nativeTarget = switch (target) {
        SettingsTarget.appSettings => 'app-settings:',
        SettingsTarget.notifications => 'app-notification-settings:',
        SettingsTarget.wifi => 'wifi',
        SettingsTarget.bluetooth => 'bluetooth',
        SettingsTarget.location => 'location',
      };
    } else {
      return SettingsOpenResult.unsupported;
    }
    return openSettingsTarget(
      nativeTarget,
      appSpecific: appSpecific,
      asAnotherTask: asAnotherTask,
      fallbackToAppSettings: fallbackToAppSettings,
    );
  }

  /// Opens a raw platform destination and reports exact opening or fallback.
  ///
  /// Android accepts intent actions, with [appSpecific] scoping the request to
  /// this app. iOS accepts URLs; experimental `App-prefs:` URLs are best effort
  /// and an accepted URL does not guarantee the requested section appeared.
  /// Prefer [openTarget] for common destinations backed by public APIs.
  Future<SettingsOpenResult> openSettingsTarget(
    String target, {
    bool appSpecific = false,
    bool asAnotherTask = true,
    bool fallbackToAppSettings = true,
  }) => OpenSettingsPlusPlatform.instance.openSettingsTarget(
    target,
    appSpecific: appSpecific,
    asAnotherTask: asAnotherTask,
    fallbackToAppSettings: fallbackToAppSettings,
  );

  /// Method used to pass custom message to native side.
  Future<bool> sendCustomMessage(String message) {
    return OpenSettingsPlusPlatform.instance.sendMessageToNative(message);
  }
}
