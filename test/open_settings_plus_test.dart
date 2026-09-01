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
  String iosVersion = '0.0';

  @override
  Future<bool> sendMessageToNative(String message) async {
    lastCalled = message;
    return true;
  }

  @override
  Future<String> getIOSVersion() async => iosVersion;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final initialPlatform = OpenSettingsPlusPlatform.instance;
  const channel = MethodChannel('open_settings_plus');

  test('$MethodChannelOpenSettingsPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpenSettingsPlus>());
  });

  test('sendCustomMessage passes message through', () async {
    const openSettingsPlusPlugin = OpenSettingsPlusIOS();
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

  // ---------------------------------------------------------------------------
  // iOS — unchanged methods (same URL regardless of version)
  // ---------------------------------------------------------------------------

  group('iOS unchanged methods', () {
    late MockOpenSettingsPlusPlatform fakePlatform;

    setUp(() {
      fakePlatform = MockOpenSettingsPlusPlatform();
      OpenSettingsPlusPlatform.instance = fakePlatform;
    });

    test('wifi()', () async {
      await const OpenSettingsPlusIOS().wifi();
      expect(fakePlatform.lastCalled, 'App-Prefs:WIFI');
    });

    test('bluetooth()', () async {
      await const OpenSettingsPlusIOS().bluetooth();
      expect(fakePlatform.lastCalled, 'App-prefs:Bluetooth');
    });

    test('settings()', () async {
      await const OpenSettingsPlusIOS().settings();
      expect(fakePlatform.lastCalled, 'App-prefs:');
    });

    test('appSettings()', () async {
      await const OpenSettingsPlusIOS().appSettings();
      expect(fakePlatform.lastCalled, 'app-settings:');
    });

    test('about()', () async {
      await const OpenSettingsPlusIOS().about();
      expect(fakePlatform.lastCalled, 'App-Prefs:General&path=About');
    });

    test('accessibility()', () async {
      await const OpenSettingsPlusIOS().accessibility();
      expect(fakePlatform.lastCalled, 'App-prefs:ACCESSIBILITY');
    });

    test('battery()', () async {
      await const OpenSettingsPlusIOS().battery();
      expect(fakePlatform.lastCalled, 'App-prefs:BATTERY_USAGE');
    });

    test('cellular()', () async {
      await const OpenSettingsPlusIOS().cellular();
      expect(fakePlatform.lastCalled, 'App-prefs:MOBILE_DATA_SETTINGS_ID');
    });

    test('displayAndBrightness()', () async {
      await const OpenSettingsPlusIOS().displayAndBrightness();
      expect(fakePlatform.lastCalled, 'App-prefs:DISPLAY');
    });

    test('facetime()', () async {
      await const OpenSettingsPlusIOS().facetime();
      expect(fakePlatform.lastCalled, 'App-prefs:FACETIME');
    });

    test('general()', () async {
      await const OpenSettingsPlusIOS().general();
      expect(fakePlatform.lastCalled, 'App-prefs:General');
    });

    test('music()', () async {
      await const OpenSettingsPlusIOS().music();
      expect(fakePlatform.lastCalled, 'App-prefs:MUSIC');
    });

    test('photosAndCamera()', () async {
      await const OpenSettingsPlusIOS().photosAndCamera();
      expect(fakePlatform.lastCalled, 'App-prefs:Photos');
    });

    test('soundsAndHaptics()', () async {
      await const OpenSettingsPlusIOS().soundsAndHaptics();
      expect(fakePlatform.lastCalled, 'App-prefs:Sounds');
    });

    test('siri()', () async {
      await const OpenSettingsPlusIOS().siri();
      expect(fakePlatform.lastCalled, 'App-prefs:SIRI');
    });

    test('wallpapers()', () async {
      await const OpenSettingsPlusIOS().wallpapers();
      expect(fakePlatform.lastCalled, 'App-prefs:Wallpaper');
    });
  });

  // ---------------------------------------------------------------------------
  // iOS — version-aware methods (old URL on iOS <26, new URL on iOS 26+)
  // ---------------------------------------------------------------------------

  group('iOS version-aware methods', () {
    late MockOpenSettingsPlusPlatform fakePlatform;

    setUp(() {
      fakePlatform = MockOpenSettingsPlusPlatform();
      OpenSettingsPlusPlatform.instance = fakePlatform;
      // Reset the cached version between tests
      OpenSettingsPlusIOS.resetIOSVersionCache();
    });

    test('privacy() uses App-prefs on iOS <26', () async {
      fakePlatform.iosVersion = '18.0';
      await const OpenSettingsPlusIOS().privacy();
      expect(fakePlatform.lastCalled, 'App-prefs:Privacy');
    });

    test('privacy() uses settings-navigation on iOS 26+', () async {
      fakePlatform.iosVersion = '26.0';
      await const OpenSettingsPlusIOS().privacy();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity',
      );
    });

    test('accountSettings() uses App-prefs on iOS <26', () async {
      fakePlatform.iosVersion = '17.4';
      await const OpenSettingsPlusIOS().accountSettings();
      expect(fakePlatform.lastCalled, 'App-prefs:ACCOUNT_SETTINGS');
    });

    test('accountSettings() uses settings-navigation on iOS 26+', () async {
      fakePlatform.iosVersion = '26.1';
      await const OpenSettingsPlusIOS().accountSettings();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount',
      );
    });

    test('iCloud() uses App-prefs on iOS <26', () async {
      fakePlatform.iosVersion = '18.5';
      await const OpenSettingsPlusIOS().iCloud();
      expect(fakePlatform.lastCalled, 'App-prefs:CASTLE');
    });

    test('iCloud() uses settings-navigation on iOS 26+', () async {
      fakePlatform.iosVersion = '26.0';
      await const OpenSettingsPlusIOS().iCloud();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE',
      );
    });

    test('storageAndBackup() uses App-prefs on iOS <26', () async {
      fakePlatform.iosVersion = '16.0';
      await const OpenSettingsPlusIOS().storageAndBackup();
      expect(
        fakePlatform.lastCalled,
        'App-prefs:CASTLE&path=STORAGE_AND_BACKUP',
      );
    });

    test('storageAndBackup() uses settings-navigation on iOS 26+', () async {
      fakePlatform.iosVersion = '26.0';
      await const OpenSettingsPlusIOS().storageAndBackup();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/STORAGE_AND_BACKUP',
      );
    });

    test('locationServices() uses App-prefs on iOS <26', () async {
      fakePlatform.iosVersion = '15.0';
      await const OpenSettingsPlusIOS().locationServices();
      expect(fakePlatform.lastCalled, 'App-prefs:LOCATION_SERVICES');
    });

    test('locationServices() uses settings-navigation on iOS 26+', () async {
      fakePlatform.iosVersion = '26.0';
      await const OpenSettingsPlusIOS().locationServices();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/LOCATION',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // iOS — new settings-navigation:// only methods
  // ---------------------------------------------------------------------------

  group('iOS new settings-navigation methods', () {
    late MockOpenSettingsPlusPlatform fakePlatform;

    setUp(() {
      fakePlatform = MockOpenSettingsPlusPlatform();
      OpenSettingsPlusPlatform.instance = fakePlatform;
    });

    test('apps()', () async {
      await const OpenSettingsPlusIOS().apps();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Apps',
      );
    });

    test('home()', () async {
      await const OpenSettingsPlusIOS().home();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.HomeKit',
      );
    });

    test('passwords()', () async {
      await const OpenSettingsPlusIOS().passwords();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Apps/com.apple.Passwords',
      );
    });

    test('privacyCamera()', () async {
      await const OpenSettingsPlusIOS().privacyCamera();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/CAMERA',
      );
    });

    test('privacyMicrophone()', () async {
      await const OpenSettingsPlusIOS().privacyMicrophone();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/MICROPHONE',
      );
    });

    test('privacyPhotos()', () async {
      await const OpenSettingsPlusIOS().privacyPhotos();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/PHOTOS',
      );
    });

    test('privacyContacts()', () async {
      await const OpenSettingsPlusIOS().privacyContacts();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/CONTACTS',
      );
    });

    test('privacyTracking()', () async {
      await const OpenSettingsPlusIOS().privacyTracking();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/USER_TRACKING',
      );
    });

    test('privacySafetyCheck()', () async {
      await const OpenSettingsPlusIOS().privacySafetyCheck();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/SAFETY_CHECK',
      );
    });

    test('search()', () async {
      await const OpenSettingsPlusIOS().search();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Search',
      );
    });

    test('tvProvider()', () async {
      await const OpenSettingsPlusIOS().tvProvider();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.TVProvider',
      );
    });

    test('safari()', () async {
      await const OpenSettingsPlusIOS().safari();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/',
      );
    });

    test('notes()', () async {
      await const OpenSettingsPlusIOS().notes();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes',
      );
    });

    test('measure()', () async {
      await const OpenSettingsPlusIOS().measure();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Apps/com.apple.measure',
      );
    });

    test('appleAccountFamily()', () async {
      await const OpenSettingsPlusIOS().appleAccountFamily();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount/Family',
      );
    });

    test('appleAccountSubscriptions()', () async {
      await const OpenSettingsPlusIOS().appleAccountSubscriptions();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount/SUBSCRIPTIONS',
      );
    });

    test('iCloudBackup()', () async {
      await const OpenSettingsPlusIOS().iCloudBackup();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/BACKUP',
      );
    });

    test('findMyDevice()', () async {
      await const OpenSettingsPlusIOS().findMyDevice();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.AppleAccount/LOCATION_SHARING/FindMyDevice-Settings',
      );
    });

    test('privacyLockdownMode()', () async {
      await const OpenSettingsPlusIOS().privacyLockdownMode();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity#LOCKDOWN_MODE#LOCKDOWN_MODE',
      );
    });

    test('safariExtensions()', () async {
      await const OpenSettingsPlusIOS().safariExtensions();
      expect(
        fakePlatform.lastCalled,
        'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/WEB_EXTENSIONS',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Android intent channel
  // ---------------------------------------------------------------------------

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
