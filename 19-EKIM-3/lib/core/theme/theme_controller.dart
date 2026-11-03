import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz

/// Tema Durumunu Yöneten Reaktif Kontrolcü
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  ThemeMode get themeMode => themeModeNotifier.value;
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.dark) {
      themeModeNotifier.value = ThemeMode.light;
    } else {
      themeModeNotifier.value = ThemeMode.dark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    themeModeNotifier.dispose();
  }
}
