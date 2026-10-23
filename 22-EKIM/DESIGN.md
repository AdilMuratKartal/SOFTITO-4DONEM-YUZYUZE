# Tasarım İlkeleri, Bileşen Mimarisi ve Ekran Standartları (DESIGN.md)

Bu doküman; mikro-alışkanlık, günlük duygu durumu (mood), Pomodoro odaklanma ve oyunlaştırma yapıları için belirlenen görsel dili, bileşen (widget) standartlarını, mikro-etkileşimleri ve ekran yerleşim kurallarını içerir.

---

## 1. Temel UI/UX Prensipleri

1. **Sıfır Sürtünme (Zero-Friction Tracking):** Alışkanlık tamamlama ve mood kaydı tek dokunuşla (tek tap) yapılabilmelidir. Modal pencereler ve sayaçlar bilişsel yükü minimumda tutmalıdır.
2. **Mikro-Etkileşim Odaklılık:** Tamamlanan her alışkanlıkta anlık haptik geri bildirim (hafif titreşim), yumuşak ölçeklenme (`ScaleTransition` 1.0 -> 1.05 -> 1.0) ve konfeti/parıltı efekti tetiklenir.
3. **Flat & Temiz Katmanlar:** Kartlarda gölge yerine 1px ince kenarlıklar (`AppColors.borderLight` / `borderDark`), geniş köşe yuvarlatmaları (`16px`) ve yüksek kontrastlı tipografi kullanılır.
4. **Veri Görselleştirme:** Başarı oranları, seriler ve süreler düz metin yerine halka göstergeler, alev sayaçları ve çubuk grafiklerle kullanıcıya anında hissettirilir.

---

## 2. Ortak ve Kritik Bileşen Tasarımları

### 2.1. Mood Tracker Seçim Barı (Daily Mood Bar)
Uygulama ilk açıldığında ana ekranın en üstünde veya hafif bir alt tabaka (bottom sheet) olarak açılır:

```text
+-----------------------------------------------------------------------+
|  Bugün nasıl hissediyorsun?                                           |
|  [ 🤩 Harika ]  [ 🙂 İyi ]  [ 😐 Normal ]  [ 😕 Kötü ]  [ 😫 Berbat ] |
+-----------------------------------------------------------------------+
```

- **Seçilmemiş Durum:** Çerçeveli, şeffaf/açık gri dolgulu, emoji ve altında 11px etiket metni.
- **Seçilmiş Durum:** Seçilen moda özel aktif renk (`AppColors.moodGreat`, `AppColors.moodGood` vb.) dolgusu, 1.05x ölçeklenme ve kalın yazı tipi.

### 2.2. Mikro-Alışkanlık Kartı Çeşitleri (Habit Cards)

1. **Standart Zaman Aralıklı & Silinebilir Kart (Tek Dokunuşla Tamamlama):**
   - Sol tarafta renkli kategori ikonu (`assets/icons/` veya `icons/` dizininden yüklenen ikon).
   - Ortada alışkanlık adı, kategori etiketi, zaman aralığı (`⏰ 09:45 - 15:36`), hatırlatıcı ikonu (`🔔`) ve seri göstergesi (`🔥 7 Gün`).
   - Sağ tarafta yeşil onay çemberi (`Checkbox` yerine özel dairesel dokunma alanı).
   - **Silme Etkileşimi (Swipe-to-Delete):** Kart sola kaydırıldığında kırmızı zemin ve çöp kutusu ikonu (`Icons.delete_outline`) ortaya çıkar. Bırakıldığında kullanıcıya silme onay diyaloğu gösterilir.

2. **Sayaçlı Kart (Su, Kitap Sayfası vb.):**
   - Sağ tarafta `[-]` `1250 / 2000 ml` `[+]` buton kümesi.
   - Kartın alt tabanında ince ilerleme çubuğu (`LinearProgressIndicator`).
   - Zaman aralığı ve hatırlatıcı durumu başlığın altında kompakt gösterilir.

3. **Geri Sayım / Süreç Kartı (Sigara Bırakma, Oruç):**
   - Kart üzerinde geçen toplam süreyi gösteren canlı zaman damgası (`14s 35dk`).
   - Tasarruf edilen bütçe veya hedeflenen aralık bilgisi.

```text
+-----------------------------------------------------------------------+
| [ 🏃 ]  Sabah Koşusu                                  [ 🔥 7 ]  ( ✓ ) |
|         Spor • ⏰ 09:45 - 15:36 • 🔔 Hatırlatıcı Açık                |
|         Günler: [Pzt] [Çar] [Cum]                                     |
+-----------------------------------------------------------------------+
```

### 2.3. Pomodoro Odak Kadranı (Dial Interface)
- Dairesel geri sayım çemberi (`CircularPercentIndicator` veya özel `CustomPainter`).
- Merkezde `25:00` büyük dijital zamanlayıcı (`36px bold`), hemen altında mod etiketi (`ODAKLANMA`, `KISA MOLA`, `UZUN MOLA`).
- Alt panelde başlat/durdur, sıfırla ve oturumu geç butonları.
- Tamamlanan her 4 oturumda 1 uzun mola döngüsü uyarısı.

### 2.4. Yol Haritası Düğüm Tasarımı (Roadmap Node)
- **Tamamlanan Aşama:** Zümrüt yeşili zemin, beyaz onay işareti, yeşil bağlantı çizgisi.
- **Aktif Aşama:** Zümrüt yeşili dış halka atımı (pulse efekti), açık detay paneli ve "Devam Et" butonu.
- **Kilitli Aşama:** Nötr gri daire, kilit ikonu (`Icons.lock_outline`) ve kesik çizgili gri hat.

### 2.5. Alışkanlık Ekleme / Düzenleme Modalı (Mindful Emerald Rhythm Layout)
Kullanıcı ana ekrandaki floating action button'a (`+`) bastığında veya bir kartı düzenlemek istediğinde açılan modalın `OTHER-DESIGN.md` ile birebir eşleşen mimarisi:

```text
+-----------------------------------------------------------------------+
|  (X)  Yeni Alışkanlık                                     [ ✓ Kaydet ]|
+-----------------------------------------------------------------------+
|  ⚡ KÜÇÜK ADIMLAR                                         +---------+ |
|  Rutinini inşa et, zinciri asla kırma.                    | ⏳ 3D   | |
|  Günde 15 dakika bile 1 yılda devasa bir dönüşüm sağlar.  | Glow    | |
|                                                           +---------+ |
+-----------------------------------------------------------------------+
|  Alışkanlık Adı *                                                     |
|  [ 📝  Örn: Sabah Koşusu ve Egzersiz                                ] |
+-----------------------------------------------------------------------+
|  İkon Seçimi                                               ✨ 10 Öneri |
|  [🏃 Koşu]  [💧 Su]   [📖 Kitap]  [🎵 Müzik]  [🧘 Zihin]             |
|  [🥗 Besin] [🚲 Bisiklet] [🎨 Sanat] [💻 Kod]   [🌙 Uyku]             |
+-----------------------------------------------------------------------+
|  Kategori                                            (+) Yeni Kategori|
|  +---------------------------+   +---------------------------+        |
|  | (●) 🏃 Spor               |   | (○) 🥗 Sağlık             |        |
|  +---------------------------+   +---------------------------+        |
|  | (○) 🧠 Zihin              |   | (○) 🎵 Müzik              |        |
|  +---------------------------+   +---------------------------+        |
|  [ Açılır Yeni Kategori Çekmecesi: İsim + 5 Renk Paleti + Ekle Butonu]|
+-----------------------------------------------------------------------+
|  Tekrar Günleri                          [ Hafta İçi ]    [ Her Gün ] |
|  [Pzt ✓]  [Sal •]  [Çar ✓]  [Per •]  [Cum ✓]  [Cmt •]  [Paz •]        |
+-----------------------------------------------------------------------+
|  Zaman Aralığı                                                        |
|  +---------------------------+   +---------------------------+        |
|  | Başlangıç Saati           |   | Bitiş Saati               |        |
|  | ⏰ 09:45               (v)|   | 🔄 15:36               (v)|        |
|  +---------------------------+   +---------------------------+        |
+-----------------------------------------------------------------------+
|  [ 🔔 ]  Hatırlatıcı Bildirim Gönder                 [ (✓) Switch ]   |
|          Aralık başlangıcında ve 15 dk önce uyar                      |
+-----------------------------------------------------------------------+
|  [ 🔥 Alışkanlığı Kaydet (Zinciri Başlat)                            ]|
|  [ 🗑️ Bu Alışkanlığı Sil (Düzenleme Modunda)                        ]|
+-----------------------------------------------------------------------+
```

---

## 3. Flutter Standart Bileşen Kodları (`lib/features/widgets/`)

### 3.1. Günlük Mood Seçim Widget'ı (`mood_selector_widget.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MoodItem {
  final String keyName;
  final String label;
  final String emoji;
  final Color activeColor;

  const MoodItem({
    required this.keyName,
    required this.label,
    required this.emoji,
    required this.activeColor,
  });
}

class MoodSelectorWidget extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelectorWidget({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<MoodItem> moods = [
    MoodItem(keyName: 'great', label: 'Harika', emoji: '🤩', activeColor: AppColors.moodGreat),
    MoodItem(keyName: 'good', label: 'İyi', emoji: '🙂', activeColor: AppColors.moodGood),
    MoodItem(keyName: 'neutral', label: 'Normal', emoji: '😐', activeColor: AppColors.moodNeutral),
    MoodItem(keyName: 'bad', label: 'Kötü', emoji: '😕', activeColor: AppColors.moodBad),
    MoodItem(keyName: 'terrible', label: 'Berbat', emoji: '😫', activeColor: AppColors.moodTerrible),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bugün nasıl hissediyorsun?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((mood) {
              final isSelected = selectedMood == mood.keyName;
              return GestureDetector(
                onTap: () => onMoodSelected(mood.keyName),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? mood.activeColor.withOpacity(0.18) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? mood.activeColor : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(mood.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(
                        mood.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? mood.activeColor
                              : (isDark ? AppColors.textDark.withOpacity(0.7) : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

### 3.2. Seri (Streak) ve Rozet Gösterge Rozeti (`streak_badge.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StreakBadge extends StatelessWidget {
  final int streakDays;

  const StreakBadge({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$streakDays Gün',
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3.3. Mikro-Alışkanlık Kartı Şablonu (`habit_card.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'streak_badge.dart';

class HabitCard extends StatelessWidget {
  final String id;
  final String title;
  final String categoryName;
  final IconData icon;
  final Color categoryColor;
  final int streakDays;
  final bool isCompleted;
  final String? startTime;      // Örn: '09:45'
  final String? endTime;        // Örn: '15:36'
  final bool hasReminder;       // Hatırlatıcı açık mı?
  final List<int> selectedDays; // [1..7] (1: Pazartesi ... 7: Pazar)
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.id,
    required this.title,
    required this.categoryName,
    required this.icon,
    required this.categoryColor,
    required this.streakDays,
    required this.isCompleted,
    this.startTime,
    this.endTime,
    this.hasReminder = false,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('habit_$id'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Alışkanlığı Sil?'),
            content: Text('"$title" alışkanlığını ve geçmiş serisini silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Vazgeç'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sil', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 26),
            SizedBox(width: 8),
            Text('Sil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isCompleted ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // İkon Kutusu
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: categoryColor, size: 22),
            ),
            const SizedBox(width: 12),
            // Başlık, Zaman Aralığı ve Kategori
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Zaman aralığı & Hatırlatıcı Rozeti
                  if (startTime != null && endTime != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.schedule, size: 13, color: AppColors.info),
                          const SizedBox(width: 4),
                          Text(
                            '$startTime - $endTime',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          if (hasReminder) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.notifications_active, size: 13, color: AppColors.secondary),
                          ],
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StreakBadge(streakDays: streakDays),
                    ],
                  ),
                ],
              ),
            ),
            // Tamamlama Butonu
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.primary
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. Sayfa Düzeni ve Boş Durum (Empty State) Standartları

- **Ekran Kenar Boşlukları:** `EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)`.
- **Boş Liste Durumu:** Kullanıcı henüz bir alışkanlık veya yol haritası eklemediğinde sadeleştirilmiş gri tonlu ikon ve aksiyon butonu gösterilir:
  - *İkon:* `Icons.checklist_rtl_rounded` (boyut: 48, renk: `AppColors.textSecondary`)
  - *Başlık:* "Henüz mikro-alışkanlık yok"
  - *Alt Başlık:* "Bugün için küçük bir hedef belirleyerek zincire başla."
  - *Buton:* `+ Yeni Mikro-Alışkanlık Ekle`

---

## 5. Responsive Düzen Mimarisi, S-M-L Standartları ve Taşma (Overflow) Önleme

### 5.1. Kırılım Noktaları (Breakpoints) & Hedef Ekranlar
```text
[ Kompakt: < 360px ]        [ Normal: 360px - 600px ]        [ Geniş: > 600px ]
Dar pencereler / Küçük cep      Standart Akıllı Telefonlar        Tablet / Masaüstü
Tek satır ellipsis, mikro badge     Esnek akışkan bileşenler          Max 600px kolon ortalama
```

### 5.2. Önceden Belirlenmiş Boyut Matrisi (S-M-L Boyut Değerleri)
Tüm bileşen genişlik ve yükseklikleri `AppSizes` tokenları üzerinden kontrol edilir:

| Eleman | Küçük (S) | Orta (M) | Büyük (L) | Genişlik (Width) Kuralı | Yükseklik (Height) Kuralı |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Kategori İkon Kutusu** | `28x28 px` | `38x38 px` | `48x48 px` | Sabit `AppSizes.iconBoxMd` | Sabit `AppSizes.iconBoxMd` |
| **Aksiyon / Stepper** | `32x32 px` | `38x38 px` | `44x44 px` | Sabit `32px` (Stepper) | Sabit `32px` (Stepper) |
| **Tamamlama Çemberi** | `32x32 px` | `38x38 px` | `44x44 px` | Sabit `38px` | Sabit `38px` |
| **Haftalık Takvim Günü** | Min `36 px`| Min `40 px`| Min `48 px`| **Akışkan `Expanded`** | Min `62 px` (`minHeight`) |
| **Alışkanlık Kartı** | Responsive | Responsive | Responsive | `double.infinity` | **Dinamik (Sabit Değil!)** |
| **İlerleme Çubuğu** | `4 px` | `6 px` | `8 px` | `double.infinity` | Sabit `6 px` |

### 5.3. Taşma (Overflow) ve Metin Kırılma Nedenleri & Kesin Çözümler

#### 1. Sayaçlı Kart Taşması (RenderFlex 74px Vertical Overflow & Tek Karakter Kırılması)
- **Hatalı Desen:** Alışkanlık başlığı ile `[-] 1500 / 2000 ml [+]` sayaç kümesini aynı yatay `Row` içine koymak. Sayaç grubu ~200px yer kapladığında dar ekranda başlığa yalnızca 30px kalır. Başlık metni `Su / İç / (Mikr / o / ...)` şeklinde harf harf alt satırlara bölünerek karttan 74 piksel dikey taşar.
- **Kesin Çözüm:** 
  1. Başlık satırında yalnızca `Icon (38x38)` + `Expanded (Başlık, Süre, Kategori, Seri)` yer alır. Başlık alanı ekranın tüm genişliğini kullanır (`maxLines: 2`, `overflow: TextOverflow.ellipsis`).
  2. Sayaç kontrolleri ve `LinearProgressIndicator` kartın **ALTINDA** ayrı ve tam genişlikli bir kontrol çubuğu olarak yerleştirilir.

#### 2. Takvim Şeridi Taşması (RenderFlex Right Overflow)
- **Hatalı Desen:** 7 gün öğesine sabit `width: 44px` vermek. 320px-340px genişlikte padding ile birlikte 308px'i aşarak sağdan sarı-siyah bant taşmasına yol açar.
- **Kesin Çözüm:** Gün öğeleri sabit genişlik yerine `Expanded` içine alınır (`Expanded(child: Container(...))`). Her gün mevcut ekran genişliğini 7 eşit parçaya böler, hiçbir cihazda taşma yapmaz.

#### 3. Üst Başlık (Header) Taşması
- **Hatalı Desen:** "Bugün, 24 Ekim" ve "Harika Bir Gün!" başlığı ile `12 Gün`, `Lv.3` rozetlerini kısıtlamasız yan yana koymak.
- **Kesin Çözüm:** Sol metin sütunu `Expanded` ile sarılır, metinlere `maxLines: 1` ve `overflow: TextOverflow.ellipsis` eklenir. Sağ rozetler `mainAxisSize: MainAxisSize.min` ile kompakt tutulur.

### 5.4. Günlük Mood Check-In Akışı (Single-Prompt Daily Policy)
1. Uygulama açılışında `StorageService.isMoodPromptShownToday(dateKey)` kontrol edilir.
2. O gün için sorulmamışsa açılışta `DailyMoodDialog` Bottom Sheet açılır.
3. Kullanıcı mod seçtiğinde veya "Daha Sonra" dediğinde o gün için flag kaydedilir; gün boyunca tekrar **ASLA** açılmaz.
4. Ana ekranda mod seçimi yapıldıktan sonra büyük blok gizlenir; üst başlıkta interaktif `[🤩 Harika]` rozeti gösterilir.

### 5.5. Aylık Aktivite Izgarası (Interactive Monthly Heatmap) Standartları
1. **Görsel Düzen:**
   - 7 kolonlu takvim şeması (Pzt, Sal, Çar, Per, Cum, Cmt, Paz).
   - Hücreler `Expanded` ile sarılarak responsive esneklik sağlanır.
   - 5 kademeli Zümrüt Yeşili dolgu:
     - 0 Alışkanlık: `surfaceContainerHigh` / pasif zemin
     - 1 Alışkanlık: `AppColors.primary` (%25 alpha)
     - 2 Alışkanlık: `AppColors.primary` (%50 alpha)
     - 3 Alışkanlık: `AppColors.primary` (%75 alpha)
     - 4+ Alışkanlık: `AppColors.primary` (tam opak zümrüt)
   - Bugün: `AppColors.secondary` ile 2px belirgin kontur vurgusu.
2. **Hover / Üzerine Gelme Etkileşimi:**
   - Her hücre masaüstü için `Tooltip` ve `MouseRegion` ile sarılmıştır.
   - Hücrenin üzerine gelindiğinde (hover) hemen üstteki canlı bilgi çubuğunda: `"{Gün} {Ay}: {Sayı} alışkanlık tamamlandı (Detaylar için tıkla)"` metni belirir.
3. **Tıklama (Tap) ile Gün Detay Modalı:**
   - Hücreye tıklandığında haptik geri bildirim ile modern `showModalBottomSheet` açılır.
   - *Başlık:* Tam tarih (Örn: "23 Ekim 2026, Cuma") ve tamamlama oranı rozeti (Örn: `3 / 4 (%75)`).
   - *Duygu Durumu:* Varsa o günün kayıtlı mood'u (Örn: `🤩 Harika`).
   - *Alışkanlık Listesi:* O gün icra edilen tüm alışkanlıklar kategori ikonu, başlık, kategori etiketi, zaman aralığı ve "Tamamlandı / Yapılmadı" durumu ile listelenir.