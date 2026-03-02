import 'package:flutter/services.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();

  final initialPlatform = OpenSettingsPlusPlatform.instance;
  const channel = MethodChannel('open_settings_plus');

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

  group('android intent channel', () {
    MethodCall? lastCall;

    setUp(() {
      lastCall = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        lastCall = call;
        return true;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('sendAndroidIntent sends system target', () async {
      const settings = OpenSettingsPlusAndroid();

      expect(
        await settings.sendAndroidIntent('android.settings.WIFI_SETTINGS'),
        true,
      );
      expect(lastCall?.method, 'openAndroidIntent');
      expect(lastCall?.arguments, {
        'action': 'android.settings.WIFI_SETTINGS',
        'appSpecific': false,
      });
    });

    test('sendAndroidAppIntent sends app target', () async {
      const settings = OpenSettingsPlusAndroid();

      expect(
        await settings.sendAndroidAppIntent(
          'android.settings.APPLICATION_DETAILS_SETTINGS',
        ),
        true,
      );
      expect(lastCall?.method, 'openAndroidIntent');
      expect(lastCall?.arguments, {
        'action': 'android.settings.APPLICATION_DETAILS_SETTINGS',
        'appSpecific': true,
      });
    });

    test('openByDefault uses app-specific action', () async {
      const settings = OpenSettingsPlusAndroid();

      expect(await settings.openByDefault(), true);
      expect(lastCall?.method, 'openAndroidIntent');
      expect(lastCall?.arguments, {
        'action': 'android.settings.APP_OPEN_BY_DEFAULT_SETTINGS',
        'appSpecific': true,
      });
    });

    test('appNotification uses app notification action', () async {
      const settings = OpenSettingsPlusAndroid();

      expect(await settings.appNotification(), true);
      expect(lastCall?.method, 'openAndroidIntent');
      expect(lastCall?.arguments, {
        'action': 'android.settings.APP_NOTIFICATION_SETTINGS',
        'appSpecific': true,
      });
    });

    test(
      'applicationNotification stays compatible with app notification action',
      () async {
        const settings = OpenSettingsPlusAndroid();

        // ignore: deprecated_member_use_from_same_package
        expect(await settings.applicationNotification(), true);
        expect(lastCall?.method, 'openAndroidIntent');
        expect(lastCall?.arguments, {
          'action': 'android.settings.APP_NOTIFICATION_SETTINGS',
          'appSpecific': true,
        });
      },
    );
  });
}
