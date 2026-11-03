import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/services/storage_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

class MoodController {
  final ValueNotifier<String?> todayMoodNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<bool> shouldPromptDailyMoodNotifier = ValueNotifier<bool>(false);

  Future<void> loadTodayMood() async {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month}-${now.day}';
    final saved = await StorageService.getTodayMood(dateKey);
    final shown = await StorageService.isMoodPromptShownToday(dateKey);

    todayMoodNotifier.value = saved;
    // Eğer bugün henüz kaydedilmemişse ve bugün için sorulmamışsa sor
    shouldPromptDailyMoodNotifier.value = !shown && (saved == null);
  }

  void setTodayMood(String moodKey) {
    todayMoodNotifier.value = moodKey;
    shouldPromptDailyMoodNotifier.value = false;
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month}-${now.day}';
    StorageService.setTodayMood(dateKey, moodKey);
  }

  void dismissDailyPrompt() {
    shouldPromptDailyMoodNotifier.value = false;
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month}-${now.day}';
    StorageService.setMoodPromptShownToday(dateKey, true);
  }

  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    todayMoodNotifier.dispose();
    shouldPromptDailyMoodNotifier.dispose();
  }
}
