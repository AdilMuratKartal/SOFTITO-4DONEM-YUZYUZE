# Randevu Sistemi - Tema ve Tasarım Sistemi Şartnamesi (`theme_spec.md`)

Bu doküman, **Çok Sektörlü Teklif Usulü Randevu Platformu** için [21-EKIM/THEME.md](file:///Users/d1-16/Desktop/SOFTITO-YU%CC%88ZYU%CC%88ZE-4.DO%CC%88NEM/21-EKIM/THEME.md) temel alınarak hazırlanmış bağlayıcı tasarım, renk, tipografi ve ortak bileşen kılavuzudur.

---

## 1. Renk Paleti ve Token Standartları

Uygulama genelinde renkler doğrudan hex (`Color(0xFF...)`) olarak bileşen içine gömülemez. `AppColors` sınıfı veya `Theme.of(context)` üzerinden okunmalıdır.

### 1.1. Ana ve Yüzey Renkleri

| Token | Hex Değeri | Flutter Kodu | Açıklama ve Kullanım Alanı |
| :--- | :--- | :--- | :--- |
| `primary` | `#2563EB` | `Color(0xFF2563EB)` | Ana aksiyon butonları, aktif filtre çipleri, seçili saatler |
| `secondary` | `#EA580C` | `Color(0xFFEA580C)` | Fiyat etiketleri, "Karşı Teklif Ver" butonları, pazarlık rozetleri |
| `background`| `#F8FAFC` | `Color(0xFFF8FAFC)` | Tüm ekranların ana `Scaffold` arka planı |
| `surface`   | `#FFFFFF` | `Color(0xFFFFFFFF)` | İlan kartları, randevu kartları, diyalog pencereleri |
| `textPrimary`| `#0F172A` | `Color(0xFF0F172A)` | Başlıklar, dükkan adları, birincil metinler |
| `textSecondary`| `#64748B` | `Color(0xFF64748B)` | Açıklama metinleri, pasif ikonlar, tarih alt başlıkları |
| `border`    | `#E2E8F0` | `Color(0xFFE2E8F0)` | Kart çerçeveleri, input kenarlıkları, liste ayırıcıları |

### 1.2. Randevu Durum Renkleri (Status Colors)

| Durum (`status`) | Metin / İkon Rengi | Arka Plan Rengi | Etiket Metni |
| :--- | :--- | :--- | :--- |
| **`onaylandi`** | `#16A34A` (`0xFF16A34A`) | `#DCFCE7` (`0xFFDCFCE7`) | "Onaylandı" |
| **`beklemede`** | `#D97706` (`0xFFD97706`) | `#FEF3C7` (`0xFFFEF3C7`) | "Beklemede" |
| **`iptal`**     | `#DC2626` (`0xFFDC2626`) | `#FEE2E2` (`0xFFFEE2E2`) | "İptal Edildi" |
| **`bitti`**     | `#475569` (`0xFF475569`) | `#F1F5F9` (`0xFFF1F5F9`) | "Tamamlandı" |

### 1.3. Ulaşım ve Konum Renkleri (`locationType`)

| Konum Tipi | Metin / İkon Rengi | Arka Plan Rengi | İkon | Etiket Metni |
| :--- | :--- | :--- | :--- | :--- |
| **`sen_gel`** | `#7C3AED` (`0xFF7C3AED`) | `#EDE9FE` (`0xFFEDE9FE`) | `Icons.home_repair_service_outlined` | "Sen Gel (Adrese)" |
| **`ben_geleyim`** | `#0284C7` (`0xFF0284C7`) | `#E0F2FE` (`0xFFE0F2FE`) | `Icons.storefront_outlined` | "Ben Geleyim (Dükkana)" |
| **`her_ikisi`** | `#0D9488` (`0xFF0D9488`) | `#CCFBF1` (`0xFFCCFBF1`) | `Icons.swap_horiz_outlined` | "Adreste veya Dükkanda" |

---

## 2. Tipografi ve Boyutlandırma Standartları

- **Font:** Sistem varsayılanı veya `Inter` / `Plus Jakarta Sans`.
- **Sayfa Başlıkları (AppBar):** `18px`, `FontWeight.w700`, Renk: `AppColors.textPrimary`
- **Kart Başlıkları:** `16px`, `FontWeight.w600`, Renk: `AppColors.textPrimary`
- **Fiyat Göstergeleri:** `16px`, `FontWeight.w800`, Renk: `AppColors.secondary`
- **Gövde Metinleri (Açıklama/Adres):** `14px`, `FontWeight.w400`, Renk: `AppColors.textPrimary` veya `textSecondary`
- **Tarih & Saat Alt Başlıkları:** `12px`, `FontWeight.w500`, Renk: `AppColors.textSecondary`
- **Rozet ve Çip Metinleri:** `11px - 12px`, `FontWeight.w600`

---

## 3. Spacing, Kenarlık ve Şekil Kuralları

- **Ekran Kenar Boşluğu (Screen Padding):** `EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)`
- **Kart İçi Dolgu (Card Padding):** `EdgeInsets.all(14.0)`
- **Kart Köşe Yuvarlatma:** `BorderRadius.circular(12.0)`
- **Buton Köşe Yuvarlatma:** `BorderRadius.circular(10.0)`
- **Giriş Alanı (Input) Kenarlık:** `BorderRadius.circular(10.0)`, Border: `Border.all(color: AppColors.border, width: 1.0)`
- **Rozet Köşe Yuvarlatma:** `BorderRadius.circular(20.0)` (Durum) veya `BorderRadius.circular(6.0)` (Konum)

---

## 4. Ortak Atomik Widget Standartları

Aşağıdaki 4 ortak widget projenin tüm ekranlarında tutarlı biçimde kullanılmalıdır:

### 4.1. `StatusBadge` (`lib/views/shared/widgets/status_badge.dart`)
Randevunun mevcut durumunu renk kodlu hap (pill) şeklinde gösterir.

### 4.2. `LocationBadge` (`lib/views/shared/widgets/location_badge.dart`)
Hizmetin müşterinin adresinde mi yoksa uzmanın dükkanında mı gerçekleşeceğini gösterir.

### 4.3. `TimeSlotChip` (`lib/views/shared/widgets/time_slot_chip.dart`)
Teklif ekranlarında ve müsaitlik takviminde saat seçimini sağlar:
- `isBooked: true` -> Arka plan gri, metin üstü çizgili, tıklanamaz.
- `isSelected: true` -> Arka plan `AppColors.primary`, metin beyaz.
- Normal boş slot -> Arka plan beyaz, kenarlık gri, tıklanabilir.

### 4.4. `ChatBubble` (`lib/views/shared/widgets/chat_bubble.dart`)
WhatsApp benzeri mesajlaşma baloncukları:
- `isMe: true` -> Sağa yaslı, arka plan `AppColors.primary`, metin beyaz.
- `isMe: false` -> Sola yaslı, arka plan beyaz, kenarlıklı, metin koyu gri.
