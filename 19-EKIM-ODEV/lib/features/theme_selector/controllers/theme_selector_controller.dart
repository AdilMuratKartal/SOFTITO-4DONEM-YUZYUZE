import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/controllers/theme_controller.dart'; // Ekranın iş mantığını ve durumlarını yöneten controller/cubit sınıfımızı ekliyoruz
import '../../../core/theme/models/app_theme_type.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz

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

  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    // Singleton controller olduğu için ana notifier'lar kapatılmaz.
  }
}
