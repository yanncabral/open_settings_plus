import Flutter
import UIKit

public class OpenSettingsPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "open_settings_plus", binaryMessenger: registrar.messenger())
    let instance: OpenSettingsPlusPlugin = OpenSettingsPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "openSettings" {
      let arguments = call.arguments as? [String: Any]
      let argument = arguments?["settingToOpen"] as? String ?? ""

      if let url = URL(string: argument), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:]) { success in
          result(success)
        }
      } else {
        result(false)
      }
    } else if call.method == "getIOSVersion" {
      let version = UIDevice.current.systemVersion
      result(version)
    } else {
      result(false)
    }
  }
}
