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

### 2.5. Alışkanlık Ekleme / Düzenleme Modalı (Add & Edit Habit Sheet)
Kullanıcı ana ekrandaki floating action button'a (`+`) bastığında ekranın altından yumuşakça yükselen (DraggableBottomSheet) form yapısı:

```text
+-----------------------------------------------------------------------+
|  Yeni Alışkanlık Ekle                                             (X) |
+-----------------------------------------------------------------------+
|  Alışkanlık Adı: [ Sabah Egzersizi ve Koşu                          ] |
+-----------------------------------------------------------------------+
|  İkon Seçimi (icons/):                                                |
|  [ 🏃 ]  [ 💧 ]  [ 📖 ]  [ 🎸 ]  [ 🧘 ]  [ 🍏 ]  [ 🚴 ]  [ 🎨 ]       |
+-----------------------------------------------------------------------+
|  Kategori Seçimi:                                                     |
|  (●) Spor    (○) Sağlık    (○) Zihin    (○) Müzik    [ + Kategori ]   |
+-----------------------------------------------------------------------+
|  Haftalık Günler:                                                     |
|  [Pzt ✓]  [Sal  ]  [Çar ✓]  [Per  ]  [Cum ✓]  [Cmt  ]  [Paz  ]        |
+-----------------------------------------------------------------------+
|  Zaman Aralığı:                                                       |
|  Başlangıç: [ 09:45 ]           Bitiş: [ 15:36 ]                      |
+-----------------------------------------------------------------------+
|  Hatırlatıcı Bildirim:                                [ (ON) Switch ] |
+-----------------------------------------------------------------------+
|  [ Vazgeç ]                                     [ Alışkanlığı Kaydet ]|
|  (Düzenlemede: [ 🗑️ Bu Alışkanlığı Sil ])                              |
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