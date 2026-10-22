import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/core/settings_open_result.dart';

/// An implementation of [OpenSettingsPlusPlatform] that uses method channels.
class MethodChannelOpenSettingsPlus extends OpenSettingsPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_settings_plus');

  @override
  Future<bool> sendMessageToNative(String message) async {
    final success = await methodChannel.invokeMethod<bool>('openSettings', {
      'settingToOpen': message,
    });

    return success ?? false;
  }

  @override
  Future<bool> sendAndroidIntent(
    String action, {
    bool appSpecific = false,
    bool asAnotherTask = true,
  }) async {
    final success = await methodChannel
        .invokeMethod<bool>('openAndroidIntent', {
          'action': action,
          'appSpecific': appSpecific,
          if (!asAnotherTask) 'asAnotherTask': false,
        });
    return success ?? false;
  }

  @override
  Future<SettingsOpenResult> openSettingsTarget(
    String target, {
    bool appSpecific = false,
    bool asAnotherTask = true,
    bool fallbackToAppSettings = true,
  }) async {
    try {
      final status = await methodChannel
          .invokeMethod<Object?>('openSettingsDetailed', {
            'settingToOpen': target,
            'appSpecific': appSpecific,
            'asAnotherTask': asAnotherTask,
            'fallbackToAppSettings': fallbackToAppSettings,
          });
      return _parseResult(status);
    } on MissingPluginException {
      return SettingsOpenResult.unsupported;
    } on PlatformException {
      return SettingsOpenResult.failed;
    }
  }

  @override
  Future<SettingsOpenResult> openAndroidPanel(
    String panel, {
    bool asAnotherTask = false,
  }) async {
    try {
      final status = await methodChannel.invokeMethod<Object?>(
        'openAndroidPanel',
        {'panel': panel, 'asAnotherTask': asAnotherTask},
      );
      return _parseResult(status);
    } on MissingPluginException {
      return SettingsOpenResult.unsupported;
    } on PlatformException {
      return SettingsOpenResult.failed;
    }
  }

  static SettingsOpenResult _parseResult(Object? status) => switch (status) {
    'opened' => SettingsOpenResult.opened,
    'fallbackOpened' => SettingsOpenResult.fallbackOpened,
    'unsupported' => SettingsOpenResult.unsupported,
    _ => SettingsOpenResult.failed,
  };
}
