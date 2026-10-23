# Sayfa 1: Ana Ekran & Günlük Takip Paneli (sayfalar/SAYFA1.md)

## 1. Ekran Amacı ve Özeti
Kullanıcının uygulamayı açtığında karşılaştığı merkezi ekrandır. Günlük duygu durumunu (Mood) tek dokunuşla kaydettiği, o güne ait mikro-alışkanlıkları listelediği, su ve okuma gibi sayaçları pratikçe güncellediği ve aktif serisini (streak) takip ettiği alandır.

---

## 2. Arayüz Hiyerarşisi ve Bileşen Yerleşimi

```text
+-----------------------------------------------------------------------+
|  [ Profil Avatar ]  Bugün, 24 Ekim          [ 🔥 12 Gün ] [ ⚡ Lv.3 ] |
+-----------------------------------------------------------------------+
|  Bugün nasıl hissediyorsun?                                           |
|  [ 🤩 Harika ]  [ 🙂 İyi ]  [ 😐 Normal ]  [ 😕 Kötü ]  [ 😫 Berbat ] |
+-----------------------------------------------------------------------+
|  < Pzt 20 >  < Sal 21 >  < Çar 22 >  [ Per 23* ]  < Cum 24 >          |
+-----------------------------------------------------------------------+
|  Günün İlerlemesi: 3 / 4 Tamamlandı                         %75       |
|  [=========================================-------]                   |
+-----------------------------------------------------------------------+
|  Filtreler: [ Tümü ] [ Spor ] [ Sağlık ] [ Zihin ] [ Müzik ] [+ Kat.] |
+-----------------------------------------------------------------------+
|  (Sola kaydırarak sil: ◀◀ [ 🗑️ Sil ])                                 |
|  [ 🏃 ] Sabah Koşusu                                                  |
|         Spor • ⏰ 09:45 - 15:36 • 🔔 Açık • 🔥 7 Gün          ( ✓ )  |
|  [ 💧 ] Su İç (Mikro Adım: 250ml)                                     |
|         Sağlık • ⏰ 08:00 - 22:00 • 1500 / 2000 ml            [-] [+] |
|  [ 📖 ] 5 Sayfa Kitap Oku                                             |
|         Zihin • ⏰ 20:00 - 21:00 • 🔥 14 Gün                  ( ✓ )  |
|  [ 🎸 ] Gitar Pratiği (Akor Geçişleri)                                |
|         Müzik • ⏰ 18:30 - 19:15 • 🔔 Açık • 🔥 3 Gün         ( ✓ )  |
+-----------------------------------------------------------------------+
|                                                           [ + Ekle ]  |
+-----------------------------------------------------------------------+
```

### 2.1. Üst Başlık (Header / App Bar)
- **Sol Kısım:** Kullanıcı profil resmi / avatarı ve altında güncel tarih formatı (`dd MMMM, EEEE`).
- **Sağ Kısım:** Genel seri alevi (`StreakBadge`: `🔥 12 Gün`) ve mevcut XP / Seviye çipi (`LevelBadge`: `⚡ Lv.3`).

### 2.2. Günlük Mood Tracker Barı
- Günün ilk açılışında dikkat çeken, `DESIGN.md` standardındaki `MoodSelectorWidget`.
- Kullanıcı o gün için henüz seçim yapmadıysa hafif pulse animasyonuyla dikkat çeker; seçim yapıldıktan sonra kompakt hale gelir veya seçilen duygu vurgulu olarak kalır.

### 2.3. Yatay Haftalık Takvim Şeridi (Weekly Calendar Strip)
- Mevcut haftanın 7 gününü yatayda kaydırılabilir veya sabit gösteren mini takvim şeridi.
- Geçmiş günlerde alışkanlıkların tamamlanma durumuna göre gün kutucuğunun altında küçük yeşil/turuncu noktalar (dots) yer alır.
- Başka bir güne dokunulduğunda o güne ait seçili alışkanlıklar listelenir (yalnızca o gün için seçilmiş olan alışkanlıklar listelenir).

### 2.4. Günlük İlerleme Kartı (Daily Progress Bar)
- Tamamlanan alışkanlık sayısı / Toplam alışkanlık sayısı (`3 / 4`).
- Yüzdelik lineer ilerleme çubuğu (`LinearProgressIndicator`). %100'e ulaşıldığında yeşil renge bürünür ve hafif bir konfeti animasyonu tetiklenir.

### 2.5. Kategori Filtreleme Çipleri (4 Temel Kategori + Dinamik Kategoriler)
- Yatay kaydırılabilir kategori çip şeridi:
  - `[ Tümü ]`
  - `[ 🏃 Spor ]` (Varsayılan Temel 1)
  - `[ 💧 Sağlık ]` (Varsayılan Temel 2)
  - `[ 🧘 Zihin ]` (Varsayılan Temel 3)
  - `[ 🎸 Müzik ]` (Varsayılan Temel 4)
  - `[ + Kategori Ekle ]` (Kullanıcının dinamik yeni kategori oluşturma butonu)
- Seçilen kategoriye dokunulduğunda liste anında filtrelenir; `+ Kategori Ekle` butonuna basıldığında yeni kategori oluşturma diyaloğu açılır.

### 2.6. Alışkanlık Listesi & Silme Etkileşimi (Habit List Area)
- **Zaman Aralığı ve Hatırlatıcı:** Kart üzerinde kullanıcının belirlediği saat aralığı (`⏰ 09:45 - 15:36`) ve hatırlatıcı aktifse zil ikonu (`🔔`) gösterilir.
- **Silme İşlemi (Swipe to Delete):** Kullanıcı alışkanlık kartını sola kaydırdığında arka planda kırmızı renkli çöp kutusu ikonu belirir. Kart tamamen çekildiğinde bir onay diyaloğu (`showDialog`) çıkarak kazara silinmeyi engeller; onay verildiğinde `_habitController.deleteHabit(id)` tetiklenir ve kart ekrandan kaldırılır.
- **Haftalık Gün Uyumu:** Alışkanlık sadece kullanıcının seçtiği haftalık günlerde (Pzt, Sal vb.) bugünün tarihiyle eşleşiyorsa ana ekranda görünür.
- Kart tipleri `DESIGN.md` standartlarına uygundur:
  - **Tek Dokunuşlu Tik Kartı:** Kitap okuma, soğuk duş, yürüyüş vb. Dokunulduğunda `HapticFeedback.lightImpact()` tetiklenir, onay dairesi yeşile döner.
  - **Adımlı Sayaç Kartı:** Su takibi (`+250 ml`), sayfa sayısı (`+5 sayfa`). `[-]` ve `[+]` butonlarıyla anlık güncellenir.
  - **Süreç / Bırakma Kartı:** Sigara bırakma, oruç. Başlangıç anından itibaren geçen süreyi canlı gösterir.

---

## 3. Durum Yönetimi (State Architecture)

Modüler `ValueNotifier` mimarisi kullanılır:

### 3.1. `HabitController` (`features/controllers/habit_controller.dart`)
- `ValueNotifier<List<HabitModel>> habitsNotifier`: Günün alışkanlık listesini tutar.
- `ValueNotifier<List<CategoryModel>> categoriesNotifier`: 4 temel kategori + kullanıcı kategorilerini tutar.
- `ValueNotifier<String> selectedCategoryNotifier`: Seçili filtre kategorisini tutar (`all`, `sport`, `health`, `mind`, `music` vb.).
- `ValueNotifier<DateTime> selectedDateNotifier`: Seçili takvim gününü tutar.
- **Fonksiyonlar:**
  - `addHabit(HabitModel habit)`: Yeni alışkanlık ekler (isim, `icons/` yolu, haftalık günler, saat aralığı, hatırlatıcı, kategori).
  - `deleteHabit(String id)`: İlgili alışkanlığı listeden ve yerel depolamadan kalıcı olarak siler.
  - `toggleHabit(String id)`: İlgili alışkanlığın tamamlanma durumunu tersine çevirir, streak ve XP hesaplar.
  - `addCategory(CategoryModel category)`: Kullanıcının eklediği yeni kategoriyi kaydeder.
  - `filterByCategory(String categoryId)`: Listeyi seçili kategoriye göre filtreler.
  - `changeSelectedDate(DateTime date)`: Takvimden seçilen günün haftalık gün indeksine göre (Pzt..Paz) alışkanlıkları filtreler.

### 3.2. `MoodController` (`features/controllers/mood_controller.dart`)
- `ValueNotifier<String?> todayMoodNotifier`: Günün seçilen modunu tutar (`great`, `good`, `neutral`, `bad`, `terrible`).
- **Fonksiyonlar:**
  - `setTodayMood(String moodKey)`: Modu yerel hafızaya kaydeder ve analitik modülüne sinyal gönderir.

---

## 4. Veri Modelleri

### 4.1. `CategoryModel` (`features/models/category_model.dart`)
```dart
class CategoryModel {
  final String id;
  final String name;
  final String iconPath; // assets/icons/ veya Material Icon adı
  final int colorHex;    // Renk onaltılık değeri
  final bool isCustom;   // true: kullanıcı ekledi, false: 4 temel kategoriden biri

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.colorHex,
    this.isCustom = false,
  });

  // Başlangıçtaki 4 Temel Kategori
  static const List<CategoryModel> defaultCategories = [
    CategoryModel(id: 'sport', name: 'Spor', iconPath: 'assets/icons/sport.svg', colorHex: 0xFF10B981),
    CategoryModel(id: 'health', name: 'Sağlık', iconPath: 'assets/icons/health.svg', colorHex: 0xFF0EA5E9),
    CategoryModel(id: 'mind', name: 'Zihin', iconPath: 'assets/icons/mind.svg', colorHex: 0xFF8B5CF6),
    CategoryModel(id: 'music', name: 'Müzik', iconPath: 'assets/icons/music.svg', colorHex: 0xFFEC4899),
  ];
}
```

### 4.2. `HabitModel` (`features/models/habit_model.dart`)
```dart
enum HabitType { checkmark, counter, timer }

class HabitModel {
  final String id;
  final String title;
  final String categoryId;
  final String iconPath;        // assets/icons/ dizininden seçilen dosya yolu
  final HabitType type;
  final List<int> selectedDays; // Haftanın seçilen günleri (1: Pazartesi ... 7: Pazar)
  final String startTime;       // Örn: "09:45"
  final String endTime;         // Örn: "15:36"
  final bool hasReminder;       // Hatırlatıcı bildirim açık mı?
  final double currentProgress;
  final double targetProgress;
  final String unit;            // 'ml', 'sayfa', 'dk' vb.
  final int streakDays;
  final bool isCompleted;
  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.iconPath,
    required this.type,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    required this.startTime,
    required this.endTime,
    this.hasReminder = false,
    required this.currentProgress,
    required this.targetProgress,
    required this.unit,
    required this.streakDays,
    required this.isCompleted,
    required this.createdAt,
  });

  HabitModel copyWith({
    String? title,
    String? categoryId,
    String? iconPath,
    List<int>? selectedDays,
    String? startTime,
    String? endTime,
    bool? hasReminder,
    double? currentProgress,
    int? streakDays,
    bool? isCompleted,
  }) {
    return HabitModel(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      iconPath: iconPath ?? this.iconPath,
      type: type,
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hasReminder: hasReminder ?? this.hasReminder,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress,
      unit: unit,
      streakDays: streakDays ?? this.streakDays,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
```

---

## 5. View Kod İskeleti (`features/views/home_view.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/habit_controller.dart';
import '../controllers/mood_controller.dart';
import '../widgets/mood_selector_widget.dart';
import '../widgets/daily_calendar_strip.dart';
import '../widgets/habit_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HabitController _habitController;
  late final MoodController _moodController;

  @override
  void initState() {
    super.initState();
    _habitController = HabitController();
    _moodController = MoodController();
    _habitController.loadDailyHabits();
  }

  @override
  void dispose() {
    _habitController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),
              ValueListenableBuilder<String?>(
                valueListenable: _moodController.todayMoodNotifier,
                builder: (context, currentMood, _) {
                  return MoodSelectorWidget(
                    selectedMood: currentMood,
                    onMoodSelected: _moodController.setTodayMood,
                  );
                },
              ),
              const SizedBox(height: 16),
              DailyCalendarStrip(
                selectedDateNotifier: _habitController.selectedDateNotifier,
                onDateSelected: _habitController.changeSelectedDate,
              ),
              const SizedBox(height: 16),
              _buildCategoryFilterBar(),
              const SizedBox(height: 16),
              _buildProgressOverview(),
              const SizedBox(height: 16),
              _buildHabitsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // Sayfa 6: Alışkanlık Ekleme / Düzenleme Modalı Açılır
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddEditHabitModal(
              onSave: (newHabit) => _habitController.addHabit(newHabit),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryFilterBar() {
    return ValueListenableBuilder<List<CategoryModel>>(
      valueListenable: _habitController.categoriesNotifier,
      builder: (context, categories, _) {
        return ValueListenableBuilder<String>(
          valueListenable: _habitController.selectedCategoryNotifier,
          builder: (context, selectedId, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Tümü'),
                    selected: selectedId == 'all',
                    onSelected: (_) => _habitController.filterByCategory('all'),
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((cat) {
                    final isSelected = selectedId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        selectedColor: Color(cat.colorHex).withOpacity(0.2),
                        onSelected: (_) => _habitController.filterByCategory(cat.id),
                      ),
                    );
                  }),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('Kategori'),
                    onPressed: () {
                      // Yeni Kategori Ekleme Diyaloğu Tetiklenir
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Bugün, 24 Ekim',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            SizedBox(height: 2),
            Text(
              'Harika Bir Gün!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_fire_department_rounded, size: 18, color: AppColors.secondary),
                  SizedBox(width: 4),
                  Text(
                    '12 Gün',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildProgressOverview() {
    return ValueListenableBuilder<List<HabitModel>>(
      valueListenable: _habitController.habitsNotifier,
      builder: (context, habits, _) {
        if (habits.isEmpty) return const SizedBox.shrink();
        final completed = habits.where((h) => h.isCompleted).length;
        final ratio = habits.isEmpty ? 0.0 : completed / habits.length;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Günün İlerlemesi: $completed / ${habits.length}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '%${(ratio * 100).toInt()}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: AppColors.borderLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitsSection() {
    return ValueListenableBuilder<List<HabitModel>>(
      valueListenable: _habitController.habitsNotifier,
      builder: (context, habits, _) {
        if (habits.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Bugün için henüz alışkanlık eklenmedi.'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return HabitCard(
              id: habit.id,
              title: habit.title,
              categoryName: habit.categoryId,
              icon: Icons.check_circle_outline,
              categoryColor: AppColors.primary,
              streakDays: habit.streakDays,
              isCompleted: habit.isCompleted,
              startTime: habit.startTime,
              endTime: habit.endTime,
              hasReminder: habit.hasReminder,
              selectedDays: habit.selectedDays,
              onToggle: () => _habitController.toggleHabit(habit.id),
              onDelete: () => _habitController.deleteHabit(habit.id),
            );
          },
        );
      },
    );
  }
}
```