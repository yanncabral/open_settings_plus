import 'package:flutter_test/flutter_test.dart';
import 'package:open_settings_plus_example/main.dart';

void main() {
  testWidgets('unsupported host shows the platform message', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Open settings +'), findsOneWidget);
    expect(find.text('Unsupported platform.'), findsOneWidget);
  });
}
