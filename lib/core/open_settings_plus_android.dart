part of 'open_settings_plus.dart';

/// {@template open_settings_plus_android}
/// An implementation of `OpenSettingsPlusPlatform` that uses method channels.
/// This class is used by the app itself to open settings.
/// You need to use this class to open android options
/// {@endtemplate}
class OpenSettingsPlusAndroid extends OpenSettingsPlus {
  /// {@macro open_settings_plus_android}
  const OpenSettingsPlusAndroid();

  /// Open a raw Android action in a separate task by default.
  ///
  /// With [asAnotherTask] false, uses the attached Activity when available.
  /// Without an Activity, Android requires a new task even when false.
  Future<bool> sendAndroidIntent(String action, {bool asAnotherTask = true}) {
    return OpenSettingsPlusPlatform.instance.sendAndroidIntent(
      action,
      asAnotherTask: asAnotherTask,
    );
  }

  /// Open a raw Android action for the current app package.
  ///
  /// Falls back to the app details screen when the requested destination fails.
  /// A true result reports a launch, including this fallback.
  Future<bool> sendAndroidAppIntent(
    String action, {
    bool asAnotherTask = true,
  }) {
    return OpenSettingsPlusPlatform.instance.sendAndroidIntent(
      action,
      appSpecific: true,
      asAnotherTask: asAnotherTask,
    );
  }

  /// Open an Android 10+ settings panel above the calling app.
  ///
  /// Returns [SettingsOpenResult.unsupported] on older Android versions or when
  /// the device has no matching panel. Panels never fall back.
  /// Without an attached Activity, Android opens a new task.
  Future<SettingsOpenResult> openPanel(
    AndroidSettingsPanel panel, {
    bool asAnotherTask = false,
  }) {
    return OpenSettingsPlusPlatform.instance.openAndroidPanel(
      panel.name,
      asAnotherTask: asAnotherTask,
    );
  }

  /// Open this app's language settings on Android 13+.
  ///
  /// Older versions fall back to this app's details. The app must declare its
  /// supported languages for Android to offer per-app language selection.
  Future<bool> appLocale() {
    return sendAndroidAppIntent('android.settings.APP_LOCALE_SETTINGS');
  }

  /// Open this app's exact-alarm access settings on Android 12+.
  ///
  /// Declare SCHEDULE_EXACT_ALARM in the app manifest when requesting access.
  /// Older versions fall back to app details. A launch does not grant access.
  Future<bool> exactAlarm() {
    return sendAndroidAppIntent(
      'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
  }

  /// Open Android's VPN settings.
  Future<bool> vpn() {
    return sendAndroidIntent('android.settings.VPN_SETTINGS');
  }

  /// Open Android settings.
  /// returns operation successful or failure.
  Future<bool> call() {
    return sendCustomMessage('android.settings.SETTINGS');
  }

  /// Open Android settings in `Wi-Fi` section.
  /// returns operation successful or failure.
  Future<bool> wifi() {
    return sendCustomMessage('android.settings.WIFI_SETTINGS');
  }

  /// Open Android settings in `NFC` section.
  Future<bool> nfc() {
    return sendCustomMessage('android.settings.NFC_SETTINGS');
  }

  /// Open Android settings in `Data & Roaming` section.
  /// returns operation successful or failure.
  Future<bool> dataRoaming() {
    return sendCustomMessage('android.settings.DATA_ROAMING_SETTINGS');
  }

  /// Open Android settings in `Location` section.
  /// returns operation successful or failure.
  Future<bool> locationSource() {
    return sendCustomMessage('android.settings.LOCATION_SOURCE_SETTINGS');
  }

  /// Open Android's list of installed apps.
  ///
  /// This legacy name opens the app list, rather than this app's settings.
  @Deprecated('Use allAppSettings() for the app list or currentAppSettings().')
  Future<bool> appSettings() => allAppSettings();

  /// Open Android's list of installed apps.
  Future<bool> allAppSettings() {
    return sendCustomMessage('android.settings.APPLICATION_SETTINGS');
  }

  /// Open the settings for the current app package.
  ///
  /// A true result confirms a launch request, never a permission change.
  Future<bool> currentAppSettings() {
    return sendAndroidAppIntent(
      'android.settings.APPLICATION_DETAILS_SETTINGS',
    );
  }

  /// Open Android settings in `Bluetooth` section.
  /// returns operation successful or failure.
  Future<bool> bluetooth() {
    return sendCustomMessage('android.settings.BLUETOOTH_SETTINGS');
  }

  /// Open Android settings in `Notification` section.
  /// returns operation successful or failure.
  Future<bool> notification() {
    return sendCustomMessage('android.settings.NOTIFICATION_SETTINGS');
  }

  /// Open Android settings in `Security` section.
  /// returns operation successful or failure.
  Future<bool> security() {
    return sendCustomMessage('android.settings.SECURITY_SETTINGS');
  }

  /// Open Android settings in `Sound` section.
  /// returns operation successful or failure.
  Future<bool> sound() {
    return sendCustomMessage('android.settings.SOUND_SETTINGS');
  }

  /// Open Android settings in `Display` section.
  /// returns operation successful or failure.
  Future<bool> display() {
    return sendCustomMessage('android.settings.DISPLAY_SETTINGS');
  }

  /// Open Android settings in `Date` section.
  /// returns operation successful or failure.
  Future<bool> date() {
    return sendCustomMessage('android.settings.DATE_SETTINGS');
  }

  /// Open Android settings in `Device Info` section.
  /// returns operation successful or failure.
  Future<bool> deviceInfo() {
    return sendCustomMessage('android.settings.DEVICE_INFO_SETTINGS');
  }

  /// Open Android settings in `Internal Storage` section.
  /// returns operation successful or failure.
  Future<bool> internalStorage() {
    return sendCustomMessage('android.settings.INTERNAL_STORAGE_SETTINGS');
  }

  /// Open Android settings in `Memory Card` section.
  /// returns operation successful or failure.
  Future<bool> memoryCard() {
    return sendCustomMessage('android.settings.MEMORY_CARD_SETTINGS');
  }

  /// Open Android settings in `Accessbility` section.
  /// returns operation successful or failure.
  Future<bool> accessibility() {
    return sendCustomMessage('android.settings.ACCESSIBILITY_SETTINGS');
  }

  /// Open Android settings in `Add Account` section.
  /// returns operation successful or failure.
  Future<bool> addAccount() {
    return sendCustomMessage('android.settings.ADD_ACCOUNT_SETTINGS');
  }

  /// Open Android settings in `Airplane Mode` section.
  /// returns operation successful or failure.
  Future<bool> airplaneMode() {
    return sendCustomMessage('android.settings.AIRPLANE_MODE_SETTINGS');
  }

  /// Open Android settings in `Apn Settings` section.
  /// returns operation successful or failure.
  Future<bool> apnSettings() {
    return sendCustomMessage('android.settings.APN_SETTINGS');
  }

  /// Open the current app's settings; alias for [currentAppSettings].
  Future<bool> applicationDetails() => currentAppSettings();

  /// Open Android settings in `Application Development` section.
  /// returns operation successful or failure.
  Future<bool> applicationDevelopment() {
    return sendCustomMessage(
      'android.settings.APPLICATION_DEVELOPMENT_SETTINGS',
    );
  }

  /// Open Android settings in `Application Notification` section.
  /// returns operation successful or failure.
  @Deprecated('Use appNotification() instead.')
  Future<bool> applicationNotification() {
    return appNotification();
  }

  /// Open Android's list of installed apps.
  @Deprecated('Use allAppSettings() for the app list or currentAppSettings().')
  Future<bool> applicationSettings() => allAppSettings();

  /// Open Android settings in `Application Write Settings` section.
  /// returns operation successful or failure.
  Future<bool> applicationWriteSettings() {
    return sendAndroidAppIntent(
      'android.settings.action.MANAGE_WRITE_SETTINGS',
    );
  }

  /// Open Android settings in `Battery Saver` section.
  /// returns operation successful or failure.
  Future<bool> batterySaver() {
    return sendCustomMessage('android.settings.BATTERY_SAVER_SETTINGS');
  }

  /// Open Android settings in `Captioning` section.
  /// returns operation successful or failure.
  Future<bool> captioning() {
    return sendCustomMessage('android.settings.CAPTIONING_SETTINGS');
  }

  /// Open Android settings in `Cast` section.
  /// returns operation successful or failure.
  Future<bool> cast() {
    return sendCustomMessage('android.settings.CAST_SETTINGS');
  }

  /// Open Android settings in `Data Usage` section.
  /// returns operation successful or failure.
  Future<bool> dataUsage() {
    return sendCustomMessage('android.settings.DATA_USAGE_SETTINGS');
  }

  /// Open Android settings in `Mobile Hotspot & Tethering` section.
  /// returns operation successful or failure.
  Future<bool> tether() {
    return sendCustomMessage('android.settings.TETHER_SETTINGS');
  }

  /// Open Android settings in `App Notification Bubble` section.
  /// returns operation successful or failure.
  Future<bool> appNotificationBubble() {
    return sendAndroidAppIntent(
      'android.settings.APP_NOTIFICATION_BUBBLE_SETTINGS',
    );
  }

  /// Open Android settings in `App Notification` section.
  /// returns operation successful or failure.
  Future<bool> appNotification() {
    return sendAndroidAppIntent('android.settings.APP_NOTIFICATION_SETTINGS');
  }

  /// Open Android settings in `Open by default` section.
  /// returns operation successful or failure.
  Future<bool> openByDefault() {
    return sendAndroidAppIntent(
      'android.settings.APP_OPEN_BY_DEFAULT_SETTINGS',
    );
  }

  /// Open Android settings in `Search` section.
  /// returns operation successful or failure.
  Future<bool> search() {
    return sendCustomMessage('android.search.action.SEARCH_SETTINGS');
  }

  /// Open Android settings in `Biometric Enroll` section.
  /// returns operation successful or failure.
  Future<bool> biometricEnroll() {
    return sendCustomMessage('android.settings.BIOMETRIC_ENROLL');
  }

  /// Open Android settings in `HardKeyboard` section.
  /// returns operation successful or failure.
  Future<bool> hardwareKeyboard() {
    return sendCustomMessage('android.settings.HARD_KEYBOARD_SETTINGS');
  }

  /// Open Android settings in `Home` section.
  /// returns operation successful or failure.
  Future<bool> home() {
    return sendCustomMessage('android.settings.HOME_SETTINGS');
  }

  /// Open Android settings in `Ignore Background Data Restrictions` section.
  /// returns operation successful or failure.
  Future<bool> ignoreBackgroundDataRestrictions() {
    return sendAndroidAppIntent(
      'android.settings.IGNORE_BACKGROUND_DATA_RESTRICTIONS_SETTINGS',
    );
  }

  /// Open Android settings in `Ignore Battery Optimization` section.
  /// returns operation successful or failure.
  Future<bool> ignoreBatteryOptimization() {
    return sendCustomMessage(
      'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
    );
  }

  /// Open Android settings in `Input Method` section.
  /// returns operation successful or failure.
  Future<bool> inputMethod() {
    return sendCustomMessage('android.settings.INPUT_METHOD_SETTINGS');
  }

  /// Open Android settings in `Input Method Subtype` section.
  /// returns operation successful or failure.
  Future<bool> inputMethodSubtype() {
    return sendCustomMessage('android.settings.INPUT_METHOD_SUBTYPE_SETTINGS');
  }

  /// Open Android settings in `Locale` section.
  /// returns operation successful or failure.
  Future<bool> locale() {
    return sendCustomMessage('android.settings.LOCALE_SETTINGS');
  }

  /// Open Android settings in `Manage All Applications` section.
  /// returns operation successful or failure.
  Future<bool> manageAllApplications() {
    return sendCustomMessage(
      'android.settings.MANAGE_ALL_APPLICATIONS_SETTINGS',
    );
  }

  /// Open Android settings in `Manage Application` section.
  /// returns operation successful or failure.
  Future<bool> manageApplication() {
    return sendCustomMessage('android.settings.MANAGE_APPLICATIONS_SETTINGS');
  }

  /// Open Android settings in `Manage Default Apps` section.
  /// returns operation successful or failure.
  Future<bool> manageDefaultApps() {
    return sendCustomMessage('android.settings.MANAGE_DEFAULT_APPS_SETTINGS');
  }

  /// Open Android settings in `Manage External Sources` section.
  /// returns operation successful or failure.
  Future<bool> manageExternalSources() {
    return sendAndroidAppIntent('android.settings.MANAGE_UNKNOWN_APP_SOURCES');
  }

  /// Open Android settings in `Manage Overlay` section.
  /// returns operation successful or failure.
  Future<bool> manageOverlay() {
    return sendAndroidAppIntent('android.settings.MANAGE_OVERLAY_PERMISSION');
  }
}

/// Android 10+ floating settings panels.
enum AndroidSettingsPanel {
  /// Wi-Fi connectivity controls.
  wifi,

  /// Internet connection controls.
  internetConnectivity,

  /// NFC controls, when supported by the device.
  nfc,

  /// Volume controls for all streams.
  volume,
}
