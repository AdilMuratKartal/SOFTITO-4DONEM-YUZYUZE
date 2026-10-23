# Tasarım Sistemi, Renk Paleti ve Tema Kuralları (THEME.md)

Bu doküman; mikro-alışkanlık, duygu durumu (mood), Pomodoro odaklanma ve oyunlaştırma (gamification) mekanizmalarını barındıran uygulamanın renk standartlarını, tipografisini, durum/kategori renklerini ve Flutter `ThemeData` yapılandırmasını içerir.

---

## 1. Renk Paleti (Color Palette)

Arayüz; kişisel gelişim ve odaklanmayı destekleyen **Sakinleştirici Zümrüt Yeşili (Emerald)** ana tonu, Pomodoro ve serileri tetikleyen **Alev Turuncusu (Streak/Pomodoro)** ile tamamlanmıştır.

### 1.1. Temel Arayüz Renkleri (Light & Dark)
| Rol | Light Mod Hex | Dark Mod Hex | Flutter Değeri (Light / Dark) | Kullanım Alanı |
| :--- | :--- | :--- | :--- | :--- |
| **Primary (Ana Renk)** | `#10B981` | `#34D399` | `Color(0xFF10B981)` / `Color(0xFF34D399)` | Tamamlanan alışkanlıklar, butonlar, aktif sekmeler |
| **Secondary (Vurgu/Ateş)** | `#F97316` | `#FB923C` | `Color(0xFFF97316)` / `Color(0xFFFB923C)` | Streak (Alev) ikonları, XP göstergesi, Pomodoro sayacı |
| **Accent / Info (Mavi)** | `#0EA5E9` | `#38BDF8` | `Color(0xFF0EA5E9)` / `Color(0xFF38BDF8)` | Su takip kartları, soğuk duş, bilgi banner'ları |
| **Background (Arka Plan)** | `#F8FAFC` | `#0F172A` | `Color(0xFFF8FAFC)` / `Color(0xFF0F172A)` | Ana Scaffold arka planı |
| **Surface (Kart/Modal)** | `#FFFFFF` | `#1E293B` | `Color(0xFFFFFFFF)` / `Color(0xFF1E293B)` | Alışkanlık kartları, popup'lar, diyaloglar |
| **Surface Variant** | `#F1F5F9` | `#334155` | `Color(0xFFF1F5F9)` / `Color(0xFF334155)` | İlerleme çubuğu zeminleri, inaktif çipler |
| **Text Primary** | `#0F172A` | `#F8FAFC` | `Color(0xFF0F172A)` / `Color(0xFFF8FAFC)` | Başlıklar, sayaç değerleri, alışkanlık isimleri |
| **Text Secondary** | `#64748B` | `#94A3B8` | `Color(0xFF64748B)` / `Color(0xFF94A3B8)` | Hedef detayları, tarih/hafta metinleri, alt yazılar |
| **Border / Divider** | `#E2E8F0` | `#334155` | `Color(0xFFE2E8F0)` / `Color(0xFF334155)` | Kart sınırları, liste ayırıcıları |

---

## 2. Özel Durum ve Fonksiyon Renkleri

### 2.1. Mood Tracker (Duygu Durumu) Renkleri
Kullanıcı uygulamanın ilk açılışındaki 5 dereceli duygu seçimini yaptığında kartlar ve mini emojiler bu renk skalasını baz alır:
- **Harika (Great - 🤩):** `#10B981` (Zümrüt Yeşili) — Arka Plan: `#D1FAE5`
- **İyi (Good - 🙂):** `#06B6D4` (Camgöbeği) — Arka Plan: `#CFFAFE`
- **Normal (Neutral - 😐):** `#F59E0B` (Amber / Sarı) — Arka Plan: `#FEF3C7`
- **Kötü (Bad - 😕):** `#F97316` (Turuncu) — Arka Plan: `#FFEDD5`
- **Berbat (Terrible - 😫):** `#EF4444` (Mercan Kırmızısı) — Arka Plan: `#FEE2E2`

### 2.2. Alışkanlık Kategori Renkleri (4 Temel Kategori + Özel Kategoriler)
Kart ikonlarının arka planında, etiket çiplerinde ve analiz grafiklerinde kullanılır. Başlangıçta 4 temel kategori tanımlıdır; kullanıcı yeni kategori eklerken hazır renk paletinden seçim yapar:

- **1. Spor (Fitness, Egzersiz, Koşu):** `#10B981` (Zümrüt Yeşili) — Yumuşak Zemin: `#D1FAE5`
- **2. Sağlık (Su, Beslenme, Soğuk Duş, Uyku):** `#0EA5E9` (Gök Mavisi) — Yumuşak Zemin: `#E0F2FE`
- **3. Zihin (Kitap Okuma, Meditasyon, Nefes):** `#8B5CF6` (Menekşe Moru) — Yumuşak Zemin: `#EDE9FE`
- **4. Müzik (Enstrüman, Solfej, Pratik):** `#EC4899` (Canlı Pembe) — Yumuşak Zemin: `#FCE7F3`

**Özel Kategori Renk Havuzu (Kullanıcı Tarafından Seçilebilir):**
Kullanıcı yeni bir kategori eklediğinde aşağıdaki uyumlu pastel/vurgulu tonlardan birini seçebilir:
- *Amber / Disiplin:* `#F59E0B` — Zemin: `#FEF3C7`
- *İndigo / Çalışma:* `#6366F1` — Zemin: `#EEF2FF`
- *Turkuaz / Doğa:* `#14B8A6` — Zemin: `#CCFBF1`
- *Mercan / Detoks:* `#F43F5E` — Zemin: `#FFE4E6`
- *Sıcak Turuncu:* `#F97316` — Zemin: `#FFEDD5`

### 2.3. Pomodoro Durum Renkleri
- **Odaklanma (Focus - 25 dk):** `#EF4444` (Kırmızı/Turuncu enerji modu)
- **Kısa Mola (Short Break - 5 dk):** `#10B981` (Dinlendirici yeşil)
- **Uzun Mola (Long Break - 15 dk):** `#0EA5E9` (Ferahlatıcı mavi)

### 2.4. Form, Seçim ve Silme İşlem Renkleri
- **Haftalık Gün Seçici (Aktif Gün):** `#10B981` (Dolu yeşil zemin, beyaz yazı)
- **Haftalık Gün Seçici (Pasif Gün):** `#F1F5F9` (Dark: `#334155`, gri kenarlık)
- **Zaman Aralığı Seçici (09:45 - 15:36):** `#0EA5E9` (Mavi zaman ikon ve metin vurgusu)
- **Hatırlatıcı Switch (Açık):** `#10B981`
- **Silme Aksiyonu (Delete / Swipe):** `#EF4444` (Mercan kırmızısı arka plan ve ikon)

---

## 3. Tipografi ve Boyut Standartları

Uygulamada standart olarak okunabilirliği yüksek olan **Inter** veya **Plus Jakarta Sans** (`google_fonts`) tercih edilir:

- **Büyük Sayaçlar / XP Göstergesi:** `32px`, `FontWeight.w800` (Bold)
- **Sayfa Başlıkları (AppBar / Section):** `20px`, `FontWeight.w700`
- **Kart Başlıkları (Alışkanlık Adı):** `16px`, `FontWeight.w600`
- **Gövde Metinleri (Açıklamalar):** `14px`, `FontWeight.w400`
- **Mikro Etiketler (Streak, Rozet Adı, Chip):** `12px`, `FontWeight.w600`
- **Tarih & Alt Bilgiler:** `11px`, `FontWeight.w500`

---

## 4. Spacing (Boşluk) ve Border Radius Standartları

- **Ekran Kenar Boşluğu (Screen Padding):** Yatay `16.0`, Dikey `12.0`
- **Kart İçi Dolgu (Padding):** `14.0` - `16.0`
- **Alışkanlık & Menü Kartları:** `BorderRadius.circular(16.0)`
- **Aksiyon Butonları & Inputlar:** `BorderRadius.circular(12.0)`
- **Mood ve Kategori Çipleri (Pill):** `BorderRadius.circular(24.0)`
- **Dairesel İlerleme ve Rozet Zeminleri:** `BoxShape.circle`

---

## 5. Flutter Tema Kodu (`lib/core/theme/app_theme.dart`)

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Temel Renkler
  static const Color primary = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF34D399);
  static const Color secondary = Color(0xFFF97316);
  static const Color info = Color(0xFF0EA5E9);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF0F172A);
  static const Color textDark = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  // Mood Tracker Renkleri
  static const Color moodGreat = Color(0xFF10B981);
  static const Color moodGood = Color(0xFF06B6D4);
  static const Color moodNeutral = Color(0xFFF59E0B);
  static const Color moodBad = Color(0xFFF97316);
  static const Color moodTerrible = Color(0xFFEF4444);

  // Pomodoro
  static const Color pomodoroWork = Color(0xFFEF4444);
  static const Color pomodoroShortBreak = Color(0xFF10B981);
  static const Color pomodoroLongBreak = Color(0xFF0EA5E9);

  // 4 Temel Kategori Renkleri
  static const Color categorySport = Color(0xFF10B981);
  static const Color categoryHealth = Color(0xFF0EA5E9);
  static const Color categoryMind = Color(0xFF8B5CF6);
  static const Color categoryMusic = Color(0xFFEC4899);

  // Aksiyon ve Silme
  static const Color danger = Color(0xFFEF4444);
}

class AppTheme {
  // Işık Modu Teması
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: Color(0xFFDC2626),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Karanlık Mod Teması
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: Color(0xFFEF4444),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.bgDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}