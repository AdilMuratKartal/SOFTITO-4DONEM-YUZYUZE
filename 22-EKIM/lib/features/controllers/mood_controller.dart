import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class MoodController {
  final ValueNotifier<String?> todayMoodNotifier = ValueNotifier<String?>(null);

  Future<void> loadTodayMood() async {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month}-${now.day}';
    final saved = await StorageService.getTodayMood(dateKey);
    todayMoodNotifier.value = saved ?? 'great';
  }

  void setTodayMood(String moodKey) {
    todayMoodNotifier.value = moodKey;
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month}-${now.day}';
    StorageService.setTodayMood(dateKey, moodKey);
  }

  void dispose() {
    todayMoodNotifier.dispose();
  }
}
