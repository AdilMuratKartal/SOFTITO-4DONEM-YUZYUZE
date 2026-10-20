import 'package:flutter/material.dart';
import '../models/app_theme_type.dart';

class ThemeController {
  static final ThemeController instance = ThemeController._internal();
  ThemeController._internal();

  final ValueNotifier<JournalTheme> currentTheme =
      ValueNotifier<JournalTheme>(JournalTheme.journal);

  final ValueNotifier<ThemeMode> currentMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  void setTheme(JournalTheme newTheme) {
    if (currentTheme.value != newTheme) {
      currentTheme.value = newTheme;
    }
  }

  void toggleMode() {
    currentMode.value = currentMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  void setMode(ThemeMode mode) {
    currentMode.value = mode;
  }
}
