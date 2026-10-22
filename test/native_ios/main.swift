// Compiled with the production plugin, real UIKit and Flutter for iOS Simulator.
// Inject only URL opening: never navigate the simulator away from the test runner.
import Foundation
import Flutter
import UIKit

private var assertions = 0
private func check(_ condition: @autoclosure () -> Bool, _ message: String) {
  assertions += 1
  guard condition() else {
    fputs("FAIL: \(message)\n", stderr)
    exit(1)
  }
}

private func invoke(
  method: String = "openSettingsDetailed",
  arguments: Any?,
  outcomes: [Bool],
  expected: Any,
  expectedURLs: [String]
) {
  let plugin = OpenSettingsPlusPlugin()
  var urls: [String] = []
  var calls = 0
  var received: Any?
  plugin.openURL = { url, completion in
    urls.append(url.absoluteString)
    check(urls.count <= outcomes.count, "unexpected URL open: \(url)")
    completion(outcomes[urls.count - 1])
  }
  plugin.handle(FlutterMethodCall(methodName: method, arguments: arguments)) { result in
    calls += 1
    received = result
  }
  check(calls == 1, "\(method) must complete exactly once; completed \(calls) times")
  check(NSDictionary(dictionary: ["result": received ?? NSNull()]) ==
    NSDictionary(dictionary: ["result": expected]), "unexpected result: \(String(describing: received))")
  check(urls == expectedURLs, "unexpected URL sequence: \(urls)")
}

// The channel must complete from the asynchronous OS callback, not before it.
for method in ["openSettings", "openSettingsDetailed"] {
  let deferredPlugin = OpenSettingsPlusPlugin()
  var complete: ((Bool) -> Void)?
  var callbacks = 0
  var response: Any?
  deferredPlugin.openURL = { _, completion in complete = completion }
  deferredPlugin.handle(FlutterMethodCall(methodName: method,
    arguments: ["settingToOpen": "app-settings:"])) { value in
    callbacks += 1
    response = value
  }
  check(callbacks == 0, "result must wait for OS completion")
  check(complete != nil, "must request URL opening")
  complete?(true)
  check(callbacks == 1, "deferred result must complete exactly once")
  if method == "openSettings" {
    check(response as? Bool == true, "legacy deferred success")
  } else {
    check(response as? String == "opened", "detailed deferred success")
  }
}
for opened in [true, false] {
  invoke(method: "openSettings", arguments: ["settingToOpen": "app-settings:"],
    outcomes: [opened], expected: opened, expectedURLs: ["app-settings:"])
}
for arguments: Any? in [nil, "invalid", [:], ["settingToOpen": 42],
                         ["settingToOpen": ""], ["settingToOpen": "relative/path"]] {
  invoke(method: "openSettings", arguments: arguments,
    outcomes: [], expected: false, expectedURLs: [])
  invoke(arguments: arguments, outcomes: [], expected: "failed", expectedURLs: [])
}
let experimental = "App-prefs:WIFI"
invoke(arguments: ["settingToOpen": experimental], outcomes: [true],
  expected: "opened", expectedURLs: [experimental])
invoke(arguments: ["settingToOpen": experimental], outcomes: [false, true],
  expected: "fallbackOpened", expectedURLs: [experimental, UIApplication.openSettingsURLString])
invoke(arguments: ["settingToOpen": experimental], outcomes: [false, false],
  expected: "failed", expectedURLs: [experimental, UIApplication.openSettingsURLString])
invoke(arguments: ["settingToOpen": experimental, "fallbackToAppSettings": false],
  outcomes: [false], expected: "failed", expectedURLs: [experimental])
for target in ["app-settings", "app-settings:"] {
  invoke(arguments: ["settingToOpen": target], outcomes: [false], expected: "failed",
    expectedURLs: [UIApplication.openSettingsURLString])
}
if #available(iOS 16.0, *) {
  for target in ["app-notification-settings", "app-notification-settings:"] {
    invoke(arguments: ["settingToOpen": target], outcomes: [true], expected: "opened",
      expectedURLs: [UIApplication.openNotificationSettingsURLString])
    invoke(method: "openSettings", arguments: ["settingToOpen": target],
      outcomes: [false, true], expected: true,
      expectedURLs: [UIApplication.openNotificationSettingsURLString, UIApplication.openSettingsURLString])
  }
} else if #available(iOS 15.4, *) {
  invoke(arguments: ["settingToOpen": "app-notification-settings"], outcomes: [true],
    expected: "opened", expectedURLs: [UIApplicationOpenNotificationSettingsURLString])
} else {
  invoke(arguments: ["settingToOpen": "app-notification-settings", "fallbackToAppSettings": false],
    outcomes: [], expected: "unsupported", expectedURLs: [])
  invoke(arguments: ["settingToOpen": "app-notification-settings"], outcomes: [true],
    expected: "fallbackOpened", expectedURLs: [UIApplication.openSettingsURLString])
}
for target in ["wifi", "bluetooth", "location"] {
  invoke(arguments: ["settingToOpen": target, "fallbackToAppSettings": false],
    outcomes: [], expected: "unsupported", expectedURLs: [])
  invoke(arguments: ["settingToOpen": target], outcomes: [true],
    expected: "fallbackOpened", expectedURLs: [UIApplication.openSettingsURLString])
}
let plugin = OpenSettingsPlusPlugin()
var unknownResults = 0
plugin.handle(FlutterMethodCall(methodName: "unknown", arguments: nil)) { result in
  unknownResults += 1
  check((result as AnyObject?) === (FlutterMethodNotImplemented as AnyObject),
    "unknown methods must preserve FlutterMethodNotImplemented")
}
check(unknownResults == 1, "unknown method must complete once")
print("PASS: \(assertions) native iOS assertions (iOS \(UIDevice.current.systemVersion))")
