import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus_example/open_settings_plus_example_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelOpenSettingsPlusExample platform = MethodChannelOpenSettingsPlusExample();
  const MethodChannel channel = MethodChannel('open_settings_plus_example');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
