import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';

enum PomodoroMode { focus, shortBreak, longBreak }

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

  void dispose() {
    _timer?.cancel();
    modeNotifier.dispose();
    remainingSecondsNotifier.dispose();
    isRunningNotifier.dispose();
    completedCyclesNotifier.dispose();
    linkedHabitIdNotifier.dispose();
  }
}
