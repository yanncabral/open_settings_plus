import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus/bridge/open_settings_plus_platform_interface.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

class _RecordingPlatform extends OpenSettingsPlusPlatform {
  String? message;
  bool? appSpecific;

  @override
  Future<bool> sendMessageToNative(String message) async {
    this.message = message;
    appSpecific = null;
    return true;
  }

  @override
  Future<bool> sendAndroidIntent(
    String action, {
    bool appSpecific = false,
    bool asAnotherTask = true,
  }) async {
    message = action;
    this.appSpecific = appSpecific;
    return true;
  }
}

void main() {
  late OpenSettingsPlusPlatform previous;
  late _RecordingPlatform platform;

  setUp(() {
    previous = OpenSettingsPlusPlatform.instance;
    platform = _RecordingPlatform();
    OpenSettingsPlusPlatform.instance = platform;
  });

  tearDown(() => OpenSettingsPlusPlatform.instance = previous);

  test(
    'Android current app settings and legacy details scope the package',
    () async {
      const settings = OpenSettingsPlusAndroid();
      for (final open in [
        settings.currentAppSettings,
        settings.applicationDetails,
      ]) {
        expect(await open(), isTrue);
        expect(
          platform.message,
          'android.settings.APPLICATION_DETAILS_SETTINGS',
        );
        expect(platform.appSpecific, isTrue);
      }
    },
  );

  test(
    'Android installed apps aliases retain the system-wide destination',
    () async {
      const settings = OpenSettingsPlusAndroid();
      for (final open in [
        settings.allAppSettings,
        // ignore: deprecated_member_use_from_same_package
        settings.appSettings,
        // ignore: deprecated_member_use_from_same_package
        settings.applicationSettings,
      ]) {
        expect(await open(), isTrue);
        expect(platform.message, 'android.settings.APPLICATION_SETTINGS');
        expect(platform.appSpecific, isNull);
      }
    },
  );

  test(
    'iOS current app settings and legacy alias use the public destination',
    () async {
      const settings = OpenSettingsPlusIOS();
      for (final open in [
        settings.currentAppSettings,
        // ignore: deprecated_member_use_from_same_package
        settings.appSettings,
      ]) {
        expect(await open(), isTrue);
        expect(platform.message, 'app-settings:');
      }
    },
  );

  test('iOS notifications use the native public-destination alias', () async {
    const settings = OpenSettingsPlusIOS();
    expect(await settings.appNotification(), isTrue);
    expect(platform.message, 'app-notification-settings:');
  });
}
