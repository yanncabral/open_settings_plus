#!/usr/bin/env bash
# Run production Swift against real UIKit/Flutter; URL opening is injected.
# Requires macOS, Xcode, Flutter's iOS artifacts and an installed iOS simulator.
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -z "${FLUTTER_ROOT:-}" ]]; then
  flutter_path="$(command -v flutter)"
  FLUTTER_ROOT="$(python3 -c 'import os,sys; print(os.path.dirname(os.path.dirname(os.path.realpath(sys.argv[1]))))' "$flutter_path")"
fi
framework_dir="$FLUTTER_ROOT/bin/cache/artifacts/engine/ios/Flutter.xcframework/ios-arm64_x86_64-simulator"
if [[ ! -d "$framework_dir/Flutter.framework" ]]; then
  echo 'Flutter iOS artifacts missing. Run flutter precache --ios first.' >&2
  exit 1
fi
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT
simulator_id="${IOS_SIMULATOR_UDID:-$(xcrun simctl list devices available -j | python3 -c 'import json,sys; devices=[d for runtime,group in json.load(sys.stdin)["devices"].items() if ".iOS-" in runtime for d in group if d["isAvailable"]]; print(next((d["udid"] for d in devices if d["state"] == "Booted"), devices[0]["udid"] if devices else ""))')}"
if [[ -z "$simulator_id" ]]; then
  echo 'No available iOS simulator. Install an iOS runtime in Xcode.' >&2
  exit 1
fi
# A device already booted by the developer may be reused.
if ! xcrun simctl list devices booted -j | python3 -c 'import json,sys; target=sys.argv[1]; sys.exit(not any(d["udid"] == target for group in json.load(sys.stdin)["devices"].values() for d in group))' "$simulator_id"; then
  xcrun simctl boot "$simulator_id"
fi
xcrun simctl bootstatus "$simulator_id" -b
architecture="$(uname -m)"
xcrun --sdk iphonesimulator swiftc \
  -target "$architecture-apple-ios15.0-simulator" \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -F "$framework_dir" -framework Flutter \
  -Xlinker -rpath -Xlinker "$framework_dir" \
  "$repo_root/ios/open_settings_plus/Sources/open_settings_plus/OpenSettingsPlusPlugin.swift" \
  "$repo_root/test/native_ios/main.swift" -o "$work_dir/native-tests"
xcrun simctl spawn "$simulator_id" "$work_dir/native-tests"
