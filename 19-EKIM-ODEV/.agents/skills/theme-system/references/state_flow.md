# iJournal Tema Sistemi ve Reaktif Akış Rehberi (Theme State Flow)

Bu doküman, **iJournal** uygulamasındaki 5 farklı görsel temanın ve Gece/Gündüz modlarının mimarisini, veri akışını ve `ThemeExtension` kurallarını tanımlar.

---

## 1. Tema Mimarisi Genel Bakış

iJournal, kullanıcıya sıradan uygulamalardan farklı olarak 5 benzersiz tasarım karakteri sunar. Her tema hem Açık (Light) hem de Koyu (Dark) renk paletine sahiptir:

1. **NeoBrutalist:** Sert 2.5-3px saf siyah kenarlıklar, pop renkler (sarı, pembe, camgöbeği), blur içermeyen 4x4 sert gölgeler.
2. **Minimalist:** Sade İskandinav tipografisi, ince 1px kenarlık, gölgesiz temiz yüzeyler, buz mavisi ve grafit tonları.
3. **Journal (Klasik Günlük):** Parşömen kağıdı dokusu, dolma kalem gece mavisi mürekkep, taba deri tonları, yumuşak vintage gölge.
4. **Hand-Drawn (El Çizimi / Kraft):** Samanlı kraft kağıt dokusu, 2B kurşun kalem antrasiti, post-it sarısı, tebeşir tozu ve kara tahta modu.
5. **Rubber Hose (1920-1930s Animasyon):** Steamboat Willie / Fleischer vintage animasyon estetiği, kalın 3px çini mürekkebi kontur, eskitme selüloit dolgusu ve Technicolor kırmızısı.

---

## 2. Reaktif Tema Dağıtım Akış Şeması (Mermaid)

Tema yönetimi tamamen harici paketlerden bağımsızdır. `ThemeController` içinde barındırılan iki adet `ValueNotifier` (`currentTheme` ve `currentMode`) ile çalışır:

```mermaid
flowchart TD
    subgraph UI_Tetikleyiciler["Arayüz Tetikleyicileri"]
        ThemeSelector["Tema Seçici Kartı (JournalTheme.rubberHose vb.)"]
        ModeToggle["Güneş / Ay Butonu (ThemeMode.dark / light)"]
    end

    subgraph Theme_Controller["Tema Denetleyicisi (lib/core/theme/controllers/theme_controller.dart)"]
        ControllerInstance["ThemeController.instance"]
        VN_Theme["ValueNotifier<JournalTheme> currentTheme"]
        VN_Mode["ValueNotifier<ThemeMode> currentMode"]
    end

    subgraph Storage_Layer["Kalıcılık Katmanı"]
        StorageService["StorageService (Seçilen temayı cihazda sakla)"]
    end

    subgraph App_Root["Kök Uygulama (lib/main.dart)"]
        MainApp["IJournalApp (ValueListenableBuilder)"]
        AppThemesFactory["AppThemes.getTheme(theme, brightness)"]
    end

    subgraph Theme_Data_Bundle["ThemeData & Extension Paketi"]
        ColorScheme["ColorScheme (Material 3 Renkleri)"]
        ThemeExtension["JournalThemeStyle (borderWidth, borderColor, cardShadow, headerFont)"]
    end

    subgraph Subtree_Widgets["Tüm Sayfalar ve Kartlar (Features)"]
        ContextAccess["context.colors & context.journalStyle"]
        WidgetsUI["ThemedJournalCard / EntryEditorView / TimelineView"]
    end

    ThemeSelector -->|setTheme(theme)| ControllerInstance
    ModeToggle -->|toggleMode()| ControllerInstance
    ControllerInstance -->|Güncelleme| VN_Theme
    ControllerInstance -->|Güncelleme| VN_Mode
    ControllerInstance -.->|Arka Planda Kaydet| StorageService

    VN_Theme -->|Bildir| MainApp
    VN_Mode -->|Bildir| MainApp

    MainApp -->|Hesapla| AppThemesFactory
    AppThemesFactory -->|Üret| ColorScheme
    AppThemesFactory -->|Üret| ThemeExtension
    ColorScheme --> ContextAccess
    ThemeExtension --> ContextAccess
    ContextAccess --> WidgetsUI
```

---

## 3. 5 Temanın Renk ve Stil Spesifikasyonları

| Tema | Mod | Background | Surface | Primary / Border | Accent | Shadow & Kontur |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **NeoBrutalist** | **Light** | `#FFFDF0` | `#FFE500` / `#A3E635` | `#000000` (2.5px) | `#FF70A6` / `#00F0FF` | Offset(4, 4), blur 0 |
| **NeoBrutalist** | **Dark** | `#121212` | `#1E1E24` | `#FFE500` (2.5px) | `#CCFF00` / `#FF4365` | Offset(4, 4), blur 0 |
| **Minimalist** | **Light** | `#FBFBFB` | `#FFFFFF` | `#1A1A1A` (1.0px `#E5E5EA`) | `#4A6FA5` | Gölge yok |
| **Minimalist** | **Dark** | `#0F0F10` | `#1C1C1E` | `#F2F2F7` (1.0px `#2C2C2E`) | `#64D2FF` | Gölge yok |
| **Journal** | **Light** | `#F5EFEB` | `#FFFDF8` | `#1B263B` (1.0px `#D4A373`) | `#8A3324` | Offset(0, 2), blur 6 |
| **Journal** | **Dark** | `#181512` | `#26211C` | `#E6DFD5` (1.0px `#C69C6D`) | `#D48C46` | Offset(0, 2), blur 6 |
| **Hand-Drawn** | **Light** | `#F4EBD9` | `#FFF9DE` | `#2B2D42` (2.0px) | `#F4A261` / `#81B29A` | Offset(2, 3), blur 0 |
| **Hand-Drawn** | **Dark** | `#1E2229` | `#2C313C` | `#ECEFF1` (2.0px) | `#FDE68A` / `#FCA5A5` | Offset(2, 3), blur 0 |
| **Rubber Hose**| **Light** | `#EFE5D0` | `#FFF8EA` | `#111111` (3.0px) | `#C84B31` / `#DDA15E` | Offset(3, 3), blur 0 |
| **Rubber Hose**| **Dark** | `#12100E` | `#231F1B` | `#EDE0C8` (3.0px) | `#9B2226` / `#B58A63` | Offset(3, 3), blur 0 |

---

## 4. `ThemeExtension` Mekanizması ve Çalışma Prensibi

Material 3'ün standart `ThemeData` nesnesi `borderWidth`, sert gölgeler veya temaya özel fontları doğrudan desteklemez. iJournal bu gereksinimi `ThemeExtension<JournalThemeStyle>` ile çözer:

```dart
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
  JournalThemeStyle copyWith({ ... }) { ... }

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
}
```

### Hızlı Erişim Context Extension'ları
Tüm geliştiriciler ve ajanlar doğrudan context üzerinden temaya ulaşır:

```dart
extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  JournalThemeStyle get journalStyle =>
      Theme.of(this).extension<JournalThemeStyle>() ?? ...;
}
```

---

## 5. Sıfır Paket ve Performans Garantisi

1. **Gereksiz Rebuild'lerin Engellenmesi:**
   Tema değiştiğinde tüm widget ağacının kontrolsüzce yeniden build edilmesini önlemek amacıyla, tema dinleyicileri sadece en üstte (`MaterialApp`) yer alır. Alt ekranlar yalnızca `InheritedWidget` (`Theme.of(context)`) üzerinden değişen renkleri okur.
2. **Hafif Bellek İzi:**
   Bloc, Riverpod veya GetX gibi üçüncü parti state yöneticilerine ihtiyaç yoktur. Dart'ın yerel `ValueNotifier` sınıfı sıfır bağımlılık ile çalışır.
3. **Kırmızı Çizgi:**
   Asla doğrudan `Color(0xFF...)` kullanılamaz. Renkler daima `context.colors`, stil nitelikleri ise `context.journalStyle` üzerinden tüketilir.
