import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../theme/extensions/journal_theme_extension.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  JournalThemeStyle get journalStyle =>
      Theme.of(this).extension<JournalThemeStyle>() ??
      const JournalThemeStyle(
        borderWidth: 1.0,
        borderColor: Colors.black,
        borderRadius: 8.0,
        cardShadow: [],
        headerFont: TextStyle(),
      );
}
