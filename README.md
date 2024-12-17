# `open_settings_plus`

A comprehensive Flutter plugin to seamlessly navigate to various settings screens on both iOS and Android devices, ensuring compatibility with the latest versions of both platforms.

## Known Issues

We are aware that the shortcuts in open_settings_plus are not functioning properly on the latest versions of iOS 18. This issue is currently under investigation, but progress has been challenging due to the lack of documentation or online resources regarding the new URL schemes.

A fix is being actively worked on and will be released as soon as possible.


## 🚀 Usage

To integrate `open_settings_plus` into your project, add it as a dependency in your `pubspec.yaml` file.

```dart
import 'package:flutter/material.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              switch (OpenSettingsPlus.shared) {
                OpenSettingsPlusAndroid settings => settings.wifi(),
                OpenSettingsPlusIOS settings => settings.wifi(),
                _ => throw Exception('Platform not supported'),
              }
            },
            child: Text('Wi-Fi Settings'),
          ),
        ),
      ),
    )
  );
```

For more examples and use-cases, refer to the `example` directory.

## 🌟 Features

### Android:

Navigate directly to:

- Wi-Fi
- Data Roaming
- Location Source
- App Settings
- Bluetooth
- Notifications
- Security
- Sound
- Display
- Date & Time
- Device Information
- Internal Storage
- Memory Card
- Accessibility
- Add Account
- Airplane Mode
- APN Settings
- Application Details
- Application Development
- Application Notifications
- Application Write Settings
- Battery Saver
- Captioning
- Cast
- Data Usage
- App Notification Bubble
- Search
- Biometric Enrollment
- Hardware Keyboard
- Home
- Ignore Background Data Restrictions
- Ignore Battery Optimization
- Input Method
- Locale
- Manage All Applications
- Manage External Sources
- Manage Overlay
... and more features being added regularly!

### iOS:

Navigate directly to:

- Wi-Fi
- General Settings
- About
- Accessibility
- Account Settings
- Auto Lock
- Battery
- Bluetooth
- Date & Time
- Face ID & Passcode
- Cellular
- Dictionary
- Display & Brightness
- FaceTime
- General
- HealthKit
- iCloud
- Music
- Keyboard
- Language & Region
- Location Services
- Personal Hotspot
- Phone
- Photos & Camera
- Privacy
- Profiles & Device Management
- Software Update
- Storage & Backup
- Siri
- Sounds & Haptics
... and more features being added regularly!

## 🙏 Acknowledgments

This package was innovatively crafted by [Yann Cabral](https://github.com/yanncabral). It was inspired by the fantastic work of [Ali Hoseinpoor](https://github.com/AliHoseinpoor/open_settings), aiming to overcome certain limitations.

## 🐞 Bugs or Feature Requests

Encountered an issue or have a feature in mind? We'd love to hear from you!

- Report issues or seek features [here](https://github.com/yanncabral/open_settings_plus/issues/new).
- Contributions via pull requests are always welcome!

---

This revised README provides a more structured and polished presentation of the plugin's features and usage.

