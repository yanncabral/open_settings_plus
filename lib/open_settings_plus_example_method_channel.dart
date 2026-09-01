import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'open_settings_plus_example_platform_interface.dart';

/// An implementation of [OpenSettingsPlusExamplePlatform] that uses method channels.
class MethodChannelOpenSettingsPlusExample extends OpenSettingsPlusExamplePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_settings_plus_example');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
