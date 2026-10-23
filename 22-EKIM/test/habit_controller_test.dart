import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aliskanlik_takibi/features/controllers/habit_controller.dart';
import 'package:aliskanlik_takibi/features/models/category_model.dart';
import 'package:aliskanlik_takibi/features/models/habit_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HabitController & Category & Habit Tests', () {
    test('Initial state loads default 4 core categories', () {
      final controller = HabitController();
      expect(controller.categoriesNotifier.value.length, greaterThanOrEqualTo(4));

      // Core 4 categories check: Spor, Sağlık, Zihin, Müzik
      final names = controller.categoriesNotifier.value.map((c) => c.name).toList();
      expect(names, containsAll(['Spor', 'Sağlık', 'Zihin', 'Müzik']));
    });

    test('Add custom category works dynamically', () {
      final controller = HabitController();
      final initialCount = controller.categoriesNotifier.value.length;

      const newCat = CategoryModel(
        id: 'cat_custom_art',
        name: 'Sanat',
        iconPath: 'assets/icons/palette.svg',
        colorHex: 0xFFF59E0B,
        isCustom: true,
      );

      controller.addCategory(newCat);
      expect(controller.categoriesNotifier.value.length, equals(initialCount + 1));
      expect(controller.categoriesNotifier.value.any((c) => c.name == 'Sanat'), true);
    });

    test('Add habit with time range, days, and reminder toggle', () {
      final controller = HabitController();
      final initialCount = controller.habitsNotifier.value.length;

      final newHabit = HabitModel(
        id: 'habit_test_1',
        title: 'Gitar Pratiği',
        categoryId: 'music',
        iconPath: 'assets/icons/music.svg',
        selectedDays: const [1, 3, 5], // Pzt, Çar, Cum
        startTime: '09:45',
        endTime: '15:36',
        hasReminder: true,
        type: HabitType.checkmark,
        createdAt: DateTime.now(),
      );

      controller.addHabit(newHabit);
      expect(controller.habitsNotifier.value.length, equals(initialCount + 1));

      final saved = controller.habitsNotifier.value.firstWhere((h) => h.id == 'habit_test_1');
      expect(saved.title, 'Gitar Pratiği');
      expect(saved.startTime, '09:45');
      expect(saved.endTime, '15:36');
      expect(saved.selectedDays, [1, 3, 5]);
      expect(saved.hasReminder, true);
    });

    test('Toggle habit completion updates streak and progress', () {
      final controller = HabitController();
      final newHabit = HabitModel(
        id: 'habit_test_toggle',
        title: 'Su İç',
        categoryId: 'health',
        iconPath: 'assets/icons/health.svg',
        startTime: '08:00',
        endTime: '22:00',
        hasReminder: false,
        type: HabitType.checkmark,
        createdAt: DateTime.now(),
      );
      controller.addHabit(newHabit);

      final wasCompleted = newHabit.isCompleted;
      controller.toggleHabit(newHabit.id);

      final updated = controller.habitsNotifier.value.firstWhere((h) => h.id == newHabit.id);
      expect(updated.isCompleted, !wasCompleted);
      expect(updated.streakDays, 1);
    });

    test('Delete habit removes it from list', () {
      final controller = HabitController();
      final newHabit = HabitModel(
        id: 'habit_to_delete',
        title: 'Silinecek Alışkanlık',
        categoryId: 'sport',
        iconPath: 'assets/icons/sport.svg',
        startTime: '10:00',
        endTime: '11:00',
        hasReminder: false,
        createdAt: DateTime.now(),
      );
      controller.addHabit(newHabit);
      expect(controller.habitsNotifier.value.any((h) => h.id == 'habit_to_delete'), true);

      controller.deleteHabit('habit_to_delete');
      expect(controller.habitsNotifier.value.any((h) => h.id == 'habit_to_delete'), false);
    });
  });
}
