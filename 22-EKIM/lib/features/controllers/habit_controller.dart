import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../models/category_model.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/notification_service.dart';

class HabitController {
  final ValueNotifier<List<HabitModel>> habitsNotifier = ValueNotifier<List<HabitModel>>([]);
  final ValueNotifier<List<CategoryModel>> categoriesNotifier =
      ValueNotifier<List<CategoryModel>>(List.from(CategoryModel.defaultCategories));
  final ValueNotifier<String> selectedCategoryNotifier = ValueNotifier<String>('all');
  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier<DateTime>(DateTime.now());

  Future<void> loadDailyHabits() async {
    final loadedCategories = await StorageService.loadCategories();
    categoriesNotifier.value = loadedCategories;

    final loadedHabits = await StorageService.loadHabits();
    habitsNotifier.value = loadedHabits;
  }

  void addHabit(HabitModel habit) {
    habitsNotifier.value = [...habitsNotifier.value, habit];
    StorageService.saveHabits(habitsNotifier.value);

    if (habit.hasReminder) {
      NotificationService.scheduleHabitReminder(
        habitTitle: habit.title,
        timeString: habit.startTime,
        habitId: habit.id,
      );
    }
  }

  void deleteHabit(String id) {
    habitsNotifier.value = habitsNotifier.value.where((h) => h.id != id).toList();
    StorageService.saveHabits(habitsNotifier.value);
    NotificationService.cancelHabitReminder(id);
  }

  void toggleHabit(String id) {
    habitsNotifier.value = habitsNotifier.value.map((h) {
      if (h.id == id) {
        final newCompleted = !h.isCompleted;
        final newStreak = newCompleted
            ? h.streakDays + 1
            : (h.streakDays > 0 ? h.streakDays - 1 : 0);
        return h.copyWith(
          isCompleted: newCompleted,
          streakDays: newStreak,
        );
      }
      return h;
    }).toList();
    StorageService.saveHabits(habitsNotifier.value);
  }

  void incrementProgress(String id, double step) {
    habitsNotifier.value = habitsNotifier.value.map((h) {
      if (h.id == id) {
        final newProgress = (h.currentProgress + step).clamp(0.0, h.targetProgress);
        final completed = newProgress >= h.targetProgress;
        return h.copyWith(
          currentProgress: newProgress,
          isCompleted: completed,
        );
      }
      return h;
    }).toList();
    StorageService.saveHabits(habitsNotifier.value);
  }

  void decrementProgress(String id, double step) {
    habitsNotifier.value = habitsNotifier.value.map((h) {
      if (h.id == id) {
        final newProgress = (h.currentProgress - step).clamp(0.0, h.targetProgress);
        return h.copyWith(
          currentProgress: newProgress,
          isCompleted: newProgress >= h.targetProgress,
        );
      }
      return h;
    }).toList();
    StorageService.saveHabits(habitsNotifier.value);
  }

  void addCategory(CategoryModel category) {
    categoriesNotifier.value = [...categoriesNotifier.value, category];
    selectedCategoryNotifier.value = category.id;
    StorageService.saveCategories(categoriesNotifier.value);
  }

  void filterByCategory(String categoryId) {
    selectedCategoryNotifier.value = categoryId;
  }

  void changeSelectedDate(DateTime date) {
    selectedDateNotifier.value = date;
  }

  void dispose() {
    habitsNotifier.dispose();
    categoriesNotifier.dispose();
    selectedCategoryNotifier.dispose();
    selectedDateNotifier.dispose();
  }
}
