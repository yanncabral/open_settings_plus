import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpenSettingsPlusPlatform
    with MockPlatformInterfaceMixin
    implements OpenSettingsPlusPlatform {
  @override
  Future<bool> sendMessageToNative(String message) async {
    switch (message) {
      case 'wifi':
        return true;
      default:
        return false;
    }
  }
}

void main() {
  final OpenSettingsPlusPlatform initialPlatform =
      OpenSettingsPlusPlatform.instance;

  test('$MethodChannelOpenSettingsPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpenSettingsPlus>());
  });

  test('getPlatformVersion', () async {
    const openSettingsPlusPlugin = OpenSettingsPlus.iOS();
    MockOpenSettingsPlusPlatform fakePlatform = MockOpenSettingsPlusPlatform();
    OpenSettingsPlusPlatform.instance = fakePlatform;

    expect(await openSettingsPlusPlugin.sendCustomMessage('wifi'), true);
  });
}
