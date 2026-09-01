import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus_example/open_settings_plus_example.dart';
import 'package:open_settings_plus_example/open_settings_plus_example_platform_interface.dart';
import 'package:open_settings_plus_example/open_settings_plus_example_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpenSettingsPlusExamplePlatform
    with MockPlatformInterfaceMixin
    implements OpenSettingsPlusExamplePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OpenSettingsPlusExamplePlatform initialPlatform = OpenSettingsPlusExamplePlatform.instance;

  test('$MethodChannelOpenSettingsPlusExample is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpenSettingsPlusExample>());
  });

  test('getPlatformVersion', () async {
    OpenSettingsPlusExample openSettingsPlusExamplePlugin = OpenSettingsPlusExample();
    MockOpenSettingsPlusExamplePlatform fakePlatform = MockOpenSettingsPlusExamplePlatform();
    OpenSettingsPlusExamplePlatform.instance = fakePlatform;

    expect(await openSettingsPlusExamplePlugin.getPlatformVersion(), '42');
  });
}
