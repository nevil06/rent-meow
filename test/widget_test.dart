import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymanager/main.dart';

void main() {
  testWidgets('MyManagerApp smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MyManagerApp(),
      ),
    );

    // Verify app title and role selector render
    expect(find.text('MYMANAGER'), findsOneWidget);
    expect(find.textContaining('LANDLORD'), findsOneWidget);
    expect(find.textContaining('TENANT'), findsOneWidget);
  });
}
