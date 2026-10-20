import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ijournal/core/theme/controllers/theme_controller.dart';
import 'package:ijournal/core/theme/models/app_theme_type.dart';
import 'package:ijournal/features/theme_selector/controllers/theme_selector_controller.dart';

void main() {
  group('ThemeSelectorController Tests', () {
    late ThemeSelectorController controller;

    setUp(() {
      controller = ThemeSelectorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('selectTheme çağrıldığında tema güncellenmelidir', () {
      controller.selectTheme(JournalTheme.rubberHose);
      expect(ThemeController.instance.currentTheme.value, JournalTheme.rubberHose);

      controller.selectTheme(JournalTheme.neoBrutalist);
      expect(ThemeController.instance.currentTheme.value, JournalTheme.neoBrutalist);
    });

    test('toggleMode çağrıldığında mod değişmelidir', () {
      ThemeController.instance.setMode(ThemeMode.light);
      controller.toggleMode();
      expect(ThemeController.instance.currentMode.value, ThemeMode.dark);

      controller.toggleMode();
      expect(ThemeController.instance.currentMode.value, ThemeMode.light);
    });
  });
}
