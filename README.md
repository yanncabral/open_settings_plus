# open_settings_plus

The most complete flutter plugin packages for open various settings screen, covering newer versions of ios and android.

## Features

### For android:

- wifi
- dataRoaming
- locationSource
- appSettings
- bluetooth
- notification
- security
- sound
- display
- date
- deviceInfo
- internalStorage
- memoryCard
- accessibility
- addAccount
- airplaneMode
- apnSettings
- applicationDetails
- applicationDevelopment
- applicationNotification
- applicationSettings
- applicationWriteSettings
- batterySaver
- captioning
- cast
- dataUsage
- appNotificationBubble
- appNotification
- search
- biometricEnroll
- hardwareKeyboard
- home
- ignoreBackgroundDataRestrictions
- ignoreBatteryOptimization
- inputMethod
- inputMethodSubtype
- locale
- manageAllApplications
- manageApplication
- manageDefaultApps
- manageExternalSources
- manageOverlay

and growing.

### For iOS

- wifi
- settings
- about
- accessibility
- accountSettings
- autoLock
- battery
- bluetooth
- dateAndTime
- faceIDAndPasscode
- cellular
- dictionary
- displayAndBrightness
- facetime
- general
- healthKit
- iCloud
- music
- keyboard
- keyboards
- languageAndRegion
- locationServices
- personalHotspot
- phone
- photosAndCamera
- privacy
- profilesAndDeviceManagement
- softwareUpdate
- storageAndBackup
- siri
- soundsAndHaptics

and growing.

## Usage

To use this plugin, add `open_settings_plus` as a dependency in your pubspec.yaml file.

```dart
import 'package:flutter/material.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

const settingsiOS = OpenSettingsPlusIOS();
const settingsAndroid = OpenSettingsPlusAndroid();

void main() => runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
                 if (Platform.isAndroid) {
                    return settingsAndroid.wifi();
                } else if (Platform.isIOS) {
                    return settingsiOS.wifi();
                } else {
                    throw Exception('Platform not supported');
                }

              },
            child: Text('Wi-fi Settings'),
          ),
        ),
      ),
    ));
```

You can see more in `exemple` folder.

# Acknowledgments

This package was originally created by [Yann Cabral](https://github.com/yanncabral) because of limitations of the amazing [Ali Hoseinpoor](https://github.com/AliHoseinpoor/open_settings) package.

# Bugs or Requests

If you encounter any problems feel free to open an [issue](https://github.com//yanncabral/open_settings_plus/issues/new). If you feel the library is missing a feature, please raise a [ticket](https://github.com//yanncabral/open_settings_plus/issues/new). Pull request are also welcome.
