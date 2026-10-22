import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_method_channel.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

class _LegacyPlatform extends OpenSettingsPlusPlatform {
  @override
  Future<bool> sendMessageToNative(String message) async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = MethodChannelOpenSettingsPlus();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('detailed opening passes target and explicit options', () async {
    messenger.setMockMethodCallHandler(platform.methodChannel, (call) async {
      expect(call.method, 'openSettingsDetailed');
      expect(call.arguments, {
        'settingToOpen': 'android.settings.APPLICATION_DETAILS_SETTINGS',
        'appSpecific': true,
        'asAnotherTask': false,
        'fallbackToAppSettings': false,
      });
      return 'fallbackOpened';
    });
    expect(
      await platform.openSettingsTarget(
        'android.settings.APPLICATION_DETAILS_SETTINGS',
        appSpecific: true,
        asAnotherTask: false,
        fallbackToAppSettings: false,
      ),
      SettingsOpenResult.fallbackOpened,
    );
  });

  for (final result in SettingsOpenResult.values) {
    test('parses native result ${result.name}', () async {
      messenger.setMockMethodCallHandler(
        platform.methodChannel,
        (_) async => result.name,
      );
      expect(await platform.openSettingsTarget('wifi'), result);
    });
  }

  for (final malformed in <Object?>[
    null,
    true,
    1,
    'unknown',
    {'opened': true},
  ]) {
    test('malformed result $malformed is a failure', () async {
      messenger.setMockMethodCallHandler(
        platform.methodChannel,
        (_) async => malformed,
      );
      expect(
        await platform.openSettingsTarget('wifi'),
        SettingsOpenResult.failed,
      );
    });
  }

  test('missing native detailed API is unsupported', () async {
    expect(
      await platform.openSettingsTarget('wifi'),
      SettingsOpenResult.unsupported,
    );
    expect(
      await platform.openAndroidPanel('wifi'),
      SettingsOpenResult.unsupported,
    );
  });

  test('native errors become failed results', () async {
    messenger.setMockMethodCallHandler(platform.methodChannel, (_) async {
      throw PlatformException(code: 'OPEN_FAILED');
    });
    expect(
      await platform.openSettingsTarget('wifi'),
      SettingsOpenResult.failed,
    );
    expect(await platform.openAndroidPanel('wifi'), SettingsOpenResult.failed);
  });

  test('Android panel forwards task option and native outcome', () async {
    messenger.setMockMethodCallHandler(platform.methodChannel, (call) async {
      expect(call.method, 'openAndroidPanel');
      expect(call.arguments, {'panel': 'wifi', 'asAnotherTask': false});
      return 'opened';
    });
    expect(await platform.openAndroidPanel('wifi'), SettingsOpenResult.opened);
  });

  test(
    'legacy intent keeps default payload and supports task option',
    () async {
      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(platform.methodChannel, (call) async {
        calls.add(call);
        return true;
      });
      expect(await platform.sendAndroidIntent('wifi'), isTrue);
      expect(calls.first.method, 'openAndroidIntent');
      expect(calls.first.arguments, {'action': 'wifi', 'appSpecific': false});
      expect(
        await platform.sendAndroidIntent(
          'app',
          appSpecific: true,
          asAnotherTask: false,
        ),
        isTrue,
      );
      expect(calls.last.arguments, {
        'action': 'app',
        'appSpecific': true,
        'asAnotherTask': false,
      });
    },
  );

  test('legacy subclasses inherit unsupported defaults for new APIs', () async {
    final legacy = _LegacyPlatform();
    expect(await legacy.sendMessageToNative('wifi'), isTrue);
    expect(await legacy.sendAndroidIntent('wifi'), isFalse);
    expect(
      await legacy.openSettingsTarget('wifi'),
      SettingsOpenResult.unsupported,
    );
    expect(
      await legacy.openAndroidPanel('wifi'),
      SettingsOpenResult.unsupported,
    );
  });
}
