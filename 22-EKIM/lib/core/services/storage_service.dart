import 'package:shared_preferences/shared_preferences.dart';
import '../../features/models/habit_model.dart';
import '../../features/models/category_model.dart';

class StorageService {
  static const String _habitsKey = 'saved_habits_v1';
  static const String _categoriesKey = 'saved_categories_v1';
  static const String _moodKeyPrefix = 'saved_mood_';

  static Future<List<HabitModel>> loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList(_habitsKey);
      if (habitsJson == null || habitsJson.isEmpty) {
        return _getDefaultHabits();
      }
      return habitsJson.map((str) => HabitModel.fromJson(str)).toList();
    } catch (_) {
      return _getDefaultHabits();
    }
  }

  static Future<void> saveHabits(List<HabitModel> habits) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = habits.map((h) => h.toJson()).toList();
      await prefs.setStringList(_habitsKey, list);
    } catch (_) {}
  }

  static Future<List<CategoryModel>> loadCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final catJson = prefs.getStringList(_categoriesKey);
      if (catJson == null || catJson.isEmpty) {
        return List.from(CategoryModel.defaultCategories);
      }
      return catJson.map((str) => CategoryModel.fromJson(str)).toList();
    } catch (_) {
      return List.from(CategoryModel.defaultCategories);
    }
  }

  static Future<void> saveCategories(List<CategoryModel> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = categories.map((c) => c.toJson()).toList();
      await prefs.setStringList(_categoriesKey, list);
    } catch (_) {}
  }

  static Future<String?> getTodayMood(String dateKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('$_moodKeyPrefix$dateKey');
    } catch (_) {
      return null;
    }
  }

  static Future<void> setTodayMood(String dateKey, String moodKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_moodKeyPrefix$dateKey', moodKey);
    } catch (_) {}
  }

  static List<HabitModel> _getDefaultHabits() {
    return [
      HabitModel(
        id: '1',
        title: 'Sabah Koşusu ve Esneme',
        categoryId: 'sport',
        iconPath: 'assets/icons/sport.svg',
        type: HabitType.checkmark,
        selectedDays: [1, 2, 3, 4, 5],
        startTime: '09:45',
        endTime: '15:36',
        hasReminder: true,
        currentProgress: 1,
        targetProgress: 1,
        unit: 'kez',
        streakDays: 7,
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      HabitModel(
        id: '2',
        title: 'Su İç (Mikro Adım: 250ml)',
        categoryId: 'health',
        iconPath: 'assets/icons/health.svg',
        type: HabitType.counter,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        startTime: '08:00',
        endTime: '22:00',
        hasReminder: true,
        currentProgress: 1500,
        targetProgress: 2000,
        unit: 'ml',
        streakDays: 12,
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      HabitModel(
        id: '3',
        title: '5 Sayfa Kitap Oku',
        categoryId: 'mind',
        iconPath: 'assets/icons/mind.svg',
        type: HabitType.checkmark,
        selectedDays: [1, 2, 3, 4, 5, 6, 7],
        startTime: '20:00',
        endTime: '21:00',
        hasReminder: false,
        currentProgress: 0,
        targetProgress: 5,
        unit: 'sayfa',
        streakDays: 14,
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      HabitModel(
        id: '4',
        title: 'Gitar Pratiği (Akor Geçişleri)',
        categoryId: 'music',
        iconPath: 'assets/icons/music.svg',
        type: HabitType.checkmark,
        selectedDays: [1, 3, 5, 7],
        startTime: '18:30',
        endTime: '19:15',
        hasReminder: true,
        currentProgress: 1,
        targetProgress: 1,
        unit: 'seans',
        streakDays: 3,
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
