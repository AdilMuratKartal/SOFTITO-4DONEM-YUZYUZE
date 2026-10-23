# Sayfa 6: Alışkanlık Ekleme, Düzenleme, Silme & Kategori Yönetimi Modalı (sayfalar/SAYFA6.md)

## 1. Ekran Amacı ve Özeti

Kullanıcının yeni bir mikro-alışkanlık tanımladığı, mevcut alışkanlıklarını güncellediği veya sildiği; ayrıca alışkanlıklarını kategorilere ayırıp yeni özel kategoriler türetebildiği **Alışkanlık & Kategori Yönetim Modülü**dür.

Bu modal/ekran; Ana Ekran'daki (`SAYFA1.md`) `+` Floating Action Button'a basıldığında veya mevcut bir alışkanlık kartına düzenleme amacıyla tıklandığında açılır.

### Temel Fonksiyonlar:
1. **Alışkanlık İsmi Belirleme:** Metin girdisi (`TextFormField`) ile serbest başlık tanımlama.
2. **İkon Seçimi (`icons/`):** Uygulama bünyesindeki `assets/icons/` klasöründen yüklenen görsel ikon kümesinden tek dokunuşla seçim yapabilme.
3. **Kategorilendirme:** 4 temel kategori (**Spor**, **Sağlık**, **Zihin**, **Müzik**) arasından seçim yapabilme ve `+ Kategori Ekle` seçeneğiyle dinamik yeni kategoriler oluşturabilme.
4. **Haftalık Gün(ler) Seçimi:** Haftanın 7 günü (Pzt, Sal, Çar, Per, Cum, Cmt, Paz) arasından birden fazla gün seçebilme (seçilen günlerde alışkanlık aktifleşir).
5. **Zaman Aralığı Belirleme:** Alışkanlığın uygulanacağı başlangıç ve bitiş saatini seçebilme (Örn: `09:45 - 15:36`).
6. **Hatırlatıcı Bildirim Tiki:** Zamanı geldiğinde kullanıcıya bildirim/hatırlatıcı gitmesini sağlayan açılır/kapanır anahtar (Switch).
7. **Alışkanlık Silme:** Mevcut bir alışkanlık düzenlenirken kırmızı "Alışkanlığı Sil" butonu ve onay diyaloğu ile kalıcı silme işlemi.

---

## 2. Arayüz Hiyerarşisi ve Bileşen Yerleşimi (Mindful Emerald Rhythm)

```text
+-----------------------------------------------------------------------+
|  [ Kapat (X) ]            Yeni Alışkanlık               [ Kaydet (✓) ]|
+-----------------------------------------------------------------------+
|  ⚡ KÜÇÜK ADIMLAR                                         +---------+ |
|  Rutinini inşa et, zinciri asla kırma.                    | ⏳ 3D   | |
|  Günde 15 dakika bile 1 yılda devasa bir dönüşüm sağlar.  | Glow    | |
|                                                           +---------+ |
+-----------------------------------------------------------------------+
|  Alışkanlık Adı *                                                     |
|  ┌─────────────────────────────────────────────────────────────────┐  |
|  │ 📝 Örn: Sabah Koşusu ve Egzersiz                                │  |
|  └─────────────────────────────────────────────────────────────────┘  |
+-----------------------------------------------------------------------+
|  İkon Seçimi                                               ✨ 10 Öneri |
|  [🏃 Koşu]   [💧 Su]     [📖 Kitap]   [🎵 Müzik]   [🧘 Zihin]         |
|  [🥗 Besin]  [🚲 Bisiklet][🎨 Sanat]  [💻 Kod]     [🌙 Uyku]          |
+-----------------------------------------------------------------------+
|  Kategori                                            (+) Yeni Kategori|
|  ┌───────────────────────────┐     ┌───────────────────────────┐      |
|  │ (●) 🏃 Spor               │     │ (○) 🥗 Sağlık             │      |
|  └───────────────────────────┘     └───────────────────────────┘      |
|  ┌───────────────────────────┐     ┌───────────────────────────┐      |
|  │ (○) 🧠 Zihin              │     │ (○) 🎵 Müzik              │      |
|  └───────────────────────────┘     └───────────────────────────┘      |
|  [ Açılır Çekmece: İsim Girişi + 5 Renk Paleti Noktası + Ekle Butonu ]|
+-----------------------------------------------------------------------+
|  Tekrar Günleri                          [ Hafta İçi ]    [ Her Gün ] |
|  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐        |
|  │ Pzt │  │ Sal │  │ Çar │  │ Per │  │ Cum │  │ Cmt │  │ Paz │        |
|  │ (✓) │  │ (•) │  │ (✓) │  │ (•) │  │ (✓) │  │ (•) │  │ (•) │        |
|  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘        |
+-----------------------------------------------------------------------+
|  Zaman Aralığı                                                        |
|  ┌───────────────────────────┐     ┌───────────────────────────┐      |
|  │ Başlangıç Saati           │     │ Bitiş Saati               │      |
|  │ ⏰ 09:45               (v)│     │ 🔄 15:36               (v)│      |
|  └───────────────────────────┘     └───────────────────────────┘      |
+-----------------------------------------------------------------------+
|  [ 🔔 ]  Hatırlatıcı Bildirim Gönder                 [ (✓) Switch ]   |
|          Aralık başlangıcında ve 15 dk önce uyar                      |
+-----------------------------------------------------------------------+
|  ┌─────────────────────────────────────────────────────────────────┐  |
|  │              [ 🔥 Alışkanlığı Kaydet (Zinciri Başlat) ]         │  |
|  └─────────────────────────────────────────────────────────────────┘  |
|  (Eğer Mevcut Alışkanlık Düzenleniyorsa):                             |
|  ┌─────────────────────────────────────────────────────────────────┐  |
|  │                   [ 🗑️ Bu Alışkanlığı Sil ]                      │  |
|  └─────────────────────────────────────────────────────────────────┘  |
+-----------------------------------------------------------------------+
```

### 2.1. Üst Başlık (Header Bar)
- **Sol Buton:** Kapatma / İptal (`Icons.close_rounded`) — formu kaydetmeden kapatır.
- **Orta Başlık:** "Yeni Mikro-Alışkanlık" veya "Alışkanlığı Düzenle".
- **Sağ Buton:** Hızlı Kaydet onay butonu (`Icons.check_rounded`).

### 2.2. Alışkanlık İsmi Girişi
- `TextFormField` ile doğrulamalı (validator: boş bırakılamaz, en az 3 karakter) metin alanı.
- `AppTheme` standartlarında yuvarlatılmış kenarlık (`BorderRadius.circular(12)`).

### 2.3. İkon Seçici Izgarası (`assets/icons/`)
- Projedeki `assets/icons/` klasöründe yer alan SVG/vektör ikonların yatay kaydırılabilir veya ızgara (`GridView`) şeklinde listelenmesi.
- Seçili ikon etrafında `AppColors.primary` (Zümrüt Yeşili) renkli çerçeve ve hafif büyüme animasyonu (`ScaleTransition`).

### 2.4. Kategori Seçimi & Dinamik Kategori Ekleme
- **4 Temel Kategori:**
  1. **Spor:** İkon: `sport.svg` / Yeşil renk (`0xFF10B981`)
  2. **Sağlık:** İkon: `health.svg` / Gök Mavisi renk (`0xFF0EA5E9`)
  3. **Zihin:** İkon: `mind.svg` / Menekşe Moru renk (`0xFF8B5CF6`)
  4. **Müzik:** İkon: `music.svg` / Canlı Pembe renk (`0xFFEC4899`)
- **[ + Kategori Ekle ] Butonu:** Tıklandığında küçük bir diyalog (`AddCategoryDialog`) açılır; kullanıcı kategori adını yazar, renk paletinden bir renk seçer ve yeni kategori anında listeye eklenir.

### 2.5. Haftalık Gün Seçici (Week Day Selector)
- 7 adet dairesel/oval buton: `Pzt`, `Sal`, `Çar`, `Per`, `Cum`, `Cmt`, `Paz` (indeksler: 1..7).
- Çoklu seçim desteklenir. Kullanıcı tıkladığı günleri aktif (`AppColors.primary`) veya pasif yapar.
- Seçilen günlerin sayısı kartın hemen altında dinamik özetlenir: *"Haftada 3 gün seçildi"*.

### 2.6. Zaman Aralığı Seçici (Time Range Picker)
- İki adet interaktif zaman kutusu: **Başlangıç Saati** ve **Bitiş Saati**.
- Tıklandığında Flutter'ın yerel `showTimePicker` diyaloğu açılır.
- Kullanıcı dilediği dakikayı seçebilir (Örn: Başlangıç: `09:45`, Bitiş: `15:36`).
- Bitiş saatinin başlangıç saatinden sonra olması kuralı kontrol edilir.

### 2.7. Hatırlatıcı Bildirim Switch'i
- `SwitchListTile` bileşeni: "Başlangıç saatinde bana hatırlat".
- Switch açıldığında bildirim izni kontrol edilir ve başlangıç saatinde yerel bildirim (`flutter_local_notifications`) planlaması tetiklenir.

### 2.8. Silme Aksiyonu (Delete Action)
- Mevcut bir alışkanlık güncelleniyorsa formun en altında kırmızı renkli `[ 🗑️ Bu Alışkanlığı Kalıcı Olarak Sil ]` butonu yer alır.
- Butona basıldığında onay diyalogu (`showDialog`) açılır:
  - *"Bu alışkanlığı silmek istediğinize emin misiniz? Tüm geçmiş streak verileri silinecektir."*
  - Onay verildiğinde `_habitController.deleteHabit(habit.id)` çalıştırılır ve sayfa kapatılır.

---

## 3. Durum Yönetimi ve Form Kontrolü

Form durumu bir controller veya `StatefulWidget` içerisinde aşağıdaki reaktif yapıyla yönetilir:

```dart
class HabitFormData {
  String title = '';
  String categoryId = 'sport';
  String iconPath = 'assets/icons/sport.svg';
  List<int> selectedDays = [1, 2, 3, 4, 5]; // Varsayılan: Hafta içi
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 45);
  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 36);
  bool hasReminder = true;
}
```

### Form Doğrulama (Validation) Kuralları:
1. `title`: Boş olamaz, en az 3, en fazla 40 karakter.
2. `selectedDays`: En az 1 gün seçilmiş olmalıdır (`selectedDays.isNotEmpty`).
3. `startTime` & `endTime`: Geçerli bir zaman aralığı olmalıdır.
4. `categoryId`: Geçerli bir kategori seçilmiş olmalıdır.

---

## 4. Ekran / Modal Kod İskeleti (`lib/features/views/add_edit_habit_view.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import '../models/category_model.dart';

class AddEditHabitModal extends StatefulWidget {
  final HabitModel? existingHabit;
  final ValueChanged<HabitModel> onSave;
  final VoidCallback? onDelete;

  const AddEditHabitModal({
    super.key,
    this.existingHabit,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditHabitModal> createState() => _AddEditHabitModalState();
}

class _AddEditHabitModalState extends State<AddEditHabitModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late String _selectedCategoryId;
  late String _selectedIconPath;
  late List<int> _selectedDays;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _hasReminder;

  final List<String> _availableIcons = [
    'assets/icons/sport.svg',
    'assets/icons/health.svg',
    'assets/icons/mind.svg',
    'assets/icons/music.svg',
    'assets/icons/water.svg',
    'assets/icons/book.svg',
    'assets/icons/meditation.svg',
    'assets/icons/guitar.svg',
  ];

  List<CategoryModel> _categories = List.from(CategoryModel.defaultCategories);

  @override
  void initState() {
    super.initState();
    final h = widget.existingHabit;
    _titleController = TextEditingController(text: h?.title ?? '');
    _selectedCategoryId = h?.categoryId ?? 'sport';
    _selectedIconPath = h?.iconPath ?? _availableIcons.first;
    _selectedDays = h != null ? List.from(h.selectedDays) : [1, 2, 3, 4, 5];
    _startTime = const TimeOfDay(hour: 9, minute: 45);
    _endTime = const TimeOfDay(hour: 15, minute: 36);
    _hasReminder = h?.hasReminder ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _showAddCategoryDialog() {
    final catController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Kategori Ekle'),
        content: TextField(
          controller: catController,
          decoration: const InputDecoration(hintText: 'Kategori Adı (Örn: Yazılım)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          ElevatedButton(
            onPressed: () {
              if (catController.text.trim().isNotEmpty) {
                final newCat = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: catController.text.trim(),
                  iconPath: 'assets/icons/custom.svg',
                  colorHex: 0xFFF59E0B,
                  isCustom: true,
                );
                setState(() {
                  _categories.add(newCat);
                  _selectedCategoryId = newCat.id;
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir gün seçin.')),
      );
      return;
    }

    final formatTime = (TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final habit = HabitModel(
      id: widget.existingHabit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      categoryId: _selectedCategoryId,
      iconPath: _selectedIconPath,
      type: HabitType.checkmark,
      selectedDays: _selectedDays,
      startTime: formatTime(_startTime),
      endTime: formatTime(_endTime),
      hasReminder: _hasReminder,
      currentProgress: widget.existingHabit?.currentProgress ?? 0,
      targetProgress: 1,
      unit: 'tamamlama',
      streakDays: widget.existingHabit?.streakDays ?? 0,
      isCompleted: widget.existingHabit?.isCompleted ?? false,
      createdAt: widget.existingHabit?.createdAt ?? DateTime.now(),
    );

    widget.onSave(habit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Çubuk
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.existingHabit == null ? 'Yeni Mikro-Alışkanlık' : 'Alışkanlığı Düzenle',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_rounded, color: AppColors.primary),
                    onPressed: _submit,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Alışkanlık Adı
              const Text('Alışkanlık Adı', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Sabah Koşusu, 5 Sayfa Oku...',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().length < 3) ? 'En az 3 karakter giriniz' : null,
              ),
              const SizedBox(height: 16),

              // Kategori Seçimi (4 Temel + Özel)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Kategori Ekle'),
                    onPressed: _showAddCategoryDialog,
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSel = _selectedCategoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: isSel,
                        selectedColor: Color(cat.colorHex).withOpacity(0.2),
                        onSelected: (_) => setState(() => _selectedCategoryId = cat.id),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Haftalık Günler
              const Text('Haftalık Tekrar Günleri', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (idx) {
                  final dayNum = idx + 1;
                  final isSelected = _selectedDays.contains(dayNum);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDays.remove(dayNum);
                        } else {
                          _selectedDays.add(dayNum);
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelected ? AppColors.primary : AppColors.borderLight,
                      child: Text(
                        dayNames[idx],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Zaman Aralığı (Örn: 09:45 - 15:36)
              const Text('Zaman Aralığı', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text('Başlangıç: ${_startTime.format(context)}'),
                      onPressed: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time_filled),
                      label: Text('Bitiş: ${_endTime.format(context)}'),
                      onPressed: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hatırlatıcı Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Başlangıçta Hatırlatıcı Gönder'),
                subtitle: const Text('Zamanı geldiğinde anlık bildirim al'),
                value: _hasReminder,
                onChanged: (val) => setState(() => _hasReminder = val),
              ),
              const SizedBox(height: 20),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: _submit,
                  child: Text(
                    widget.existingHabit == null ? 'Alışkanlığı Kaydet' : 'Değişiklikleri Kaydet',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Düzenleme Halinde Silme Butonu
              if (widget.existingHabit != null && widget.onDelete != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Bu Alışkanlığı Kalıcı Olarak Sil'),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Alışkanlığı Sil?'),
                          content: const Text('Bu işlem geri alınamaz.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Vazgeç')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Sil', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        widget.onDelete!();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Doğrulama ve Test Adımları

1. **Ekleme Testi:** Form alanları (İsim, ikon, günler, saat aralığı, hatırlatıcı, kategori) doldurulduğunda `HabitModel` doğru verilerle üretilmeli ve listeye anında yansımalıdır.
2. **Haftalık Gün Uyumu:** Seçilmeyen günlerde bu alışkanlık ana ekran listesinde görünmemelidir.
3. **Zaman Aralığı:** `09:45 - 15:36` gibi özel saat aralıkları kart üzerinde rozet olarak gösterilmelidir.
4. **Silme Testi:** Kart sola kaydırıldığında (Dismissible) veya modal içinden "Alışkanlığı Sil" tıklandığında onay diyaloğu çıkmalı, onay verilince listeden ve veritabanından kalıcı olarak kaldırılmalıdır.
5. **Kategori Ekleme:** 4 temel kategori haricinde eklenen yeni kategoriler çip listesinde seçilebilir olmalı ve ana ekran filtrelerine dahil edilmelidir.
