import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'open_settings_plus_example_method_channel.dart';

abstract class OpenSettingsPlusExamplePlatform extends PlatformInterface {
  /// Constructs a OpenSettingsPlusExamplePlatform.
  OpenSettingsPlusExamplePlatform() : super(token: _token);

  static final Object _token = Object();

  static OpenSettingsPlusExamplePlatform _instance = MethodChannelOpenSettingsPlusExample();

  /// The default instance of [OpenSettingsPlusExamplePlatform] to use.
  ///
  /// Defaults to [MethodChannelOpenSettingsPlusExample].
  static OpenSettingsPlusExamplePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpenSettingsPlusExamplePlatform] when
  /// they register themselves.
  static set instance(OpenSettingsPlusExamplePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
