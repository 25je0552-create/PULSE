import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/main.dart';

void main() {
  testWidgets('Pulse app launches and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PulseApp()));
    await tester.pump();
    expect(find.text('PULSE'), findsOneWidget);
    expect(find.text('Continuous care between consultations'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();
  });
}
