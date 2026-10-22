import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

class _RecordingPlatform extends OpenSettingsPlusPlatform {
  final calls = <Map<String, Object>>[];
  SettingsOpenResult result = SettingsOpenResult.opened;

  @override
  Future<bool> sendMessageToNative(String message) async => true;

  @override
  Future<SettingsOpenResult> openSettingsTarget(
    String target, {
    bool appSpecific = false,
    bool asAnotherTask = true,
    bool fallbackToAppSettings = true,
  }) async {
    calls.add({
      'target': target,
      'appSpecific': appSpecific,
      'asAnotherTask': asAnotherTask,
      'fallbackToAppSettings': fallbackToAppSettings,
    });
    return result;
  }
}

void main() {
  late OpenSettingsPlusPlatform previous;
  late _RecordingPlatform bridge;

  setUp(() {
    previous = OpenSettingsPlusPlatform.instance;
    bridge = _RecordingPlatform();
    OpenSettingsPlusPlatform.instance = bridge;
  });

  tearDown(() => OpenSettingsPlusPlatform.instance = previous);

  test(
    'Android common destinations use correct action and app scope',
    () async {
      const targets = {
        SettingsTarget.appSettings:
            'android.settings.APPLICATION_DETAILS_SETTINGS',
        SettingsTarget.notifications:
            'android.settings.APP_NOTIFICATION_SETTINGS',
        SettingsTarget.wifi: 'android.settings.WIFI_SETTINGS',
        SettingsTarget.bluetooth: 'android.settings.BLUETOOTH_SETTINGS',
        SettingsTarget.location: 'android.settings.LOCATION_SOURCE_SETTINGS',
      };
      const settings = OpenSettingsPlus.android();
      for (final target in targets.entries) {
        expect(
          await settings.openTarget(target.key),
          SettingsOpenResult.opened,
        );
        expect(bridge.calls.last, {
          'target': target.value,
          'appSpecific':
              target.key == SettingsTarget.appSettings ||
              target.key == SettingsTarget.notifications,
          'asAnotherTask': true,
          'fallbackToAppSettings': true,
        });
      }
    },
  );

  test(
    'iOS facade uses public URLs and symbolic unsupported targets',
    () async {
      const targets = {
        SettingsTarget.appSettings: 'app-settings:',
        SettingsTarget.notifications: 'app-notification-settings:',
        SettingsTarget.wifi: 'wifi',
        SettingsTarget.bluetooth: 'bluetooth',
        SettingsTarget.location: 'location',
      };
      bridge.result = SettingsOpenResult.fallbackOpened;
      const settings = OpenSettingsPlus.iOS();
      for (final target in targets.entries) {
        expect(
          await settings.openTarget(
            target.key,
            asAnotherTask: false,
            fallbackToAppSettings: false,
          ),
          SettingsOpenResult.fallbackOpened,
        );
        expect(bridge.calls.last, {
          'target': target.value,
          'appSpecific': false,
          'asAnotherTask': false,
          'fallbackToAppSettings': false,
        });
      }
    },
  );

  test(
    'raw detailed opening preserves caller target, options and outcome',
    () async {
      bridge.result = SettingsOpenResult.unsupported;
      expect(
        await const OpenSettingsPlus.android().openSettingsTarget(
          'custom.intent.SETTINGS',
          appSpecific: true,
          asAnotherTask: false,
          fallbackToAppSettings: false,
        ),
        SettingsOpenResult.unsupported,
      );
      expect(bridge.calls.single, {
        'target': 'custom.intent.SETTINGS',
        'appSpecific': true,
        'asAnotherTask': false,
        'fallbackToAppSettings': false,
      });
    },
  );

  test('base instance does not dispatch platform destinations', () async {
    expect(
      await const OpenSettingsPlus().openTarget(SettingsTarget.wifi),
      SettingsOpenResult.unsupported,
    );
    expect(bridge.calls, isEmpty);
  });

  test('static facade on unsupported host does not invoke bridge', () async {
    if (Platform.isAndroid || Platform.isIOS) return;
    expect(
      await OpenSettingsPlus.open(SettingsTarget.appSettings),
      SettingsOpenResult.unsupported,
    );
    expect(bridge.calls, isEmpty);
  });
}
