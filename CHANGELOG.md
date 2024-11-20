## 0.4.0

### 🚀 New Features
- Added enhanced support for notification settings across different Android versions
- Added new `call()` method to open Android general settings

### 🔧 Bug Fixes
- Fixed test namespace in Android to `br.com.yanncabral.open_settings_plus.test`
- Improved intent handling logic for specific Android settings

### 🔄 Updates
- Updated `compileSdkVersion` to 34
- Updated iOS LastUpgradeVersion to 1510
- Updated `@UIApplicationMain` to `@main` in iOS AppDelegate
- Updated several example dependencies:
  - meta: 1.12.0 → 1.15.0
  - test_api: 0.7.0 → 0.7.2
  - vm_service: 14.2.0 → 14.2.5

### 💡 Technical Improvements
- Implemented version-specific logic for Android notification settings
- Refactored decision structure for opening app-specific settings

## 0.3.3
* Change Java version to 11 and gradle to 7.4.2 to solve apk build error ([View Contributor's Github](https://github.com/lcmacedo))

## 0.3.2
* Removed unnecessary NDK declaration from Android build.gradle to eliminate compilation warning when no C/C++ dependencies are present. ([View Contributor's Github](https://github.com/Petrol-))

## 0.3.1
* Fix health settings for ios.

## 0.3.0
* Add wallpaper option to ios.

## 0.2.0
* Remove unnecessary comments.
* Add a better documentation for the plugin.
* Add nfc option to android.
* Fix version of AGP8 and compilesdk version 34 (@prasant10050)
* Add a better example for the plugin.
* Better API by using singleton and switch case.

## 0.1.0
* Add a stricter code analysis
* Add NFC option to android.

## 0.0.2

* Add better documentations for android implementation.
* Add better documentations for iOS implementation.
* Use https homepage instead of http.
* Update podspec.

## 0.0.1

* Make it works
