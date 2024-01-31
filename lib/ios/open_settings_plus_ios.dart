import 'package:open_settings_plus/open_settings_plus.dart';

/// {@macro open_settings_plus}
/// The iOS implementation of `OpenSettingsPlusPlatform`. You
/// can use this class to open settings in iOS.
/// Note: This class should only be used in iOS.
/// {@endtemplate}
class OpenSettingsPlusIOS extends OpenSettingsPlus {
  /// {@macro open_settings_plus}
  const OpenSettingsPlusIOS();

  /// Open iOS settings in `Wi-Fi` section.
  /// returns operation successful or failure.
  Future<bool> wifi() {
    return sendCustomMessage('App-Prefs:WIFI');
  }

  /// Open iOS settings.
  /// returns operation successful or failure.
  Future<bool> settings() {
    return sendCustomMessage('App-prefs:');
  }

  /// Open the app settings.
  /// returns operation successful or failure.
  Future<bool> appSettings() {
    return sendCustomMessage('app-settings:');
  }

  /// Open iOS settings in `About` section.
  /// returns operation successful or failure.
  Future<bool> about() {
    return sendCustomMessage('App-Prefs:General&path=About');
  }

  /// Open iOS settings in accessibility section.
  Future<bool> accessibility() {
    return sendCustomMessage('App-prefs:ACCESSIBILITY');
  }

  /// Open iOS settings in `Account Settings` section.
  /// returns operation successful or failure.
  Future<bool> accountSettings() {
    return sendCustomMessage('App-prefs:ACCOUNT_SETTINGS');
  }

  /// Open iOS settings in auto lock section.
  Future<bool> autoLock() {
    return sendCustomMessage('App-prefs:DISPLAY&path=AUTOLOCK');
  }

  /// Open iOS settings in `Battery` section.
  /// returns operation successful or failure.
  Future<bool> battery() {
    return sendCustomMessage('App-prefs:BATTERY_USAGE');
  }

  /// Open iOS settings in `Bluetooth` section.
  /// returns operation successful or failure.
  Future<bool> bluetooth() {
    return sendCustomMessage('App-prefs:Bluetooth');
  }

  /// Open iOS settings in `Date & Time` section.
  /// returns operation successful or failure.
  Future<bool> dateAndTime() {
    return sendCustomMessage('App-prefs:General&path=DATE_AND_TIME');
  }

  /// Open iOS settings in `FaceID and Passcode` section.
  /// returns operation successful or failure.
  Future<bool> faceIDAndPasscode() {
    return sendCustomMessage('App-prefs:TOUCHID_PASSCODE');
  }

  /// Open iOS settings in `Cellular` section.
  /// returns operation successful or failure.
  Future<bool> cellular() {
    return sendCustomMessage('App-prefs:MOBILE_DATA_SETTINGS_ID');
  }

  /// Open iOS settings in `Dictionary` section.
  /// returns operation successful or failure.
  Future<bool> dictionary() {
    return sendCustomMessage('App-prefs:General&path=DICTIONARY');
  }

  /// Open iOS settings in `Display & Brighness` section.
  /// returns operation successful or failure.
  Future<bool> displayAndBrightness() {
    return sendCustomMessage('App-prefs:DISPLAY');
  }

  /// Open iOS settings in `FaceTime` section.
  /// returns operation successful or failure.
  Future<bool> facetime() {
    return sendCustomMessage('App-prefs:FACETIME');
  }

  /// Open iOS settings in `General` section.
  /// returns operation successful or failure.
  Future<bool> general() {
    return sendCustomMessage('App-prefs:General');
  }

  /// Open iOS settings in HealthKit section.
  /// returns operation successful or failure.
  Future<bool> healthKit() {
    return sendCustomMessage('App-Prefs:HealthKit');
  }

  /// Open iOS settings in iCloud section.
  /// returns operation successful or failure.
  Future<bool> iCloud() {
    return sendCustomMessage('App-prefs:CASTLE');
  }

  /// Open iOS settings in Music section.
  /// returns operation successful or failure.
  Future<bool> music() {
    return sendCustomMessage('App-prefs:MUSIC');
  }

  /// Open iOS settings in Keyboard section.
  /// returns operation successful or failure.
  Future<bool> keyboard() {
    return sendCustomMessage('App-prefs:General&path=Keyboard');
  }

  /// Open iOS settings in Keyboards section.
  /// returns operation successful or failure.
  Future<bool> keyboards() {
    return sendCustomMessage('App-prefs:General&path=Keyboard/KEYBOARDS');
  }

  /// Open iOS settings in `Language & Region` section.
  /// returns operation successful or failure.
  Future<bool> languageAndRegion() {
    return sendCustomMessage('App-prefs:General&path=INTERNATIONAL');
  }

  /// Open iOS settings in `Location Service` section.
  /// returns operation successful or failure.
  Future<bool> locationServices() {
    return sendCustomMessage('App-prefs:LOCATION_SERVICES');
  }

  /// Open iOS settings in `Personal Hotspot` section.
  /// returns operation successful or failure.
  Future<bool> personalHotspot() {
    return sendCustomMessage('App-prefs:INTERNET_TETHERING');
  }

  /// Open iOS settings in `Phone` section.
  /// returns operation successful or failure.
  Future<bool> phone() {
    return sendCustomMessage('App-prefs:Phone');
  }

  /// Open iOS settings in `Photos & Camera` section.
  /// returns operation successful or failure.
  Future<bool> photosAndCamera() {
    return sendCustomMessage('App-prefs:Photos');
  }

  /// Open iOS settings in `Privacy` section.
  /// returns operation successful or failure.
  Future<bool> privacy() {
    return sendCustomMessage('App-prefs:Privacy');
  }

  /// Open iOS settings in `Profiles and Device Management` section.
  /// returns operation successful or failure.
  Future<bool> profilesAndDeviceManagement() {
    return sendCustomMessage('App-prefs:General&path=ManagedConfigurationList');
  }

  /// Open iOS settings in `Software Update` section.
  /// returns operation successful or failure.
  Future<bool> softwareUpdate() {
    return sendCustomMessage('App-prefs:General&path=SOFTWARE_UPDATE_LINK');
  }

  /// Open iOS settings in `Storage and Backup` section.
  /// returns operation successful or failure.
  Future<bool> storageAndBackup() {
    return sendCustomMessage('App-prefs:CASTLE&path=STORAGE_AND_BACKUP');
  }

  /// Open iOS settings in `Siri` section.
  /// returns operation successful or failure.
  Future<bool> siri() {
    return sendCustomMessage('App-prefs:SIRI');
  }

  /// Open iOS settings in `Sounds & Haptics` section.
  /// returns operation successful or failure.
  Future<bool> soundsAndHaptics() {
    return sendCustomMessage('App-prefs:Sounds');
  }
}
