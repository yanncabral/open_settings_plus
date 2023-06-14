import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';

/// An implementation of [OpenSettingsPlusPlatform] that uses method channels.
class MethodChannelOpenSettingsPlus extends OpenSettingsPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_settings_plus');

  @override
  Future<bool> sendMessageToNative(String message) async {
    final success = await methodChannel.invokeMethod<bool>(
      'openSettings',
      {
        'settingToOpen': message,
      },
    );

    return success ?? false;
  }
}
