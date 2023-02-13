import 'package:open_settings_plus/open_settings_plus.dart';

class OpenSettingsPlusAndroid extends OpenSettingsPlus {
  const OpenSettingsPlusAndroid();

  Future<bool> wifi() {
    return sendCustomMessage(
      'android.settings.WIFI_SETTINGS',
    );
  }

  Future<bool> dataRoaming() {
    return sendCustomMessage(
      'android.settings.DATA_ROAMING_SETTINGS',
    );
  }

  Future<bool> locationSource() {
    return sendCustomMessage(
      'android.settings.LOCATION_SOURCE_SETTINGS',
    );
  }

  Future<bool> appSettings() {
    return sendCustomMessage(
      'android.settings.APPLICATION_SETTINGS',
    );
  }

  Future<bool> bluetooth() {
    return sendCustomMessage(
      'android.settings.BLUETOOTH_SETTINGS',
    );
  }

  Future<bool> notification() {
    return sendCustomMessage(
      'android.settings.NOTIFICATION_SETTINGS',
    );
  }

  Future<bool> security() {
    return sendCustomMessage(
      'android.settings.SECURITY_SETTINGS',
    );
  }

  Future<bool> sound() {
    return sendCustomMessage(
      'android.settings.SOUND_SETTINGS',
    );
  }

  Future<bool> display() {
    return sendCustomMessage(
      'android.settings.DISPLAY_SETTINGS',
    );
  }

  Future<bool> date() {
    return sendCustomMessage(
      'android.settings.DATE_SETTINGS',
    );
  }

  Future<bool> deviceInfo() {
    return sendCustomMessage(
      'android.settings.DEVICE_INFO_SETTINGS',
    );
  }

  Future<bool> internalStorage() {
    return sendCustomMessage(
      'android.settings.INTERNAL_STORAGE_SETTINGS',
    );
  }

  Future<bool> memoryCard() {
    return sendCustomMessage(
      'android.settings.MEMORY_CARD_SETTINGS',
    );
  }

  Future<bool> accessibility() {
    return sendCustomMessage(
      'android.settings.ACCESSIBILITY_SETTINGS',
    );
  }

  Future<bool> addAccount() {
    return sendCustomMessage(
      'android.settings.ADD_ACCOUNT_SETTINGS',
    );
  }

  Future<bool> airplaneMode() {
    return sendCustomMessage(
      'android.settings.AIRPLANE_MODE_SETTINGS',
    );
  }

  Future<bool> apnSettings() {
    return sendCustomMessage(
      'android.settings.APN_SETTINGS',
    );
  }

  Future<bool> applicationDetails() {
    return sendCustomMessage(
      'android.settings.APPLICATION_DETAILS_SETTINGS',
    );
  }

  Future<bool> applicationDevelopment() {
    return sendCustomMessage(
      'android.settings.APPLICATION_DEVELOPMENT_SETTINGS',
    );
  }

  Future<bool> applicationNotification() {
    return sendCustomMessage(
      'android.settings.APPLICATION_NOTIFICATION_SETTINGS',
    );
  }

  Future<bool> applicationSettings() {
    return sendCustomMessage(
      'android.settings.APPLICATION_SETTINGS',
    );
  }

  Future<bool> applicationWriteSettings() {
    return sendCustomMessage(
      'android.settings.APPLICATION_WRITE_SETTINGS',
    );
  }

  Future<bool> batterySaver() {
    return sendCustomMessage(
      'android.settings.BATTERY_SAVER_SETTINGS',
    );
  }

  Future<bool> captioning() {
    return sendCustomMessage(
      'android.settings.CAPTIONING_SETTINGS',
    );
  }

  Future<bool> cast() {
    return sendCustomMessage(
      'android.settings.CAST_SETTINGS',
    );
  }

  Future<bool> dataUsage() {
    return sendCustomMessage(
      'android.settings.DATA_USAGE_SETTINGS',
    );
  }

  Future<bool> appNotificationBubble() {
    return sendCustomMessage(
      'android.settings.APP_NOTIFICATION_BUBBLE_SETTINGS',
    );
  }

  Future<bool> appNotification() {
    return sendCustomMessage(
      'android.settings.APP_NOTIFICATION_SETTINGS',
    );
  }

  Future<bool> search() {
    return sendCustomMessage(
      'android.search.action.SEARCH_SETTINGS',
    );
  }

  Future<bool> biometricEnroll() {
    return sendCustomMessage(
      'android.settings.BIOMETRIC_ENROLL',
    );
  }

  Future<bool> hardwareKeyboard() {
    return sendCustomMessage(
      'android.settings.HARD_KEYBOARD_SETTINGS',
    );
  }

  Future<bool> home() {
    return sendCustomMessage(
      'android.settings.HOME_SETTINGS',
    );
  }

  Future<bool> ignoreBackgroundDataRestrictions() {
    return sendCustomMessage(
      'android.settings.IGNORE_BACKGROUND_DATA_RESTRICTIONS_SETTINGS',
    );
  }

  Future<bool> ignoreBatteryOptimization() {
    return sendCustomMessage(
      'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
    );
  }

  Future<bool> inputMethod() {
    return sendCustomMessage(
      'android.settings.INPUT_METHOD_SETTINGS',
    );
  }

  Future<bool> inputMethodSubtype() {
    return sendCustomMessage(
      'android.settings.INPUT_METHOD_SUBTYPE_SETTINGS',
    );
  }

  Future<bool> locale() {
    return sendCustomMessage(
      'android.settings.LOCALE_SETTINGS',
    );
  }

  Future<bool> manageAllApplications() {
    return sendCustomMessage(
      'android.settings.MANAGE_ALL_APPLICATIONS_SETTINGS',
    );
  }

  Future<bool> manageApplication() {
    return sendCustomMessage(
      'android.settings.MANAGE_APPLICATIONS_SETTINGS',
    );
  }

  Future<bool> manageDefaultApps() {
    return sendCustomMessage(
      'android.settings.MANAGE_DEFAULT_APPS_SETTINGS',
    );
  }

  Future<bool> manageExternalSources() {
    return sendCustomMessage(
      'android.settings.MANAGE_EXTERNAL_SOURCES_SETTINGS',
    );
  }

  Future<bool> manageOverlay() {
    return sendCustomMessage(
      'android.settings.MANAGE_OVERLAY_PERMISSION',
    );
  }
}
