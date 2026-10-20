#!/usr/bin/env bash
# ==============================================================================
# iJournal - Theme System Core Setup Script
# Bu betik, iJournal projesinde 5 farklı görsel tema (NeoBrutalist, Minimalist,
# Journal, Hand-Drawn, Rubber Hose), Light/Dark paletleri, ThemeExtension ve
# ValueNotifier tabanlı ThemeController çekirdek altyapısını lib/core/theme/
# altında eksiksiz olarak kurar.
#
# Kullanım:
#   ./setup_theme_core.sh
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../" && pwd)"

THEME_DIR="${PROJECT_ROOT}/lib/core/theme"
EXT_DIR="${PROJECT_ROOT}/lib/core/extensions"

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  iJournal Tema Sistemi Çekirdek Kurulumu             ${NC}"
echo -e "${BLUE}======================================================${NC}"

# Klasörleri oluştur
mkdir -p "${THEME_DIR}/models"
mkdir -p "${THEME_DIR}/extensions"
mkdir -p "${THEME_DIR}/palettes"
mkdir -p "${THEME_DIR}/controllers"
mkdir -p "${EXT_DIR}"

echo -e "${GREEN}✓ Çekirdek tema dizinleri hazırlandı.${NC}"

# 1. models/app_theme_type.dart
cat <<'EOF' > "${THEME_DIR}/models/app_theme_type.dart"
enum JournalTheme {
  neoBrutalist,
  minimalist,
  journal,
  handDrawn,
  rubberHose;

  String get displayName {
    switch (this) {
      case JournalTheme.neoBrutalist:
        return 'NeoBrutalist';
      case JournalTheme.minimalist:
        return 'Minimalist';
      case JournalTheme.journal:
        return 'Klasik Günlük';
      case JournalTheme.handDrawn:
        return 'El Çizimi (Kraft)';
      case JournalTheme.rubberHose:
        return '1930s Rubber Hose';
    }
  }
}
EOF
echo -e "${GREEN}✓ ${THEME_DIR}/models/app_theme_type.dart${NC}"

# 2. extensions/journal_theme_extension.dart
cat <<'EOF' > "${THEME_DIR}/extensions/journal_theme_extension.dart"
import 'package:flutter/material.dart';

class JournalThemeStyle extends ThemeExtension<JournalThemeStyle> {
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final List<BoxShadow> cardShadow;
  final TextStyle headerFont;

  const JournalThemeStyle({
    required this.borderWidth,
    required this.borderColor,
    required this.borderRadius,
    required this.cardShadow,
    required this.headerFont,
  });

  @override
  JournalThemeStyle copyWith({
    double? borderWidth,
    Color? borderColor,
    double? borderRadius,
    List<BoxShadow>? cardShadow,
    TextStyle? headerFont,
  }) {
    return JournalThemeStyle(
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      cardShadow: cardShadow ?? this.cardShadow,
      headerFont: headerFont ?? this.headerFont,
    );
  }

  @override
  JournalThemeStyle lerp(ThemeExtension<JournalThemeStyle>? other, double t) {
    if (other is! JournalThemeStyle) return this;
    return JournalThemeStyle(
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      cardShadow: cardShadow,
      headerFont: TextStyle.lerp(headerFont, other.headerFont, t) ?? headerFont,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null || b == null) return a;
    return a + (b - a) * t;
  }
}
EOF
echo -e "${GREEN}✓ ${THEME_DIR}/extensions/journal_theme_extension.dart${NC}"

# 3. palettes/neo_brutalist_colors.dart
cat <<'EOF' > "${THEME_DIR}/palettes/neo_brutalist_colors.dart"
import 'package:flutter/material.dart';

abstract class NeoBrutalistColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFFF70A6),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFFFFE500),
    onSurface: Color(0xFF000000),
    error: Color(0xFFFF4365),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFE500),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFCCFF00),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFF1E1E24),
    onSurface: Color(0xFFFFFFFF),
    error: Color(0xFFFF4365),
    onError: Color(0xFFFFFFFF),
  );
}
EOF

# palettes/minimalist_colors.dart
cat <<'EOF' > "${THEME_DIR}/palettes/minimalist_colors.dart"
import 'package:flutter/material.dart';

abstract class MinimalistColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1A1A1A),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF4A6FA5),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1A1A),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF2F2F7),
    onPrimary: Color(0xFF0F0F10),
    secondary: Color(0xFF64D2FF),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    onSurface: Color(0xFFF2F2F7),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
  );
}
EOF

# palettes/journal_classic_colors.dart
cat <<'EOF' > "${THEME_DIR}/palettes/journal_classic_colors.dart"
import 'package:flutter/material.dart';

abstract class JournalClassicColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1B263B),
    onPrimary: Color(0xFFFFFDF8),
    secondary: Color(0xFFD4A373),
    onSecondary: Color(0xFF1B263B),
    surface: Color(0xFFFFFDF8),
    onSurface: Color(0xFF1B263B),
    error: Color(0xFF8A3324),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFE6DFD5),
    onPrimary: Color(0xFF181512),
    secondary: Color(0xFFC69C6D),
    onSecondary: Color(0xFF181512),
    surface: Color(0xFF26211C),
    onSurface: Color(0xFFE6DFD5),
    error: Color(0xFFD48C46),
    onError: Color(0xFF000000),
  );
}
EOF

# palettes/hand_drawn_colors.dart
cat <<'EOF' > "${THEME_DIR}/palettes/hand_drawn_colors.dart"
import 'package:flutter/material.dart';

abstract class HandDrawnColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2B2D42),
    onPrimary: Color(0xFFF4EBD9),
    secondary: Color(0xFFF4A261),
    onSecondary: Color(0xFF2B2D42),
    surface: Color(0xFFFFF9DE),
    onSurface: Color(0xFF2B2D42),
    error: Color(0xFFE76F51),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFECEFF1),
    onPrimary: Color(0xFF1E2229),
    secondary: Color(0xFFFDE68A),
    onSecondary: Color(0xFF1E2229),
    surface: Color(0xFF2C313C),
    onSurface: Color(0xFFECEFF1),
    error: Color(0xFFFCA5A5),
    onError: Color(0xFF1E2229),
  );
}
EOF

# palettes/rubber_hose_colors.dart
cat <<'EOF' > "${THEME_DIR}/palettes/rubber_hose_colors.dart"
import 'package:flutter/material.dart';

abstract class RubberHoseColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF111111),
    onPrimary: Color(0xFFFFF8EA),
    secondary: Color(0xFFC84B31),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFF8EA),
    onSurface: Color(0xFF111111),
    error: Color(0xFFC84B31),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFEDE0C8),
    onPrimary: Color(0xFF12100E),
    secondary: Color(0xFFB58A63),
    onSecondary: Color(0xFF12100E),
    surface: Color(0xFF231F1B),
    onSurface: Color(0xFFEDE0C8),
    error: Color(0xFF9B2226),
    onError: Color(0xFFFFFFFF),
  );
}
EOF
echo -e "${GREEN}✓ 5 Temanın Renk Paletleri Hazırlandı.${NC}"

# 4. app_themes.dart
cat <<'EOF' > "${THEME_DIR}/app_themes.dart"
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
                color: Colors.black.withOpacity(0.08),
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
EOF
echo -e "${GREEN}✓ ${THEME_DIR}/app_themes.dart${NC}"

# 5. controllers/theme_controller.dart
cat <<'EOF' > "${THEME_DIR}/controllers/theme_controller.dart"
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
EOF
echo -e "${GREEN}✓ ${THEME_DIR}/controllers/theme_controller.dart${NC}"

# 6. lib/core/extensions/context_extensions.dart
cat <<'EOF' > "${EXT_DIR}/context_extensions.dart"
import 'package:flutter/material.dart';
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
EOF
echo -e "${GREEN}✓ ${EXT_DIR}/context_extensions.dart${NC}"

echo -e "\n${BLUE}======================================================${NC}"
echo -e "${GREEN}✓ Tema sistemi çekirdek yapısı eksiksiz kuruldu!${NC}"
echo -e "${BLUE}======================================================${NC}"
