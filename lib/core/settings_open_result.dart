/// The outcome of asking the operating system to open a settings screen.
///
/// Opening a screen does not mean that the user changed a setting or granted a
/// permission. Even [opened] only confirms that the system accepted the
/// request.
enum SettingsOpenResult {
  /// The system accepted the requested destination.
  opened,

  /// The requested destination could not open, so the app's settings opened.
  fallbackOpened,

  /// The destination or detailed-opening API is unavailable on this platform.
  unsupported,

  /// The opening request failed, including any enabled fallback.
  failed,
}
