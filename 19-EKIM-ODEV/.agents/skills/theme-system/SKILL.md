---
name: theme-system
description: iJournal uygulamasında 5 farklı görsel tema (NeoBrutalist, Minimalist, Journal, Hand-Drawn, Rubber Hose) ve Gece/Gündüz modunu harici paket kullanmadan ValueNotifier ve ThemeExtension ile kurar ve yönetir.
---

# iJournal Tema Sistemi ve ThemeExtension İskeleti

Bu yetenek, iJournal uygulamasında 5 farklı tasarım dilini (NeoBrutalist, Minimalist, Journal, Hand-Drawn, Rubber Hose) ve her birinin Gece/Gündüz modunu Material 3 standartlarında, sıfır harici paketle (`ValueNotifier` ve `ThemeExtension` kullanarak) kurmak ve genişletmek için bağlayıcı rehberdir.

---

## 1. Temel İlkeler ve Kırmızı Çizgiler

1. **Sıfır Ağır State Paketi:** Tema durumu için Bloc, Riverpod veya GetX kullanılmayacaktır. Dart'ın yerel `ValueNotifier<JournalTheme>` ve `ValueNotifier<ThemeMode>` sınıfları kullanılacaktır.
2. **Koda Sabit Renk Yazmak Yasaktır:** UI bileşenlerinde asla `Color(0xFF...)` şeklinde elle renk verilmeyecektir. Tüm renkler `Theme.of(context).colorScheme` veya `context.colors` üzerinden okunacaktır.
3. **Özel Görsel Stiller İçin ThemeExtension:** NeoBrutalist'in sert siyah kenarlıkları ve gölgeleri, Hand-Drawn'ın çizgi dokuları ve Rubber Hose'un karikatür konturları `ThemeExtension<JournalThemeStyle>` üzerinden yönetilecektir.
4. **Const Zorunluluğu:** Mümkün olan tüm stil tanımlamalarında ve widget yapıcılarında `const` kullanımı zorunludur.

---

## 2. Klasör ve Dosya Hiyerarşisi

```text
lib/
├── core/
│   ├── theme/
│   │   ├── models/
│   │   │   └── app_theme_type.dart
│   │   ├── extensions/
│   │   │   └── journal_theme_extension.dart
│   │   ├── palettes/
│   │   │   ├── neo_brutalist_colors.dart
│   │   │   ├── minimalist_colors.dart
│   │   │   ├── journal_classic_colors.dart
│   │   │   ├── hand_drawn_colors.dart
│   │   │   └── rubber_hose_colors.dart
│   │   ├── app_themes.dart
│   │   └── controllers/
│   │       └── theme_controller.dart
│   └── extensions/
│       └── context_extensions.dart
└── main.dart
```

---

## 3. Adım Adım Kod İskeleti

### Adım 1: Tema Türü Modeli (`lib/core/theme/models/app_theme_type.dart`)

```dart
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
```

---

### Adım 2: ThemeExtension Tanımı (`lib/core/theme/extensions/journal_theme_extension.dart`)

Material 3 `ThemeData` içinde varsayılan olarak bulunmayan özel kenarlık, gölge ve köşe yuvarlaklığı tanımları:

```dart
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
```

---

### Adım 3: Renk Paletleri (`lib/core/theme/palettes/`)

Her tasarım dili için Material 3 `ColorScheme` nesneleri ayrı dosyalarda tutulur:

#### `neo_brutalist_colors.dart`

```dart
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
```

#### `minimalist_colors.dart`

```dart
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
```

#### `journal_classic_colors.dart`

```dart
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
```

#### `hand_drawn_colors.dart`

```dart
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
```

#### `rubber_hose_colors.dart`

```dart
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
```

---

### Adım 4: Tema Üretici Fabrika (`lib/core/theme/app_themes.dart`)

```dart
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
```

---

### Adım 5: Reaktif Tema Denetleyicisi (`lib/core/theme/controllers/theme_controller.dart`)

```dart
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
```

---

### Adım 6: Context Uzantıları (`lib/core/extensions/context_extensions.dart`)

```dart
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
```

---

### Adım 7: `main.dart` Entegrasyonu

```dart
import 'package:flutter/material.dart';
import 'core/theme/controllers/theme_controller.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/models/app_theme_type.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IJournalApp());
}

class IJournalApp extends StatelessWidget {
  const IJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeController.instance;

    return ValueListenableBuilder<JournalTheme>(
      valueListenable: controller.currentTheme,
      builder: (context, activeTheme, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: controller.currentMode,
          builder: (context, activeMode, _) {
            return MaterialApp(
              title: 'iJournal',
              debugShowCheckedModeBanner: false,
              themeMode: activeMode,
              theme: AppThemes.getTheme(activeTheme, Brightness.light),
              darkTheme: AppThemes.getTheme(activeTheme, Brightness.dark),
              home: const Scaffold(
                body: Center(child: Text('iJournal Hazır!')),
              ),
            );
          },
        );
      },
    );
  }
}
```

---

## 4. Kullanım Örneği: Temaya Duyarlı Kart Widget'ı

Ajanın veya geliştiricinin UI yazarken temaya nasıl uyum sağlayacağını gösteren referans bileşen:

```dart
import 'package:flutter/material.dart';
import 'package:ijournal/core/extensions/context_extensions.dart';

class ThemedJournalCard extends StatelessWidget {
  final String title;
  final String previewText;
  final VoidCallback? onTap;

  const ThemedJournalCard({
    super.key,
    required this.title,
    required this.previewText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(style.borderRadius),
          border: Border.all(
            color: style.borderColor,
            width: style.borderWidth,
          ),
          boxShadow: style.cardShadow,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: style.headerFont.copyWith(
                color: context.colors.onSurface,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              previewText,
              style: TextStyle(
                color: context.colors.onSurface.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 5. Doğrulama ve Test Komutları

Yetenek uygulandıktan veya yeni bir tema eklendikten sonra şu kontroller zorunludur:

```bash
# 1. 0 hata ve 0 uyarı doğrulaması
flutter analyze

# 2. Testlerin çalıştırılması
flutter test
```

---

## 6. Yardımcı Kaynaklar ve Araçlar

Bu yetenek paketinde şu destekleyici dosyalar yer alır:

- **Çekirdek Tema Kurulum Betiği (`script/setup_theme_core.sh`):** 5 temanın renk paletlerini, ThemeExtension ve ThemeController yapısını `lib/core/theme/` altına kurar.
- **Güvenli Yönlendirici Betik (`script/generate_feature.sh`):** Modül üretimi istendiğinde işlemi yetkili `feature-scaffold` yeteneğine devrederek betik çakışmalarını önler.
- **Tema Dağıtım ve Akış Rehberi (`references/state_flow.md`):** 5 temanın renk tablosunu ve ThemeExtension reaktif yaşam döngüsünü içeren mimari şema.
- **Tema Önizleme Ekranı (`examples/sample_screen.dart`):** 5 temayı ve Gece/Gündüz modunu canlı önizleyen `ThemeShowcaseView` referans ekranı.

