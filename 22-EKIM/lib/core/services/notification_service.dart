import 'package:flutter/material.dart';

class NotificationService {
  static void scheduleHabitReminder({
    required String habitTitle,
    required String timeString,
  }) {
    // Yerel bildirim planlama simülasyonu / log
    debugPrint('[Bildirim Planlandı] "$habitTitle" için saat $timeString zamanında bildirim ayarlandı.');
  }

  static void cancelHabitReminder(String habitId) {
    debugPrint('[Bildirim İptal Edildi] Alışkanlık ID: $habitId');
  }
}
