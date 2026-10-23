import 'package:shared_preferences/shared_preferences.dart';
import '../../features/models/habit_model.dart';
import '../../features/models/category_model.dart';
import '../../features/models/roadmap_model.dart';

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

  static const String _moodPromptShownPrefix = 'mood_prompt_shown_';

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
      await prefs.setBool('$_moodPromptShownPrefix$dateKey', true);
    } catch (_) {}
  }

  static Future<bool> isMoodPromptShownToday(String dateKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_moodPromptShownPrefix$dateKey') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> setMoodPromptShownToday(String dateKey, bool shown) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_moodPromptShownPrefix$dateKey', shown);
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

  static const String _roadmapsKey = 'saved_roadmaps_v1';

  static Future<List<RoadmapModel>> loadRoadmaps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roadmapsJson = prefs.getStringList(_roadmapsKey);
      if (roadmapsJson == null || roadmapsJson.isEmpty) {
        return _getDefaultRoadmaps();
      }
      return roadmapsJson.map((str) => RoadmapModel.fromJsonString(str)).toList();
    } catch (_) {
      return _getDefaultRoadmaps();
    }
  }

  static Future<void> saveRoadmaps(List<RoadmapModel> roadmaps) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = roadmaps.map((r) => r.toJsonString()).toList();
      await prefs.setStringList(_roadmapsKey, list);
    } catch (_) {}
  }

  static List<RoadmapModel> _getDefaultRoadmaps() {
    return [
      const RoadmapModel(
        id: 'rm_1',
        title: '30 Günde Demir İrade & Zindelik',
        category: 'Kişisel Gelişim',
        iconName: '🎯',
        durationWeeks: '4 Hafta',
        nextReward: 'Odak Nişanı',
        isCompleted: false,
        nodes: [
          RoadmapNodeModel(
            id: 'node_1_1',
            stepNumber: 1,
            title: 'Temel Rutin & Sabah Farkındalığı',
            description: 'Her sabah 10 dk nefes egzersizi ve 500ml ılık su ile güne başla.',
            targetDaysStreak: 7,
            linkedHabitIds: ['2'],
            isCompleted: true,
            isLocked: false,
          ),
          RoadmapNodeModel(
            id: 'node_1_2',
            stepNumber: 2,
            title: 'Fiziksel Kondisyon & 5K Koşu',
            description: 'Haftada 3 gün aralıklı tempo koşusu ve bacak güçlendirme antrenmanı.',
            targetDaysStreak: 14,
            linkedHabitIds: ['1'],
            isCompleted: false,
            isLocked: false,
          ),
          RoadmapNodeModel(
            id: 'node_1_3',
            stepNumber: 3,
            title: 'Zihinsel Derinleşme & Kitap Rutini',
            description: 'Günde 20 sayfa kurgu dışı kitap okuma ve günlük özet çıkarma.',
            targetDaysStreak: 21,
            linkedHabitIds: ['3'],
            isCompleted: false,
            isLocked: true,
          ),
        ],
      ),
      const RoadmapModel(
        id: 'rm_2',
        title: 'Dijital Detoks & Uyku Kalitesi',
        category: 'Sağlık',
        iconName: '🌙',
        durationWeeks: '2 Hafta',
        nextReward: 'Derin Dinlenme Rozeti',
        isCompleted: true,
        nodes: [
          RoadmapNodeModel(
            id: 'node_2_1',
            stepNumber: 1,
            title: 'Akşam 22:00 Ekran Kapatma',
            description: 'Yatmadan 1 saat önce tüm mavi ışık kaynaklarını ve bildirimleri kapat.',
            targetDaysStreak: 7,
            linkedHabitIds: [],
            isCompleted: true,
            isLocked: false,
          ),
          RoadmapNodeModel(
            id: 'node_2_2',
            stepNumber: 2,
            title: 'Melatonin & Bitki Çayı Rutini',
            description: 'Papatya çayı ve loş sarı ışık eşliğinde 15 dakika esneme.',
            targetDaysStreak: 10,
            linkedHabitIds: [],
            isCompleted: true,
            isLocked: false,
          ),
        ],
      ),
    ];
  }
}

