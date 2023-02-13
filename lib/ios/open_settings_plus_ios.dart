import 'package:open_settings_plus/open_settings_plus.dart';

class OpenSettingsPlusIOS extends OpenSettingsPlus {
  const OpenSettingsPlusIOS();

  Future<bool> wifi() {
    return sendCustomMessage('App-Prefs:WIFI');
  }

  Future<bool> settings() {
    return sendCustomMessage('App-prefs:');
  }

  Future<bool> about() {
    return sendCustomMessage('App-Prefs:General&path=About');
  }

  Future<bool> accessibility() {
    return sendCustomMessage('App-prefs:ACCESSIBILITY');
  }

  Future<bool> accountSettings() {
    return sendCustomMessage('App-prefs:ACCOUNT_SETTINGS');
  }

  Future<bool> autoLock() {
    return sendCustomMessage('App-prefs:DISPLAY&path=AUTOLOCK');
  }

  Future<bool> battery() {
    return sendCustomMessage('App-prefs:BATTERY_USAGE');
  }

  Future<bool> bluetooth() {
    return sendCustomMessage('App-prefs:Bluetooth');
  }

  Future<bool> dateAndTime() {
    return sendCustomMessage('App-prefs:General&path=DATE_AND_TIME');
  }

  Future<bool> faceIDAndPasscode() {
    return sendCustomMessage('App-prefs:TOUCHID_PASSCODE');
  }

  Future<bool> cellular() {
    return sendCustomMessage('App-prefs:MOBILE_DATA_SETTINGS_ID');
  }

  Future<bool> dictionary() {
    return sendCustomMessage('App-prefs:General&path=DICTIONARY');
  }

  Future<bool> displayAndBrightness() {
    return sendCustomMessage('App-prefs:DISPLAY');
  }

  Future<bool> facetime() {
    return sendCustomMessage('App-prefs:FACETIME');
  }

  Future<bool> general() {
    return sendCustomMessage('App-prefs:General');
  }

  Future<bool> healthKit() {
    return sendCustomMessage('App-Prefs:HealthKit');
  }

  Future<bool> iCloud() {
    return sendCustomMessage('App-prefs:CASTLE');
  }

  Future<bool> music() {
    return sendCustomMessage('App-prefs:MUSIC');
  }

  Future<bool> keyboard() {
    return sendCustomMessage('App-prefs:General&path=Keyboard');
  }

  Future<bool> keyboards() {
    return sendCustomMessage('App-prefs:General&path=Keyboard/KEYBOARDS');
  }

  Future<bool> languageAndRegion() {
    return sendCustomMessage('App-prefs:General&path=INTERNATIONAL');
  }

  Future<bool> locationServices() {
    return sendCustomMessage('App-prefs:LOCATION_SERVICES');
  }

  Future<bool> personalHotspot() {
    return sendCustomMessage('App-prefs:INTERNET_TETHERING');
  }

  Future<bool> phone() {
    return sendCustomMessage('App-prefs:Phone');
  }

  Future<bool> photosAndCamera() {
    return sendCustomMessage('App-prefs:Photos');
  }

  Future<bool> privacy() {
    return sendCustomMessage('App-prefs:Privacy');
  }

  Future<bool> profilesAndDeviceManagement() {
    return sendCustomMessage('App-prefs:General&path=ManagedConfigurationList');
  }

  Future<bool> softwareUpdate() {
    return sendCustomMessage('App-prefs:General&path=SOFTWARE_UPDATE_LINK');
  }

  Future<bool> storageAndBackup() {
    return sendCustomMessage('App-prefs:CASTLE&path=STORAGE_AND_BACKUP');
  }

  Future<bool> siri() {
    return sendCustomMessage('App-prefs:SIRI');
  }

  Future<bool> soundsAndHaptics() {
    return sendCustomMessage('App-prefs:Sounds');
  }
}
