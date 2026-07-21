import 'package:flutter_test/flutter_test.dart';
import 'package:simulapp/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    await tester.pumpWidget(const SimulApp());
    expect(find.byType(SimulApp), findsOneWidget);
  });
}
