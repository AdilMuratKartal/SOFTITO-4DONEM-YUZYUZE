import 'package:flutter/material.dart';
import '../../../core/theme/controllers/theme_controller.dart';
import '../../../core/theme/models/app_theme_type.dart';

class ThemeSelectorController {
  final ThemeController _themeController = ThemeController.instance;

  ValueNotifier<JournalTheme> get currentTheme => _themeController.currentTheme;
  ValueNotifier<ThemeMode> get currentMode => _themeController.currentMode;

  void selectTheme(JournalTheme theme) {
    _themeController.setTheme(theme);
  }

  void toggleMode() {
    _themeController.toggleMode();
  }

  void setMode(ThemeMode mode) {
    _themeController.setMode(mode);
  }

  void dispose() {
    // Singleton controller olduğu için ana notifier'lar kapatılmaz.
  }
}
