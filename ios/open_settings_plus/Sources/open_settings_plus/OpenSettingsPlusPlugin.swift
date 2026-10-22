import Flutter
import UIKit

public class OpenSettingsPlusPlugin: NSObject, FlutterPlugin {
  // Injectable for native tests without launching the Settings app.
  var openURL: (URL, @escaping (Bool) -> Void) -> Void = { url, completion in
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "open_settings_plus", binaryMessenger: registrar.messenger())
    let instance: OpenSettingsPlusPlugin = OpenSettingsPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "openSettings" || call.method == "openSettingsDetailed" else {
      result(FlutterMethodNotImplemented)
      return
    }

    let arguments = call.arguments as? [String: Any]
    if call.method == "openSettingsDetailed" {
      openSettingsDetailed(arguments, result: result)
      return
    }

    if let target = arguments?["settingToOpen"] as? String,
       target == "app-notification-settings" || target == "app-notification-settings:" {
      // The new notification alias uses public APIs; legacy raw URLs stay unchanged.
      openSettingsDetailed(arguments, result: { status in
        result((status as? String) == "opened" || (status as? String) == "fallbackOpened")
      })
      return
    }

    guard let argument = arguments?["settingToOpen"] as? String,
          !argument.isEmpty,
          let url = URL(string: argument),
          url.scheme != nil else {
      result(false)
      return
    }

    openURL(url) { opened in
      result(opened)
    }
  }

  /// Reports whether iOS accepted the URL, not whether a permission changed.
  /// Experimental App-prefs URLs cannot guarantee the exact destination shown.
  private func openSettingsDetailed(_ arguments: [String: Any]?, result: @escaping FlutterResult) {
    guard let target = arguments?["settingToOpen"] as? String,
          !target.isEmpty else {
      result("failed")
      return
    }

    let fallback = arguments?["fallbackToAppSettings"] as? Bool ?? true
    let targetURL: String
    switch target {
    case "app-settings", "app-settings:":
      targetURL = UIApplication.openSettingsURLString
    case "wifi", "bluetooth", "location":
      // The shared API only promises public destinations. Raw App-prefs URLs
      // remain available separately as experimental shortcuts.
      finishWithFallback(enabled: fallback, unavailable: "unsupported", result: result)
      return
    case "app-notification-settings", "app-notification-settings:":
      if #available(iOS 16.0, *) {
        targetURL = UIApplication.openNotificationSettingsURLString
      } else if #available(iOS 15.4, *) {
        targetURL = UIApplicationOpenNotificationSettingsURLString
      } else {
        finishWithFallback(enabled: fallback, unavailable: "unsupported", result: result)
        return
      }
    default:
      targetURL = target
    }

    guard let url = URL(string: targetURL), url.scheme != nil else {
      result("failed")
      return
    }

    openURL(url) { opened in
      if opened {
        result("opened")
      } else {
        // Opening app settings again cannot provide a distinct fallback.
        self.finishWithFallback(
          enabled: fallback && targetURL != UIApplication.openSettingsURLString,
          unavailable: "failed",
          result: result
        )
      }
    }
  }

  private func finishWithFallback(
    enabled: Bool,
    unavailable: String,
    result: @escaping FlutterResult
  ) {
    guard enabled else {
      result(unavailable)
      return
    }
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
      result("failed")
      return
    }
    openURL(url) { opened in
      result(opened ? "fallbackOpened" : "failed")
    }
  }
}
