# Tasarım Sistemi ve Tema Kuralları (THEME.md)

Bu doküman, **Çok Sektörlü Teklif Usulü Randevu Platformu** projesinin renk paletini, tipografisini, boşluk (spacing) standartlarını ve ortak kullanılacak temel Flutter widget şablonlarını içerir.

---

## 1. Renk Paleti (Color Palette)

Uygulama hem kurumsal danışmanları hem de saha ustalarını (tesisatçı, elektrikçi, kuaför) kapsadığı için güven veren **Modern İndigo/Mavi** ana tonu ile fiyat tekliflerini öne çıkaran **Turuncu/Amber** vurgu tonlarını kullanır.

### 1.1. Ana ve Yüzey Renkleri
| Rol | Hex Kodu | Flutter Karşılığı | Kullanım Alanı |
| :--- | :--- | :--- | :--- |
| **Primary (Ana Renk)** | `#2563EB` | `Color(0xFF2563EB)` | Ana butonlar, aktif filtre çipleri, seçili saat dilimi |
| **Secondary (Teklif/Vurgu)** | `#EA580C` | `Color(0xFFEA580C)` | Fiyat etiketleri, "Karşı Teklif Ver" butonları |
| **Background (Arka Plan)** | `#F8FAFC` | `Color(0xFFF8FAFC)` | Tüm ekranların ana `Scaffold` arka planı |
| **Surface (Kart Yüzeyi)** | `#FFFFFF` | `Color(0xFFFFFFFF)` | İlan kartları, randevu kartları, diyalog kutuları |
| **Text Primary** | `#0F172A` | `Color(0xFF0F172A)` | Başlıklar, dükkan adları, ana metinler |
| **Text Secondary** | `#64748B` | `Color(0xFF64748B)` | Açıklamalar, tarih/saat alt metinleri, pasif ikonlar |
| **Border / Divider** | `#E2E8F0` | `Color(0xFFE2E8F0)` | Kart çerçeveleri, input kenarlıkları, ayırıcı çizgiler |

### 1.2. Randevu Durum Renkleri (Status Colors)
| Durum (`status`) | Metin / İkon Rengi | Arka Plan Rengi | Açıklama |
| :--- | :--- | :--- | :--- |
| **`onaylandi`** | `#16A34A` (Yeşil) | `#DCFCE7` (Açık Yeşil) | Tarafların anlaştığı kesinleşmiş randevu |
| **`beklemede`** | `#D97706` (Amber) | `#FEF3C7` (Açık Sarı) | Yanıt veya karşı teklif bekleyen talep |
| **`iptal`** | `#DC2626` (Kırmızı) | `#FEE2E2` (Açık Kırmızı) | Reddedilen veya iptal edilen randevu |
| **`bitti`** | `#475569` (Gri/Mavi) | `#F1F5F9` (Açık Gri) | Tamamlanmış geçmiş hizmet |

### 1.3. Konum Tercihi Renkleri (`locationType`)
| Konum Tipi | Metin / İkon Rengi | Arka Plan Rengi | Etiket Metni |
| :--- | :--- | :--- | :--- |
| **`sen_gel`** | `#7C3AED` (Mor) | `#EDE9FE` | "Sen Gel (Adrese Hizmet)" |
| **`ben_geleyim`** | `#0284C7` (Açık Mavi)| `#E0F2FE` | "Ben Geleyim (Dükkanda)" |

---

## 2. Tipografi ve Boyutlandırma Standartları

### 2.1. Font Ailesi ve Boyutlar
- **Önerilen Font:** `Inter` veya `Plus Jakarta Sans` (`google_fonts` paketi ile veya sistem varsayılanı `Roboto`).
- **Ekran Başlıkları (AppBar):** `18px`, `FontWeight.w600`
- **Kart Başlıkları (Dükkan/Özet):** `16px`, `FontWeight.w700`
- **Fiyat Gösterimi:** `16px`, `FontWeight.w800` (Secondary veya Primary renk)
- **Gövde Metni (Açıklama/Adres):** `14px`, `FontWeight.w400`
- **Etiketler ve Saat Dilimleri:** `12px`, `FontWeight.w600`

### 2.2. Boşluk (Spacing) ve Köşe Yuvarlatma (Border Radius)
- **Ekran Kenar Boşluğu (Screen Padding):** Yatay `16.0`, Dikey `12.0`
- **Kart İçi Boşluk (Card Padding):** `14.0`
- **Kart Köşe Yuvarlatma:** `BorderRadius.circular(12.0)`
- **Buton ve Input Yuvarlatma:** `BorderRadius.circular(10.0)`
- **Durum/Filtre Çipleri (Badges):** `BorderRadius.circular(20.0)`

---

## 3. Tema Yapılandırma Kodu (`lib/core/theme/app_theme.dart`)

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFFEA580C);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  // Durum Renkleri
  static const Color approvedText = Color(0xFF16A34A);
  static const Color approvedBg = Color(0xFFDCFCE7);
  static const Color pendingText = Color(0xFFD97706);
  static const Color pendingBg = Color(0xFFFEF3C7);
  static const Color cancelledText = Color(0xFFDC2626);
  static const Color cancelledBg = Color(0xFFFEE2E2);
  static const Color completedText = Color(0xFF475569);
  static const Color completedBg = Color(0xFFF1F5F9);

  // Konum Renkleri (Gel / Git)
  static const Color comeToMeText = Color(0xFF7C3AED);
  static const Color comeToMeBg = Color(0xFFEDE9FE);
  static const Color iWillComeText = Color(0xFF0284C7);
  static const Color iWillComeBg = Color(0xFFE0F2FE);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
```

---

## 4. Temel Ortak Widget Örnekleri (`lib/views/shared/widgets/`)

### 4.1. Randevu Durum Etiketi (`StatusBadge`)
Randevularım ekranında (`beklemede`, `onaylandi`, `iptal`, `bitti`) durumlarını göstermek için kullanılır.

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    String label;

    switch (status) {
      case 'onaylandi':
        textColor = AppColors.approvedText;
        bgColor = AppColors.approvedBg;
        label = 'Onaylandı';
        break;
      case 'iptal':
        textColor = AppColors.cancelledText;
        bgColor = AppColors.cancelledBg;
        label = 'İptal Edildi';
        break;
      case 'bitti':
        textColor = AppColors.completedText;
        bgColor = AppColors.completedBg;
        label = 'Tamamlandı';
        break;
      case 'beklemede':
      default:
        textColor = AppColors.pendingText;
        bgColor = AppColors.pendingBg;
        label = 'Beklemede';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

### 4.2. "Ben Geleyim / Sen Gel" Konum Rozeti (`LocationBadge`)
İlan ve randevu kartlarında hizmetin nerede gerçekleşeceğini gösterir.

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LocationBadge extends StatelessWidget {
  final String locationType; // 'sen_gel', 'ben_geleyim', 'her_ikisi'

  const LocationBadge({super.key, required this.locationType});

  @override
  Widget build(BuildContext context) {
    final bool isComeToMe = locationType == 'sen_gel';
    final Color textColor = isComeToMe ? AppColors.comeToMeText : AppColors.iWillComeText;
    final Color bgColor = isComeToMe ? AppColors.comeToMeBg : AppColors.iWillComeBg;
    final IconData icon = isComeToMe ? Icons.home_repair_service_outlined : Icons.storefront_outlined;
    final String text = locationType == 'her_ikisi'
        ? 'Adreste veya Dükkanda'
        : (isComeToMe ? 'Sen Gel (Adrese)' : 'Ben Geleyim (Dükkana)');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.3. Dolu / Boş Saat Dilimi Seçici (`TimeSlotChip`)
İlan detayında ve teklif ekranında dolu saatleri gri/tıklanamaz, boş saatleri seçilebilir olarak gösterir.

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isBooked;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeSlotChip({
    super.key,
    required this.time,
    required this.isBooked,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey.shade200
              : (isSelected ? AppColors.primary : AppColors.surface),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isBooked
                ? Colors.grey.shade300
                : (isSelected ? AppColors.primary : AppColors.border),
          ),
        ),
        child: Text(
          isBooked ? '$time (Dolu)' : time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            decoration: isBooked ? TextDecoration.lineThrough : null,
            color: isBooked
                ? Colors.grey.shade500
                : (isSelected ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
```

### 4.4. WhatsApp Tarzı Mesaj Baloncuğu (`ChatBubble`)
Randevu detayından ulaşılan diyalog ekranında mesajları sağda (gönderen) veya solda (alıcı) gösterir.

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timestamp,
              style: TextStyle(
                color: isMe ? Colors.white70 : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```