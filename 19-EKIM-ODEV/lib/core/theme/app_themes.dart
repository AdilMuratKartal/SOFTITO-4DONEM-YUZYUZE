import 'package:flutter/material.dart';
import 'models/app_theme_type.dart';
import 'extensions/journal_theme_extension.dart';
import 'palettes/neo_brutalist_colors.dart';
import 'palettes/minimalist_colors.dart';
import 'palettes/journal_classic_colors.dart';
import 'palettes/hand_drawn_colors.dart';
import 'palettes/rubber_hose_colors.dart';

class AppThemes {
  static ThemeData getTheme(JournalTheme theme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    switch (theme) {
      case JournalTheme.neoBrutalist:
        return _buildTheme(
          colorScheme: isDark ? NeoBrutalistColors.darkColorScheme : NeoBrutalistColors.lightColorScheme,
          scaffoldColor: isDark ? const Color(0xFF121212) : const Color(0xFFFFFDF0),
          extension: JournalThemeStyle(
            borderWidth: 2.5,
            borderColor: isDark ? const Color(0xFFFFE500) : const Color(0xFF000000),
            borderRadius: 8.0,
            cardShadow: const [
              BoxShadow(
                color: Color(0xFF000000),
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
            headerFont: const TextStyle(fontWeight: FontWeight.w900),
          ),
        );

      case JournalTheme.minimalist:
        return _buildTheme(
          colorScheme: isDark ? MinimalistColors.darkColorScheme : MinimalistColors.lightColorScheme,
          scaffoldColor: isDark ? const Color(0xFF0F0F10) : const Color(0xFFFBFBFB),
          extension: JournalThemeStyle(
            borderWidth: 1.0,
            borderColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
            borderRadius: 12.0,
            cardShadow: const [],
            headerFont: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );

      case JournalTheme.journal:
        return _buildTheme(
          colorScheme: isDark ? JournalClassicColors.darkColorScheme : JournalClassicColors.lightColorScheme,
          scaffoldColor: isDark ? const Color(0xFF181512) : const Color(0xFFF5EFEB),
          extension: JournalThemeStyle(
            borderWidth: 1.0,
            borderColor: isDark ? const Color(0xFFC69C6D) : const Color(0xFFD4A373),
            borderRadius: 4.0,
            cardShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
            headerFont: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),
          ),
        );

      case JournalTheme.handDrawn:
        return _buildTheme(
          colorScheme: isDark ? HandDrawnColors.darkColorScheme : HandDrawnColors.lightColorScheme,
          scaffoldColor: isDark ? const Color(0xFF1E2229) : const Color(0xFFF4EBD9),
          extension: JournalThemeStyle(
            borderWidth: 2.0,
            borderColor: isDark ? const Color(0xFFECEFF1) : const Color(0xFF2B2D42),
            borderRadius: 16.0,
            cardShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(2, 3),
                blurRadius: 0,
              ),
            ],
            headerFont: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );

      case JournalTheme.rubberHose:
        return _buildTheme(
          colorScheme: isDark ? RubberHoseColors.darkColorScheme : RubberHoseColors.lightColorScheme,
          scaffoldColor: isDark ? const Color(0xFF12100E) : const Color(0xFFEFE5D0),
          extension: JournalThemeStyle(
            borderWidth: 3.0,
            borderColor: isDark ? const Color(0xFFEDE0C8) : const Color(0xFF111111),
            borderRadius: 20.0,
            cardShadow: const [
              BoxShadow(
                color: Color(0xFF000000),
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
            headerFont: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
        );
    }
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldColor,
    required JournalThemeStyle extension,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      extensions: [extension],
    );
  }
}
