import 'package:flutter_test/flutter_test.dart';
import 'package:eightclub/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EightClubApp());
    expect(find.text('01'), findsOneWidget);
  });
}
