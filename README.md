# open_settings_plus

Open Android and iOS settings from Flutter, with platform-specific shortcuts and
explicit results for fallback, unsupported destinations and launch failures.

## Installation

```sh
flutter pub add open_settings_plus
```

Requires Flutter 3.41+ and Dart 3.11+. Both CocoaPods and Swift Package Manager
(SPM) are supported. The plugin declares iOS 12.0 as its minimum; the Flutter SDK
and its engine can require a newer deployment target for the consuming app.
SPM integration must be enabled in projects using it.

## Common destinations

```dart
import 'package:open_settings_plus/open_settings_plus.dart';

final result = await OpenSettingsPlus.open(SettingsTarget.appSettings);

switch (result) {
  case SettingsOpenResult.opened:
    // The OS accepted the requested destination.
    break;
  case SettingsOpenResult.fallbackOpened:
    // The requested destination was unavailable; this app's settings opened.
    break;
  case SettingsOpenResult.unsupported:
    // No supported destination or implementation is available.
    break;
  case SettingsOpenResult.failed:
    // Opening failed, including any attempted fallback.
    break;
}
```

`SettingsTarget` includes `appSettings`, `notifications`, `wifi`, `bluetooth`
and `location`. The shared API selects the current platform without a switch.
Opening a screen does **not** confirm that a permission or preference changed.
Recheck the relevant permission when your app resumes.

| Destination | Android | iOS |
| --- | --- | --- |
| This app's settings | App details | Public app settings URL |
| This app's notifications | App notification settings, with legacy extras | Public notification URL on iOS 15.4+ |
| Wi-Fi, Bluetooth, location | System settings | App settings fallback; no public direct destination |
| Other platforms | `unsupported` | `unsupported` |

Fallback is enabled by default. To require the requested destination:

```dart
final result = await OpenSettingsPlus.open(
  SettingsTarget.wifi,
  fallbackToAppSettings: false,
);
```

On iOS this returns `unsupported` without opening an experimental URL. On Android,
the result also depends on OS version, hardware and the manufacturer's settings app.

## Platform-specific APIs

```dart
const android = OpenSettingsPlusAndroid();
await android.currentAppSettings(); // This app's details.
await android.allAppSettings(); // List of installed apps.
await android.appNotification();
await android.openByDefault();

const ios = OpenSettingsPlusIOS();
await ios.currentAppSettings();
await ios.appNotification(); // App settings fallback before iOS 15.4.
```

Existing shortcuts still return `Future<bool>`. `true` means a launch was accepted
and can include a fallback. For a detailed result use `openTarget(...)` on a
platform instance or `openSettingsTarget(...)` with a native action/URL.

Android's legacy `appSettings()` and `applicationSettings()` still open the app
list; both are deprecated in favor of `allAppSettings()`. iOS `appSettings()`
remains an alias of `currentAppSettings()`. `applicationDetails()` remains
available on Android. These aliases preserve their previous destinations.

### Android panels and additional destinations

```dart
const android = OpenSettingsPlusAndroid();

final panelResult = await android.openPanel(AndroidSettingsPanel.volume);
await android.appLocale();
await android.exactAlarm();
await android.vpn();
```

| API | Availability | Older or unavailable devices |
| --- | --- | --- |
| `openPanel(...)` | Android 10+ | `unsupported`; no fallback |
| `appLocale()` | Android 13+ | App details fallback |
| `exactAlarm()` | Android 12+ | App details fallback |
| `vpn()` | System VPN screen, including legacy Android route | Returns `false` if unavailable |

Panels include `wifi`, `internetConnectivity`, `nfc` and `volume`. Per-app language
selection requires the app to declare supported languages. Exact alarm access
requires the appropriate app manifest configuration, such as
`SCHEDULE_EXACT_ALARM`; opening the screen does not grant access.

Raw actions remain available, with package scoping when needed:

```dart
await android.sendAndroidAppIntent(
  'android.settings.APP_LOCALE_SETTINGS',
  asAnotherTask: false,
);

final result = await android.openSettingsTarget(
  'android.settings.APP_LOCALE_SETTINGS',
  appSpecific: true,
  fallbackToAppSettings: false,
);
```

Legacy intents open a separate task by default. Set `asAnotherTask: false` to use
the attached Activity. Panels default to the attached Activity. Without one,
Android requires a new task. All Android routing goes through the platform
interface, so custom implementations and test doubles can intercept it.

### Experimental iOS shortcuts

Methods such as `wifi()`, `bluetooth()`, `general()` and `privacy()` use undocumented
`App-prefs:` URL schemes. Their availability and exact destination vary by iOS
release; known failures include iOS 18. They are best effort and are not covered
by the supported-destination promises of the shared API. Even an accepted URL
does not prove that iOS displayed the requested section.

Legacy shortcuts preserve their existing behavior. To opt into an app-settings
fallback and inspect its result:

```dart
const ios = OpenSettingsPlusIOS();
final result = await ios.openSettingsTarget('App-prefs:WIFI');
```

Prefer `currentAppSettings()`, `appNotification()` or the shared API for public
iOS destinations. Notification routing uses the official constants for iOS
15.4–15.x and iOS 16+; older versions use the configured app-settings fallback.

## Compatibility and verification

Android compilation uses SDK 36, Kotlin 2.2.10 and Java 11 bytecode. The example
uses AGP 8.13.2 with Gradle 8.13; building it requires JDK 17. AGP 9 consumers using
legacy Kotlin require Flutter 3.44+; consumers using built-in Kotlin (the AGP 9
default, or `android.builtInKotlin=true`) require Flutter 3.47+. The CI AGP 9 matrix uses
`android.newDsl=false`; it does not certify the new AGP DSL.

The CI workflow checks the minimum and stable Flutter versions, Dart analysis
and tests, Android AGP 8/9 consumer builds, and iOS builds with both SPM and
CocoaPods. Native iOS regression tests compile the production plugin against
real UIKit and Flutter on a simulator, injecting URL launch outcomes to verify
completion and fallback. They do not certify every experimental settings URL
on every OS version.

```sh
flutter pub get
flutter test
dart analyze --fatal-infos --fatal-warnings .
# macOS with Xcode, Flutter iOS artifacts and an installed iOS simulator:
flutter precache --ios
bash tool/test_native_ios.sh
# With Android SDK/JDK installed, after building the example:
cd example/android
./gradlew :open_settings_plus:testDebugUnitTest
```

See [the example](example/lib/main.dart) for the full shortcut catalog. Unsupported
hardware or vendor-specific settings can still prevent an Android action from
opening. macOS, Windows, Linux and web are not implemented by this plugin.

## Contributing

Report bugs and propose features in the
[issue tracker](https://github.com/yanncabral/open_settings_plus/issues/new).
Include the target API, OS version, device and observed result.

Created by [Yann Cabral](https://github.com/yanncabral), inspired by
[Ali Hoseinpoor's open_settings](https://github.com/AliHoseinpoor/open_settings).
