part of 'open_settings_plus.dart';

/// The major iOS version at which Apple switched from `App-prefs:` URL
/// schemes to the new `settings-navigation://` scheme.
const int _ios26MajorVersion = 26;

/// {@template open_settings_plus_ios}
/// The iOS implementation of [OpenSettingsPlus].
///
/// Opens specific iOS Settings screens using URL schemes.
///
/// - On **iOS 26+**, the new `settings-navigation://` URL scheme is used.
/// - On **iOS 25 and earlier**, the legacy `App-prefs:` URL scheme is used.
/// {@endtemplate}
class OpenSettingsPlusIOS extends OpenSettingsPlus {
  /// {@macro open_settings_plus_ios}
  const OpenSettingsPlusIOS();

  /// Cached result of the iOS version check (lazily initialized once).
  /// [null] means the version has not been checked yet.
  static bool? ios26OrLater;

  /// Resets the cached iOS version check.
  ///
  /// Primarily used in tests. In production the result is cached after the
  /// first lookup.
  @visibleForTesting
  static void resetIOSVersionCache() {
    ios26OrLater = null;
  }

  /// Returns `true` if the device is running iOS 26 or later.
  ///
  /// The result is cached after the first call so subsequent lookups are free.
  Future<bool> _isIOS26OrLater() async {
    if (ios26OrLater != null) return ios26OrLater!;
    final version = await OpenSettingsPlusPlatform.instance.getIOSVersion();
    final major = int.tryParse(version.split('.').first) ?? 0;
    ios26OrLater = major >= _ios26MajorVersion;
    return ios26OrLater!;
  }

  /// Returns the appropriate URL string for the current iOS version.
  ///
  /// On iOS 26+ [newUrl] is returned; otherwise [oldUrl] is returned.
  Future<String> _urlForVersion(String oldUrl, String newUrl) async {
    return (await _isIOS26OrLater()) ? newUrl : oldUrl;
  }

  // ---------------------------------------------------------------------------
  // Root / Generic
  // ---------------------------------------------------------------------------

  /// Shorthand for [settings].
  Future<bool> call() => settings();

  /// Opens the iOS Settings app (root screen).
  ///
  /// This is the main Settings page with no specific section selected.
  ///
  /// - iOS 26+: `App-prefs:` (unchanged — root Settings has no new equivalent).
  /// - iOS <26: `App-prefs:`
  ///
  /// Returns `true` if the Settings app was opened, `false` otherwise.
  Future<bool> settings() {
    return sendCustomMessage('App-prefs:');
  }

  /// Opens the current app's own Settings page.
  ///
  /// Uses the official `app-settings:` URL scheme supported by Apple.
  ///
  /// Returns `true` if the Settings app was opened, `false` otherwise.
  Future<bool> appSettings() {
    return sendCustomMessage('app-settings:');
  }

  // ---------------------------------------------------------------------------
  // General
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **General → About**.
  ///
  /// Displays device name, software version, model, serial number, etc.
  ///
  /// - iOS 26+: `App-prefs:General&path=About` (no new equivalent catalogued yet).
  /// - iOS <26: `App-Prefs:General&path=About`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> about() {
    return sendCustomMessage('App-Prefs:General&path=About');
  }

  /// Opens iOS Settings → **General**.
  ///
  /// - iOS 26+: `App-prefs:General` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> general() {
    return sendCustomMessage('App-prefs:General');
  }

  /// Opens iOS Settings → **General → Accessibility**.
  ///
  /// Contains VoiceOver, Zoom, Display & Text Size, and more.
  ///
  /// - iOS 26+: `App-prefs:ACCESSIBILITY` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:ACCESSIBILITY`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> accessibility() {
    return sendCustomMessage('App-prefs:ACCESSIBILITY');
  }

  /// Opens iOS Settings → **Display & Brightness → Auto Lock**.
  ///
  /// - iOS 26+: `App-prefs:DISPLAY&path=AUTOLOCK` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:DISPLAY&path=AUTOLOCK`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> autoLock() {
    return sendCustomMessage('App-prefs:DISPLAY&path=AUTOLOCK');
  }

  /// Opens iOS Settings → **General → Dictionary**.
  ///
  /// - iOS 26+: `App-prefs:General&path=DICTIONARY` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=DICTIONARY`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> dictionary() {
    return sendCustomMessage('App-prefs:General&path=DICTIONARY');
  }

  /// Opens iOS Settings → **General → Date & Time**.
  ///
  /// - iOS 26+: `App-prefs:General&path=DATE_AND_TIME` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=DATE_AND_TIME`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> dateAndTime() {
    return sendCustomMessage('App-prefs:General&path=DATE_AND_TIME');
  }

  /// Opens iOS Settings → **General → Keyboard**.
  ///
  /// - iOS 26+: `App-prefs:General&path=Keyboard` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=Keyboard`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> keyboard() {
    return sendCustomMessage('App-prefs:General&path=Keyboard');
  }

  /// Opens iOS Settings → **General → Keyboard → Keyboards**.
  ///
  /// Shows the list of installed software keyboards.
  ///
  /// - iOS 26+: `App-prefs:General&path=Keyboard/KEYBOARDS` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=Keyboard/KEYBOARDS`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> keyboards() {
    return sendCustomMessage('App-prefs:General&path=Keyboard/KEYBOARDS');
  }

  /// Opens iOS Settings → **General → Language & Region**.
  ///
  /// - iOS 26+: `App-prefs:General&path=INTERNATIONAL` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=INTERNATIONAL`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> languageAndRegion() {
    return sendCustomMessage('App-prefs:General&path=INTERNATIONAL');
  }

  /// Opens iOS Settings → **General → VPN & Device Management**.
  ///
  /// - iOS 26+: `App-prefs:General&path=ManagedConfigurationList` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=ManagedConfigurationList`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> profilesAndDeviceManagement() {
    return sendCustomMessage('App-prefs:General&path=ManagedConfigurationList');
  }

  /// Opens iOS Settings → **General → Software Update**.
  ///
  /// - iOS 26+: `App-prefs:General&path=SOFTWARE_UPDATE_LINK` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:General&path=SOFTWARE_UPDATE_LINK`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> softwareUpdate() {
    return sendCustomMessage('App-prefs:General&path=SOFTWARE_UPDATE_LINK');
  }

  // ---------------------------------------------------------------------------
  // Display & Brightness
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Display & Brightness**.
  ///
  /// - iOS 26+: `App-prefs:DISPLAY` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:DISPLAY`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> displayAndBrightness() {
    return sendCustomMessage('App-prefs:DISPLAY');
  }

  /// Opens iOS Settings → **Display & Brightness → Wallpapers**.
  ///
  /// - iOS 26+: `App-prefs:Wallpaper` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:Wallpaper`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> wallpapers() {
    return sendCustomMessage('App-prefs:Wallpaper');
  }

  // ---------------------------------------------------------------------------
  // Connectivity
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Wi-Fi**.
  ///
  /// - iOS 26+: `App-Prefs:WIFI` (no new equivalent catalogued yet).
  /// - iOS <26: `App-Prefs:WIFI`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> wifi() {
    return sendCustomMessage('App-Prefs:WIFI');
  }

  /// Opens iOS Settings → **Bluetooth**.
  ///
  /// - iOS 26+: `App-prefs:Bluetooth` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:Bluetooth`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> bluetooth() {
    return sendCustomMessage('App-prefs:Bluetooth');
  }

  /// Opens iOS Settings → **Cellular**.
  ///
  /// - iOS 26+: `App-prefs:MOBILE_DATA_SETTINGS_ID` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:MOBILE_DATA_SETTINGS_ID`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> cellular() {
    return sendCustomMessage('App-prefs:MOBILE_DATA_SETTINGS_ID');
  }

  /// Opens iOS Settings → **Personal Hotspot**.
  ///
  /// - iOS 26+: `App-prefs:INTERNET_TETHERING` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:INTERNET_TETHERING`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> personalHotspot() {
    return sendCustomMessage('App-prefs:INTERNET_TETHERING');
  }

  // ---------------------------------------------------------------------------
  // Phone / FaceTime
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Phone**.
  ///
  /// - iOS 26+: `App-prefs:Phone` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:Phone`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> phone() {
    return sendCustomMessage('App-prefs:Phone');
  }

  /// Opens iOS Settings → **FaceTime**.
  ///
  /// - iOS 26+: `App-prefs:FACETIME` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:FACETIME`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> facetime() {
    return sendCustomMessage('App-prefs:FACETIME');
  }

  // ---------------------------------------------------------------------------
  // Sounds & Siri
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Sounds & Haptics**.
  ///
  /// - iOS 26+: `App-prefs:Sounds` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:Sounds`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> soundsAndHaptics() {
    return sendCustomMessage('App-prefs:Sounds');
  }

  /// Opens iOS Settings → **Siri**.
  ///
  /// - iOS 26+: `App-prefs:SIRI` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:SIRI`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> siri() {
    return sendCustomMessage('App-prefs:SIRI');
  }

  // ---------------------------------------------------------------------------
  // Battery
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Battery**.
  ///
  /// Shows battery level, usage by app, and Low Power Mode toggle.
  ///
  /// - iOS 26+: `App-prefs:BATTERY_USAGE` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:BATTERY_USAGE`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> battery() {
    return sendCustomMessage('App-prefs:BATTERY_USAGE');
  }

  // ---------------------------------------------------------------------------
  // Security
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Face ID & Passcode**.
  ///
  /// - iOS 26+: `App-prefs:TOUCHID_PASSCODE` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:TOUCHID_PASSCODE`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> faceIDAndPasscode() {
    return sendCustomMessage('App-prefs:TOUCHID_PASSCODE');
  }

  // ---------------------------------------------------------------------------
  // Health
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Health → Data Access & Devices**.
  ///
  /// - iOS 26+: `App-prefs:HEALTH&path=SOURCES` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:HEALTH&path=SOURCES`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> healthKit() {
    return sendCustomMessage('App-prefs:HEALTH&path=SOURCES');
  }

  // ---------------------------------------------------------------------------
  // Music
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Music**.
  ///
  /// - iOS 26+: `App-prefs:MUSIC` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:MUSIC`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> music() {
    return sendCustomMessage('App-prefs:MUSIC');
  }

  // ---------------------------------------------------------------------------
  // Photos
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Photos**.
  ///
  /// - iOS 26+: `App-prefs:Photos` (no new equivalent catalogued yet).
  /// - iOS <26: `App-prefs:Photos`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> photosAndCamera() {
    return sendCustomMessage('App-prefs:Photos');
  }

  // ============================================================================
  // Version-aware methods (App-prefs → settings-navigation on iOS 26+)
  // ============================================================================

  /// Opens iOS Settings → **Apple Account** (formerly iCloud / Account Settings).
  ///
  /// Shows Apple ID, iCloud, Media & Purchases, Family Sharing, etc.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount`
  /// - iOS <26: `App-prefs:ACCOUNT_SETTINGS`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> accountSettings() async {
    return sendCustomMessage(
      await _urlForVersion(
        'App-prefs:ACCOUNT_SETTINGS',
        'settings-navigation://com.apple.Settings.AppleAccount',
      ),
    );
  }

  /// Opens iOS Settings → **iCloud**.
  ///
  /// Shows iCloud storage, apps using iCloud, and iCloud Backup.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE`
  /// - iOS <26: `App-prefs:CASTLE`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloud() async {
    return sendCustomMessage(
      await _urlForVersion(
        'App-prefs:CASTLE',
        'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE',
      ),
    );
  }

  /// Opens iOS Settings → **iCloud → iCloud Storage**.
  ///
  /// Shows iCloud storage plan and management.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/STORAGE_AND_BACKUP`
  /// - iOS <26: `App-prefs:CASTLE&path=STORAGE_AND_BACKUP`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> storageAndBackup() async {
    return sendCustomMessage(
      await _urlForVersion(
        'App-prefs:CASTLE&path=STORAGE_AND_BACKUP',
        'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/STORAGE_AND_BACKUP',
      ),
    );
  }

  /// Opens iOS Settings → **Privacy & Security**.
  ///
  /// Shows Location Services, Tracking, and permission settings for apps.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity`
  /// - iOS <26: `App-prefs:Privacy`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacy() async {
    return sendCustomMessage(
      await _urlForVersion(
        'App-prefs:Privacy',
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity',
      ),
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Location Services**.
  ///
  /// Shows the master Location Services toggle and per-app location permissions.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/LOCATION`
  /// - iOS <26: `App-prefs:LOCATION_SERVICES`
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> locationServices() async {
    return sendCustomMessage(
      await _urlForVersion(
        'App-prefs:LOCATION_SERVICES',
        'settings-navigation://com.apple.Settings.PrivacyAndSecurity/LOCATION',
      ),
    );
  }

  // ============================================================================
  // NEW in iOS 26+ (settings-navigation:// only)
  // ============================================================================

  // ---------------------------------------------------------------------------
  // Apple Account sub-sections
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Apple Account → Contact Key Verification**.
  ///
  /// Manages contact key verification for iMessage.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/TRANSPARENCY`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> contactKeyVerification() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/TRANSPARENCY',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → iCloud Drive**.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Ubiquity`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudDrive() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Ubiquity',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Photos**.
  ///
  /// Manages iCloud Photos sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.MediaStream`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudPhotos() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.MediaStream',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Mail**.
  ///
  /// Manages iCloud Mail sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Mail`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudMail() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Mail',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Contacts**.
  ///
  /// Manages iCloud Contacts sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Contacts`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudContacts() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Contacts',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Calendar**.
  ///
  /// Manages iCloud Calendar sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Calendars`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudCalendar() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Calendars',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Reminders**.
  ///
  /// Manages iCloud Reminders sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Reminders`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudReminders() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Reminders',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Safari**.
  ///
  /// Manages iCloud Safari (bookmarks, history, open tabs) sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Bookmarks`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudSafari() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Bookmarks',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Notes**.
  ///
  /// Manages iCloud Notes sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Notes`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudNotes() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Notes',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → News**.
  ///
  /// Manages iCloud News sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.News`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudNews() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.News',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Backup**.
  ///
  /// Manages iCloud Backup settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/BACKUP`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudBackup() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/BACKUP',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Health**.
  ///
  /// Manages iCloud Health data sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Health`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudHealth() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.Health',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Passwords & Keychain**.
  ///
  /// Manages iCloud Keychain sync settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.KeychainSync`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudPasswordsAndKeychain() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/com.apple.Dataclass.KeychainSync',
    );
  }

  /// Opens iOS Settings → **Apple Account → iCloud → Hide My Email**.
  ///
  /// Manages Hide My Email addresses.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/PRIVATE_EMAIL_MANAGE`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> iCloudHideMyEmail() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/ICLOUD_SERVICE/PRIVATE_EMAIL_MANAGE',
    );
  }

  /// Opens iOS Settings → **Apple Account → Share My Location → Find My**.
  ///
  /// Manages Find My device location sharing settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/LOCATION_SHARING/FindMyDevice-Settings`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> findMyDevice() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/LOCATION_SHARING/FindMyDevice-Settings',
    );
  }

  /// Opens iOS Settings → **Apple Account → Name, Phone Numbers, Email**.
  ///
  /// Edit your Apple ID name, phone numbers, and email addresses.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/APPLE_ACCOUNT_CONTACT`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> appleAccountContact() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/APPLE_ACCOUNT_CONTACT',
    );
  }

  /// Opens iOS Settings → **Apple Account → Password & Security**.
  ///
  /// Manage your Apple ID password, two-factor authentication, and trusted
  /// devices.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/PASSWORD_AND_SECURITY`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> appleAccountPasswordAndSecurity() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/PASSWORD_AND_SECURITY',
    );
  }

  /// Opens iOS Settings → **Apple Account → Payment & Shipping**.
  ///
  /// Manage payment methods and shipping addresses for your Apple ID.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/PAYMENT_AND_SHIPPING`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> appleAccountPaymentAndShipping() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/PAYMENT_AND_SHIPPING',
    );
  }

  /// Opens iOS Settings → **Apple Account → Subscriptions**.
  ///
  /// Manage active and expired App Store and Apple service subscriptions.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/SUBSCRIPTIONS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> appleAccountSubscriptions() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/SUBSCRIPTIONS',
    );
  }

  /// Opens iOS Settings → **Apple Account → Family**.
  ///
  /// Manage Family Sharing members, purchase sharing, and parental controls.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.AppleAccount/Family`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> appleAccountFamily() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.AppleAccount/Family',
    );
  }

  // ---------------------------------------------------------------------------
  // Privacy & Security sub-sections
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Privacy & Security → Health**.
  ///
  /// Shows which apps have access to Health data.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/HEALTH`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyHealth() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/HEALTH',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Health Data**.
  ///
  /// Manages Health data access permissions.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/HEALTH_DATA`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyHealthData() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/HEALTH_DATA',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Location → Share My Location**.
  ///
  /// Manages location sharing with family and friends.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/LOCATION/LOCATION_SHARING`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyShareMyLocation() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/LOCATION/LOCATION_SHARING',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Contacts**.
  ///
  /// Shows which apps have access to your contacts.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/CONTACTS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyContacts() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/CONTACTS',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Calendars**.
  ///
  /// Shows which apps have access to your calendars.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/CALENDARS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyCalendars() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/CALENDARS',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Reminders**.
  ///
  /// Shows which apps have access to your reminders.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/REMINDERS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyReminders() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/REMINDERS',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Photos**.
  ///
  /// Shows which apps have access to your photo library.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/PHOTOS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyPhotos() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/PHOTOS',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Bluetooth Sharing**.
  ///
  /// Shows which apps have access to Bluetooth devices.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/BT_PERIPHERAL`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyBluetoothSharing() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/BT_PERIPHERAL',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Microphone**.
  ///
  /// Shows which apps have access to the microphone.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/MICROPHONE`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyMicrophone() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/MICROPHONE',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Speech Recognition**.
  ///
  /// Shows which apps can access speech recognition.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/SPEECH_RECOGNITION`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacySpeechRecognition() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/SPEECH_RECOGNITION',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Camera**.
  ///
  /// Shows which apps have access to the camera.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/CAMERA`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyCamera() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/CAMERA',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → HomeKit**.
  ///
  /// Shows which apps have access to your HomeKit accessories.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/WILLOW`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyHomeKit() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/WILLOW',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Media & Apple Music**.
  ///
  /// Shows which apps have access to your media library and Apple Music.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/MEDIALIBRARY`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyMediaAndAppleMusic() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/MEDIALIBRARY',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Analytics & Improvements**.
  ///
  /// Manage sharing of analytics data with Apple.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/PROBLEM_REPORTING`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyAnalytics() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/PROBLEM_REPORTING',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Apple Advertising**.
  ///
  /// Manage Apple's interest-based advertising settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/ADVERTISING`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyAdvertising() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/ADVERTISING',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Files and Folders**.
  ///
  /// Shows which apps have access to your files and folders.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/FILEACCESS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyFilesAndFolders() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/FILEACCESS',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Tracking**.
  ///
  /// Manage app tracking transparency (ATT) settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/USER_TRACKING`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyTracking() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/USER_TRACKING',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → App Privacy Report**.
  ///
  /// Shows a report of how apps access sensors, contacts, and other data.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/PRIVACY_REPORT`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyAppPrivacyReport() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/PRIVACY_REPORT',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Safety Check**.
  ///
  /// Review and manage sharing permissions and account security.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity/SAFETY_CHECK`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacySafetyCheck() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity/SAFETY_CHECK',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Lockdown Mode**.
  ///
  /// Extreme protection for users who may be targeted by sophisticated
  /// attacks.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity#LOCKDOWN_MODE#LOCKDOWN_MODE`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacyLockdownMode() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity#LOCKDOWN_MODE#LOCKDOWN_MODE',
    );
  }

  /// Opens iOS Settings → **Privacy & Security → Sensitive Content Warning**.
  ///
  /// Manage sensitive content detection settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.PrivacyAndSecurity#NUDITY_DETECTION#NUDITY_DETECTION`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> privacySensitiveContent() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.PrivacyAndSecurity#NUDITY_DETECTION#NUDITY_DETECTION',
    );
  }

  // ---------------------------------------------------------------------------
  // Apps
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Apps**.
  ///
  /// Shows the list of all installed apps and their settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> apps() {
    return sendCustomMessage('settings-navigation://com.apple.Settings.Apps');
  }

  /// Opens iOS Settings → **Apps → Safari**.
  ///
  /// Safari browser settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> safari() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/',
    );
  }

  /// Opens iOS Settings → **Apps → Safari → Extensions**.
  ///
  /// Manage Safari extensions.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/WEB_EXTENSIONS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> safariExtensions() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/WEB_EXTENSIONS',
    );
  }

  /// Opens iOS Settings → **Apps → Safari → Block Pop-ups**.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari#BLOCK_POPUPS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> safariBlockPopUps() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari#BLOCK_POPUPS',
    );
  }

  /// Opens iOS Settings → **Apps → Safari → Prevent Cross-Site Tracking**.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari#TRACKER_PROTECTION`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> safariPreventCrossSiteTracking() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari#TRACKER_PROTECTION',
    );
  }

  /// Opens iOS Settings → **Apps → Safari → AutoFill**.
  ///
  /// Manage Safari AutoFill for contact info and credit cards.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/AUTO_FILL`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> safariAutoFill() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/AUTO_FILL',
    );
  }

  /// Opens iOS Settings → **Apps → Safari → Downloads**.
  ///
  /// Manage where Safari saves downloaded files.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/DOWNLOADS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> safariDownloads() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilesafari/DOWNLOADS',
    );
  }

  /// Opens iOS Settings → **Apps → Passwords**.
  ///
  /// Shows saved passwords, passkeys, and security recommendations.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.Passwords`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> passwords() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.Passwords',
    );
  }

  /// Opens iOS Settings → **Apps → Passwords → Security Recommendations**.
  ///
  /// Shows password security recommendations (weak, reused, compromised).
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.Passwords#SECURITY_RECOMMENDATIONS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> passwordsSecurityRecommendations() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.Passwords#SECURITY_RECOMMENDATIONS',
    );
  }

  // ---------------------------------------------------------------------------
  // Apps → Notes
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Apps → Notes**.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notes() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Default Account**.
  ///
  /// Choose which account new notes are saved to by default.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Default%20Account`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesDefaultAccount() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Default%20Account',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Password**.
  ///
  /// Set a password for notes locked on this device.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Password`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesPassword() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Password',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Sort Notes By**.
  ///
  /// Choose how notes are sorted (by date created or date modified).
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Sort%20Notes%20By`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesSortNotesBy() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Sort%20Notes%20By',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → New Notes Start With**.
  ///
  /// Choose the default heading or body style for new notes.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/New%20Notes%20Start%20With`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesNewNotesStartWith() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/New%20Notes%20Start%20With',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Sort Checked Items**.
  ///
  /// Choose whether checked items move to the bottom of a list.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Sort%20Checked%20Items`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesSortCheckedItems() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Sort%20Checked%20Items',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Lines & Grids**.
  ///
  /// Choose the default line or grid style for new notes.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Lines%20%26%20Grids`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesLinesAndGrids() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Lines%20%26%20Grids',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Save to Photos**.
  ///
  /// Manage whether notes with photos are saved to the Photos app.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes#Save%20to%20Photos#Save%20to%20Photos`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesSaveToPhotos() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes#Save%20to%20Photos#Save%20to%20Photos',
    );
  }

  /// Opens iOS Settings → **Apps → Notes → Access Notes from Lock Screen**.
  ///
  /// Configure whether locked notes can be accessed from the lock screen.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Access%20Notes%20from%20Lock%20Screen`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> notesAccessFromLockScreen() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.mobilenotes/Access%20Notes%20from%20Lock%20Screen',
    );
  }

  // ---------------------------------------------------------------------------
  // Apps → Measure
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Apps → Measure**.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.measure`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> measure() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.measure',
    );
  }

  /// Opens iOS Settings → **Apps → Measure → Measure Units**.
  ///
  /// Choose between metric and imperial measurement units.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Apps/com.apple.measure#MEASURE_UNITS#MEASURE_UNITS`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> measureUnits() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.Apps/com.apple.measure#MEASURE_UNITS#MEASURE_UNITS',
    );
  }

  // ---------------------------------------------------------------------------
  // Standalone (new in iOS 26)
  // ---------------------------------------------------------------------------

  /// Opens iOS Settings → **Home**.
  ///
  /// Manage HomeKit and home automation settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.HomeKit`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> home() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.HomeKit',
    );
  }

  /// Opens iOS Settings → **Search**.
  ///
  /// Configure iOS Settings search behavior.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.Search`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> search() {
    return sendCustomMessage('settings-navigation://com.apple.Settings.Search');
  }

  /// Opens iOS Settings → **TV Provider**.
  ///
  /// Manage TV provider single sign-on settings.
  ///
  /// - iOS 26+: `settings-navigation://com.apple.Settings.TVProvider`
  /// - iOS <26: Not available (returns `false`).
  ///
  /// Returns `true` if the screen was opened, `false` otherwise.
  Future<bool> tvProvider() {
    return sendCustomMessage(
      'settings-navigation://com.apple.Settings.TVProvider',
    );
  }
}
