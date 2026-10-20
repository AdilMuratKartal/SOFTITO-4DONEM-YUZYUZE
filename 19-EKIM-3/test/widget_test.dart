import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim_v1/core/theme/theme_controller.dart';
import 'package:susadim_v1/features/water_tracker/controller/water_reminder_controller.dart';
import 'package:susadim_v1/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim_v1/features/workout/controller/workout_controller.dart';
import 'package:susadim_v1/main.dart';

void main() {
  group('Susadım v1 Birim ve Widget Testleri', () {
    testWidgets('Uygulama açılır ve temel bileşenler yüklenir',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());
      await tester.pump();

      // Başlık ve temel ekran elemanlarını doğrula
      expect(find.text('Susadım'), findsOneWidget);
      expect(find.text('Günlük Hedef'), findsOneWidget);
      expect(find.text('Su Hatırlatıcı Zamanlayıcı'), findsOneWidget);
    });

    testWidgets('Karanlık / Aydınlık mod geçişi çalışır',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());
      await tester.pump();

      final initialMode = ThemeController.instance.themeMode;
      final themeIcon = initialMode == ThemeMode.dark
          ? Icons.light_mode_rounded
          : Icons.dark_mode_rounded;
      await tester.tap(find.byIcon(themeIcon));
      await tester.pumpAndSettle();

      expect(ThemeController.instance.themeMode != initialMode, isTrue);
    });

    test('WaterTrackerController su ekleme ve sıfırlama testi', () {
      final controller = WaterTrackerController();
      expect(controller.totalWater, 0);

      controller.addWater(250, note: 'Bardak');
      expect(controller.totalWater, 250);
      expect(controller.history.length, 1);

      controller.reset();
      expect(controller.totalWater, 0);
      expect(controller.history.isEmpty, isTrue);
      controller.dispose();
    });

    test('WaterReminderController zamanlayıcı ve süre ayar testi', () {
      final reminder = WaterReminderController();
      expect(reminder.isRunning, isFalse);

      reminder.setDuration(120);
      expect(reminder.remainingSeconds, 120);

      reminder.resetTimer();
      expect(reminder.remainingSeconds, 120);
      reminder.dispose();
    });

    test('WorkoutController egzersiz ekleme ve kalori hesabı testi', () {
      final workoutController = WorkoutController();
      expect(workoutController.totalCalories, 0);
      expect(workoutController.totalMinutes, 0);

      workoutController.addWorkout(
        title: '30 dk Koşu',
        type: 'Koşu',
        durationMinutes: 30,
        caloriesBurned: 280,
      );

      expect(workoutController.totalCalories, 280);
      expect(workoutController.totalMinutes, 30);
      expect(workoutController.recommendedWater, 400);
      expect(workoutController.workouts.length, 1);

      workoutController.reset();
      expect(workoutController.totalCalories, 0);
      expect(workoutController.workouts.isEmpty, isTrue);
      workoutController.dispose();
    });
  });
}
