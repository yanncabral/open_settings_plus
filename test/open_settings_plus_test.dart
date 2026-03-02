import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_method_channel.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpenSettingsPlusPlatform
    with MockPlatformInterfaceMixin
    implements OpenSettingsPlusPlatform {
  String? lastCalled;

  @override
  Future<bool> sendMessageToNative(String message) async {
    lastCalled = message;
    return true;
  }
}

void main() {
  final initialPlatform = OpenSettingsPlusPlatform.instance;

  test('$MethodChannelOpenSettingsPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpenSettingsPlus>());
  });

  test('getPlatformVersion', () async {
    const openSettingsPlusPlugin = OpenSettingsPlus.iOS();
    final fakePlatform = MockOpenSettingsPlusPlatform();
    OpenSettingsPlusPlatform.instance = fakePlatform;

    expect(await openSettingsPlusPlugin.sendCustomMessage('wifi'), true);
    expect(fakePlatform.lastCalled, 'wifi');
  });

  test('android tether shortcut', () async {
    const settings = OpenSettingsPlusAndroid();
    final fakePlatform = MockOpenSettingsPlusPlatform();
    OpenSettingsPlusPlatform.instance = fakePlatform;

    expect(await settings.tether(), true);
    expect(fakePlatform.lastCalled, 'android.settings.TETHER_SETTINGS');
  });
}
