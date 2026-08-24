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

      print("OpenSettingsPlusPlugin: \(argument)")

      if let url = URL(string: argument) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    } else {
      result(false)
    }
  }
}
