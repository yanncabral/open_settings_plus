import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'open_settings_plus_method_channel.dart';

abstract class OpenSettingsPlusPlatform extends PlatformInterface {
  /// Constructs a OpenSettingsPlusPlatform.
  OpenSettingsPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static OpenSettingsPlusPlatform _instance = MethodChannelOpenSettingsPlus();

  /// The default instance of [OpenSettingsPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelOpenSettingsPlus].
  static OpenSettingsPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpenSettingsPlusPlatform] when
  /// they register themselves.
  static set instance(OpenSettingsPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Method used to pass custom message to native side.
  /// This way we can pass any message to native side and handle it there.
  /// Note: android and ios have different implementation.
  Future<bool> sendMessageToNative(String message);
}
