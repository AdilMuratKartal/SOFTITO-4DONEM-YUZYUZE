# TakeGO - Tema, Tasarım Sistemi ve Sabit Görsel Şartnamesi (`theme_spec.md`)

Bu doküman, TakeGO projesinin **Cyber Drive Otomotiv Tasarım Dili**'ni, Material 3 renk eşlemelerini, gece/gündüz sürüş modlarını ve taşmaları önleyen sabit görsel boyutlarını tanımlar.

---

## 1. Tasarım Felsefesi ve Renk Paleti (Cyber Drive)

TakeGO, araç paylaşımı ve dijital kokpit hissiyatını yansıtmak amacıyla yüksek kontrastlı, modern ve dinamik bir otomotiv paleti kullanır. Projede serbest/rastgele tema seçimi yoktur; yalnızca **Clean Mobility Light** (Gündüz Sürüşü) ve **OLED Cockpit Dark** (Gece Sürüşü) modları bulunur.

### A. Gündüz Modu: Clean Mobility Light
*Temiz asfalt grisi, saf beyaz yüzeyler ve elektrik mavisi vurgular.*

| Token Adı | Hex Değeri | ColorScheme Eşleşmesi | Kullanım Yeri |
|---|---|---|---|
| `bg` | `#F6F8FA` | `colorScheme.surface` | Scaffold arka planı (Kırık beyaz asfalt grisi) |
| `surface` | `#FFFFFF` | `colorScheme.surfaceContainer` | İlan kartları, modallar, açılır pencereler |
| `primary` | `#0066FF` | `colorScheme.primary` | Ana butonlar, seçili filtreler, elektrik mavisi vurgu |
| `secondary` | `#00D084` | `colorScheme.secondary` | Benzin/şarj durumu rozetleri, onay durumları |
| `textPrimary` | `#111827` | `colorScheme.onSurface` | Araç marka/model başlıkları, fiyat rakamı |
| `textSecondary`| `#6B7280` | `colorScheme.onSurfaceVariant` | Plaka, mesafe, lokasyon, birim etiketleri |
| `border` | `#E5E7EB` | `colorScheme.outlineVariant` | Kart çerçeveleri, ayırıcı çizgiler (`Divider`) |
| `placeholder` | `#E2E8F0` | `colorScheme.surfaceContainerHighest` | Resim yüklenirken veya resimsiz kartlarda silüet |
| `warning` | `#F59E0B` | `colorScheme.tertiary` / Amber | Kilit uyarıları, dikkat rozetleri |
| `error` | `#EF4444` | `colorScheme.error` | Düşük benzin uyarısı, iptal/hata |

### B. Gece Modu: OLED Cockpit Dark
*Karanlık gece sürüşünde gözü yormayan derin kabin siyahı ve neon mavi detaylar.*

| Token Adı | Hex Değeri | ColorScheme Eşleşmesi | Kullanım Yeri |
|---|---|---|---|
| `bgDark` | `#0B0E14` | `colorScheme.surface` | OLED derin kokpit siyahı arka plan |
| `surfaceDark` | `#161B26` | `colorScheme.surfaceContainer` | Koyu antrasit kart yüzeyleri |
| `primaryDark` | `#2F80ED` | `colorScheme.primary` | Karanlıkta parlayan neon elektrik mavisi |
| `secondaryDark`| `#10B981` | `colorScheme.secondary` | Fosforlu aktif kilit ve batarya göstergesi |
| `textPrimaryDark`| `#F9FAFB` | `colorScheme.onSurface` | Yüksek kontrastlı yumuşak beyaz başlıklar |
| `textSecondaryDark`| `#9CA3AF` | `colorScheme.onSurfaceVariant`| Metalik gümüş gri açıklama metinleri |
| `borderDark` | `#242C3D` | `colorScheme.outlineVariant` | Loş kokpit kart kenarlıkları |
| `placeholderDark`| `#1F2937` | `colorScheme.surfaceContainerHighest`| Koyu antrasit görsel dolgusu |
| `warningDark` | `#FBBF24` | `colorScheme.tertiary` | Parlak kehribar asistan bildirimleri |
| `errorDark` | `#F87171` | `colorScheme.error` | Kritik alarm / tehlike |

---

## 2. Sabit Resim ve Kart Boyut Standartları

Gerçek araç fotoğrafları sunucudan asenkron gelirken veya fotoğraf yüklenemediğinde arayüzde `RenderFlex overflow` oluşmasını kesinlikle engellemek için tüm görsel alanları piksel veya oran bazında kilitlenmiştir:

```text
+--------------------------------------------------------------+
| 1. İLAN KARTI GÖRSELİ (car_card_widget.dart)                 |
| - AspectRatio: 16 / 9 (veya height: 180.0, width: double.inf)|
| - BorderRadius: BorderRadius.circular(16)                    |
| - Fallback: surfaceContainerHighest + Ortalanmış Araç İkonu  |
+--------------------------------------------------------------+

+--------------------------------------------------------------+
| 2. İLAN DETAY BANNER'I (car_image_banner.dart)               |
| - height: 260.0, width: double.infinity                      |
| - BoxFit: BoxFit.cover                                       |
| - Gradient Overlay: Alt tarafta okunabilirliği artıran gölge|
+--------------------------------------------------------------+

+--------------------------------------------------------------+
| 3. İLAN VERME FOTOĞRAF YÜKLEYİCİ (image_upload_placeholder)  |
| - height: 140.0, width: double.infinity                      |
| - Border: Kesikli (Dashed) veya 1.5px outlineVariant         |
| - İçerik: Kamera ikonu + "Araç Görseli Yükle (16:9)"        |
+--------------------------------------------------------------+
```

---

## 3. Tipografi ve Stil Standartları

- **Başlık (Display / Title):** `FontWeight.w800` veya `w700`, araç modeli ve büyük fiyatlar için.
- **Etiket (Label / Badge):** `FontWeight.w600`, `fontSize: 12-13`, benzin rozetleri ve vites bilgileri için.
- **Birim Fiyat Formatı:** `1.850 ₺ / Gün` veya `12.500 ₺ / Hafta` şeklinde belirgin renkte (`primary`).
- **Const Kullanımı:** Tüm statik `EdgeInsets`, `SizedBox`, `TextStyle` ve `Icon` nesnelerinde `const` zorunludur.

---

## 4. `app_theme.dart` Uygulama Referansı

```dart
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Clean Mobility Light
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF0066FF),
      secondary: Color(0xFF00D084),
      surface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFFE2E8F0),
      onSurface: Color(0xFF111827),
      onSurfaceVariant: Color(0xFF6B7280),
      outlineVariant: Color(0xFFE5E7EB),
      error: Color(0xFFEF4444),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF6F8FA),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    );
  }

  // OLED Cockpit Dark
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF2F80ED),
      secondary: Color(0xFF10B981),
      surface: Color(0xFF161B26),
      surfaceContainerHighest: Color(0xFF1F2937),
      onSurface: Color(0xFFF9FAFB),
      onSurfaceVariant: Color(0xFF9CA3AF),
      outlineVariant: Color(0xFF242C3D),
      error: Color(0xFFF87171),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0B0E14),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
```
