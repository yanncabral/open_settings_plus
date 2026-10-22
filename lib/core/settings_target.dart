/// Common destinations available through `OpenSettingsPlus.open`.
///
/// Availability depends on the platform and OS version. iOS can use public
/// APIs for this app's settings and notifications; other destinations can
/// fall back to this app's settings when requested.
enum SettingsTarget {
  /// Settings for the calling app, rather than the system's list of apps.
  appSettings,

  /// Notification settings for the calling app.
  notifications,

  /// System Wi-Fi settings.
  wifi,

  /// System Bluetooth settings.
  bluetooth,

  /// System location settings.
  location,
}
