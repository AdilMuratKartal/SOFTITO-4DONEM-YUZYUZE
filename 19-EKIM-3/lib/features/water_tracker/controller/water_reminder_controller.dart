import 'dart:async';
import 'package:flutter/foundation.dart';

/// Su İçme Hatırlatıcı Zamanlayıcı Kontrolcüsü
class WaterReminderController {
  final ValueNotifier<int> remainingSecondsNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> initialSecondsNotifier = ValueNotifier<int>(60);
  final ValueNotifier<bool> isRunningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isCompletedNotifier = ValueNotifier<bool>(false);

  Timer? _timer;

  int get remainingSeconds => remainingSecondsNotifier.value;
  int get initialSeconds => initialSecondsNotifier.value;
  bool get isRunning => isRunningNotifier.value;
  bool get isCompleted => isCompletedNotifier.value;

  void setDuration(int seconds) {
    if (seconds > 0 && !isRunningNotifier.value) {
      initialSecondsNotifier.value = seconds;
      remainingSecondsNotifier.value = seconds;
      isCompletedNotifier.value = false;
    }
  }

  void startTimer({VoidCallback? onFinished}) {
    if (isRunningNotifier.value) return;

    if (remainingSecondsNotifier.value <= 0) {
      remainingSecondsNotifier.value = initialSecondsNotifier.value;
    }

    isCompletedNotifier.value = false;
    isRunningNotifier.value = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSecondsNotifier.value > 1) {
        remainingSecondsNotifier.value -= 1;
      } else {
        remainingSecondsNotifier.value = 0;
        isRunningNotifier.value = false;
        isCompletedNotifier.value = true;
        _timer?.cancel();
        if (onFinished != null) {
          onFinished();
        }
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    isRunningNotifier.value = false;
  }

  void resetTimer() {
    _timer?.cancel();
    isRunningNotifier.value = false;
    remainingSecondsNotifier.value = initialSecondsNotifier.value;
    isCompletedNotifier.value = false;
  }

  void acknowledgeCompletion() {
    isCompletedNotifier.value = false;
  }

  void dispose() {
    _timer?.cancel();
    remainingSecondsNotifier.dispose();
    initialSecondsNotifier.dispose();
    isRunningNotifier.dispose();
    isCompletedNotifier.dispose();
  }
}
