import 'package:flutter_test/flutter_test.dart';
import 'package:school/main.dart';

void main() {
  testWidgets('SmartEducationApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartEducationApp());

    // Verify that login title exists
    expect(find.text('智慧教育远程互动教学系统'), findsOneWidget);
  });
}
