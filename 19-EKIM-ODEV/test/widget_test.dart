import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/main.dart';

void main() {
  testWidgets('iJournal uygulama başlatma ve tema testi', (WidgetTester tester) async {
    await tester.pumpWidget(const IJournalApp());
    await tester.pumpAndSettle();

    expect(find.byType(IJournalApp), findsOneWidget);
    expect(find.byType(MainNavigationShell), findsOneWidget);
  });
}
