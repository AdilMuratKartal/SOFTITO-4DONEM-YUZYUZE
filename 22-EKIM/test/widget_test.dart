import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aliskanlik_takibi/main.dart';

void main() {
  testWidgets('HabitTrackerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitTrackerApp());
    await tester.pump();

    // Ana ekranda Bugün başlığı ve BottomNavigationBar görünmeli
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
