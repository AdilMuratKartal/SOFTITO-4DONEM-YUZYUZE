import 'dart:async'; // Asenkron işlemler, Timer ve Stream (veri akışı) yapıları için içeri aktarıyoruz
import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../core/services/notification_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

enum PomodoroMode { focus, shortBreak, longBreak } // PomodoroMode enum yapısı, belirli sabit seçenekleri tip güvenli şekilde listelememizi sağlar

class PomodoroController {
  final ValueNotifier<PomodoroMode> modeNotifier =
      ValueNotifier<PomodoroMode>(PomodoroMode.focus);
  final ValueNotifier<int> remainingSecondsNotifier = ValueNotifier<int>(25 * 60);
  final ValueNotifier<bool> isRunningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> completedCyclesNotifier = ValueNotifier<int>(2);
  final ValueNotifier<String?> linkedHabitIdNotifier = ValueNotifier<String?>('1');

  Timer? _timer;

  void setMode(PomodoroMode mode) {
    pause();
    modeNotifier.value = mode;
    switch (mode) {
      case PomodoroMode.focus:
        remainingSecondsNotifier.value = 25 * 60;
        break;
      case PomodoroMode.shortBreak:
        remainingSecondsNotifier.value = 5 * 60;
        break;
      case PomodoroMode.longBreak:
        remainingSecondsNotifier.value = 15 * 60;
        break;
    }
  }

  void toggleStartPause() {
    if (isRunningNotifier.value) {
      pause();
    } else {
      start();
    }
  }

  void start() {
    isRunningNotifier.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSecondsNotifier.value > 0) {
        remainingSecondsNotifier.value--;
      } else {
        timer.cancel();
        isRunningNotifier.value = false;
        if (modeNotifier.value == PomodoroMode.focus) {
          completedCyclesNotifier.value++;
          NotificationService.showInstantNotification(
            title: '🎉 Odaklanma Seansı Tamamlandı!',
            body: '25 dakikalık oturumu başarıyla bitirdin. Şimdi mola zamanı!',
            id: 8888,
          );
        } else {
          NotificationService.showInstantNotification(
            title: '⏰ Mola Süresi Bitti!',
            body: 'Molan sona erdi. Yeni bir seansa hazır mısın?',
            id: 8889,
          );
        }
      }
    });
  }

  void pause() {
    _timer?.cancel();
    isRunningNotifier.value = false;
  }

  void reset() {
    setMode(modeNotifier.value);
  }

  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _timer?.cancel();
    modeNotifier.dispose();
    remainingSecondsNotifier.dispose();
    isRunningNotifier.dispose();
    completedCyclesNotifier.dispose();
    linkedHabitIdNotifier.dispose();
  }
}
