import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';
import '../../models/habit_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../models/category_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../../widgets/confirmation_dialog.dart'; // Sayfada tekrar tekrar kullanacağımız özel widget bileşenlerimizi içeri aktarıyoruz

class AddEditHabitModal extends StatefulWidget { // AddEditHabitModal sınıfı, zamanla durumu (state) değişebilen dinamik ekranımız için StatefulWidget yapısıdır
  final HabitModel? existingHabit; // HabitModel? türünden existingHabit adlı değişkenimiz
  final List<CategoryModel> categories; // List<CategoryModel> türünden categories adlı değişkenimiz
  final ValueChanged<HabitModel> onSave; // ValueChanged<HabitModel> türünden onSave adlı değişkenimiz
  final VoidCallback? onDelete; // VoidCallback? türünden onDelete adlı değişkenimiz
  final ValueChanged<CategoryModel>? onCategoryAdded; // ValueChanged<CategoryModel>? türünden onCategoryAdded adlı değişkenimiz

  const AddEditHabitModal({ // Genel, sabit sınıf constructor'ı
    super.key,
    this.existingHabit, // existingHabit alanına değer aktarıyoruz
    required this.categories, // categories parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.onSave, // onSave parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.onDelete, // onDelete alanına değer aktarıyoruz
    this.onCategoryAdded, // onCategoryAdded alanına değer aktarıyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  State<AddEditHabitModal> createState() => _AddEditHabitModalState();
}

class _AddEditHabitModalState extends State<AddEditHabitModal> { // Ekranın durumunu (state), mantığını ve değişkenlerini tuttuğumuz State sınıfımız
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController; // TextEditingController türünden _titleController adlı değişkenimiz
  late String _selectedCategoryId; // String türünden _selectedCategoryId adlı değişkenimiz
  late String _selectedIconName; // String türünden _selectedIconName adlı değişkenimiz
  late List<int> _selectedDays; // List<int> türünden _selectedDays adlı değişkenimiz
  late TimeOfDay _startTime; // TimeOfDay türünden _startTime adlı değişkenimiz
  late TimeOfDay _endTime; // TimeOfDay türünden _endTime adlı değişkenimiz
  late bool _hasReminder; // bool türünden _hasReminder adlı değişkenimiz
  late List<CategoryModel> _localCategories; // List<CategoryModel> türünden _localCategories adlı değişkenimiz

  bool _isNewCategoryOpen = false; // Durum kontrolü için tuttuğumuz bool bayrağımız (_isNewCategoryOpen)
  final TextEditingController _customCategoryController = TextEditingController(); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
  int _selectedColorIndex = 0; // int türünden _selectedColorIndex değişkenimiz

  final List<int> _customColorPalette = const [
    0xFF4EDEA3, // primary
    0xFFFFB95F, // secondary
    0xFFADC6FF, // tertiary
    0xFF34D399, // mood-good
    0xFFFB923C, // mood-bad
  ];

  // 10 Icons as specified in OTHER-DESIGN.md
  final List<Map<String, dynamic>> _iconSuggestions = const [
    {'name': 'Koşu', 'key': 'directions_run', 'icon': Icons.directions_run_rounded, 'color': AppColors.primary},
    {'name': 'Su', 'key': 'water_drop', 'icon': Icons.water_drop_rounded, 'color': AppColors.tertiary},
    {'name': 'Kitap', 'key': 'menu_book', 'icon': Icons.menu_book_rounded, 'color': AppColors.secondary},
    {'name': 'Müzik', 'key': 'music_note', 'icon': Icons.music_note_rounded, 'color': AppColors.moodNeutral},
    {'name': 'Zihin', 'key': 'self_improvement', 'icon': Icons.self_improvement_rounded, 'color': AppColors.primary},
    {'name': 'Besin', 'key': 'restaurant', 'icon': Icons.restaurant_rounded, 'color': AppColors.moodGood},
    {'name': 'Bisiklet', 'key': 'pedal_bike', 'icon': Icons.pedal_bike_rounded, 'color': AppColors.tertiaryContainer},
    {'name': 'Sanat', 'key': 'palette', 'icon': Icons.palette_rounded, 'color': AppColors.moodBad},
    {'name': 'Kod', 'key': 'code', 'icon': Icons.code_rounded, 'color': AppColors.primary},
    {'name': 'Uyku', 'key': 'bedtime', 'icon': Icons.bedtime_rounded, 'color': AppColors.tertiary},
  ];

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void initState() { // State ağaca ilk eklendiğinde çalışan metod, sayfa açılırkenki ilk hazırlıklar burda yapılır
    super.initState(); // Üst sınıfın initState metodunu tetikleyip başlatıyoruz
    final h = widget.existingHabit;
    _titleController = TextEditingController(text: h?.title ?? 'Sabah Koşusu ve Egzersiz'); // Metin kutusundaki (TextField) yazıyı okumak ve yönetmek için controller oluşturuyoruz
    _localCategories = List.from(widget.categories);
    _selectedCategoryId = h?.categoryId ?? (_localCategories.isNotEmpty ? _localCategories.first.id : 'sport');
    _selectedIconName = h != null ? _resolveIconKey(h.iconPath) : 'directions_run';
    _selectedDays = h != null ? List<int>.from(h.selectedDays) : [1, 3, 5]; // Pzt, Çar, Cum
    _startTime = const TimeOfDay(hour: 9, minute: 45);
    _endTime = const TimeOfDay(hour: 15, minute: 36);
    _hasReminder = h?.hasReminder ?? true;

    if (h != null && h.startTime.contains(':')) {
      final parts = h.startTime.split(':');
      _startTime = TimeOfDay(hour: int.tryParse(parts[0]) ?? 9, minute: int.tryParse(parts[1]) ?? 45);
    }
    if (h != null && h.endTime.contains(':')) {
      final parts = h.endTime.split(':');
      _endTime = TimeOfDay(hour: int.tryParse(parts[0]) ?? 15, minute: int.tryParse(parts[1]) ?? 36);
    }
  }

  String _resolveIconKey(String path) {
    if (path.contains('water')) return 'water_drop';
    if (path.contains('mind') || path.contains('book')) return 'menu_book';
    if (path.contains('music')) return 'music_note';
    if (path.contains('meditation')) return 'self_improvement';
    if (path.contains('health') || path.contains('apple')) return 'restaurant';
    if (path.contains('bike')) return 'pedal_bike';
    if (path.contains('palette') || path.contains('art')) return 'palette';
    if (path.contains('code')) return 'code';
    if (path.contains('sleep')) return 'bedtime';
    return 'directions_run';
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  void dispose() { // Ekran bellekten atılırken controller ve dinleyicileri kapatıp RAM sızıntısını önlüyoruz
    _titleController.dispose();
    _customCategoryController.dispose();
    super.dispose(); // Üst sınıfın dispose metodunu çağırıp temizliği tamamlıyoruz
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith( // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surfaceContainer,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveHabit() {
    if (!_formKey.currentState!.validate()) return;

    final startStr = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    final habit = HabitModel(
      id: widget.existingHabit?.id ?? 'habit_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      categoryId: _selectedCategoryId,
      iconPath: 'assets/icons/$_selectedIconName.svg',
      type: HabitType.checkmark,
      selectedDays: _selectedDays.isEmpty ? const [1, 2, 3, 4, 5, 6, 7] : _selectedDays,
      startTime: startStr,
      endTime: endStr,
      hasReminder: _hasReminder,
      currentProgress: widget.existingHabit?.currentProgress ?? 0.0,
      targetProgress: widget.existingHabit?.targetProgress ?? 1.0,
      unit: 'kez',
      streakDays: widget.existingHabit?.streakDays ?? 0,
      isCompleted: widget.existingHabit?.isCompleted ?? false,
      createdAt: widget.existingHabit?.createdAt ?? DateTime.now(),
    );

    widget.onSave(habit);
    Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
  }

  void _handleAddNewCategory() {
    final name = _customCategoryController.text.trim();
    if (name.isEmpty) return;

    final newCat = CategoryModel(
      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      iconPath: 'assets/icons/custom.svg',
      colorHex: _customColorPalette[_selectedColorIndex],
      isCustom: true,
    );

    setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
      _localCategories.add(newCat);
      _selectedCategoryId = newCat.id;
      _isNewCategoryOpen = false;
      _customCategoryController.clear();
    });

    widget.onCategoryAdded?.call(newCat);
  }

  IconData _getCategoryIcon(String catId) {
    switch (catId) {
      case 'sport':
        return Icons.directions_run_rounded;
      case 'health':
        return Icons.restaurant_rounded;
      case 'mind':
        return Icons.psychology_rounded;
      case 'music':
        return Icons.graphic_eq_rounded;
      default:
        return Icons.bookmark_rounded;
    }
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    final startStr = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      decoration: const BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea( // Çentik ve sistem çubuklarıyla arayüzün çakışmasını önleyen güvenli alan
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Top Action Bar
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      InkWell( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () => Navigator.of(context).pop(), // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
                        borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          ),
                          child: const Icon(Icons.close, color: AppColors.onSurface, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        widget.existingHabit == null ? 'Yeni Alışkanlık' : 'Alışkanlığı Düzenle',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          letterSpacing: -0.01,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0, // Kartın arkasına gölge veriyoruz (z koordinatı)
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    ),
                    onPressed: _saveHabit,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text(
                      'Kaydet',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Motivational Insight Hero Card
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: [
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: const [
                              Icon(Icons.bolt_rounded, color: AppColors.primary, size: 16),
                              SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Text(
                                'KÜÇÜK ADIMLAR',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          const Text(
                            'Rutinini inşa et, zinciri asla kırma.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          const Text(
                            'Günde 15 dakika bile 1 yılda devasa bir dönüşüm sağlar.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.surfaceContainerHigh,
                            AppColors.primary.withValues(alpha: 0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.hourglass_top_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 1: Habit Name Input
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                children: const [
                  Text(
                    'Alışkanlık Adı',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Text('*', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: TextFormField( // Kullanıcıdan metin girdisi almak için form alanı
                  controller: _titleController,
                  style: const TextStyle(fontSize: 14, color: AppColors.onSurface),
                  decoration: const InputDecoration(
                    hintText: 'Örn: Sabah Koşusu ve Egzersiz',
                    prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.outline, size: 22),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Lütfen bir alışkanlık adı girin';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 2: Icon Selection Library (10 Icons Grid)
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  const Text(
                    'İkon Seçimi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                      SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Text(
                        '10 Öneri',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: GridView.builder( // Elemanları ızgara (grid) düzeninde performanslı şekilde listelemek için kullanıyoruz
                  shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
                  physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: _iconSuggestions.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                  itemBuilder: (context, i) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                    final item = _iconSuggestions[i];
                    final isSelected = _selectedIconName == item['key'];
                    final iconColor = item['color'] as Color;

                    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                      onTap: () => setState(() => _selectedIconName = item['key'] as String), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color: isSelected ? AppColors.onPrimary : iconColor,
                              size: 22,
                            ),
                            const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Text(
                              item['name'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 3: Categories & Custom Category Trigger
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                    onTap: () => setState(() => _isNewCategoryOpen = !_isNewCategoryOpen), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                    child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                      children: const [
                        Icon(Icons.add_circle_outline, color: AppColors.primary, size: 16),
                        SizedBox(width: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                        Text(
                          'Yeni Kategori',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Categories 2-Column Grid
              GridView.builder( // Elemanları ızgara (grid) düzeninde performanslı şekilde listelemek için kullanıyoruz
                shrinkWrap: true, // Listenin sadece elemanları kadar yer kaplamasını sağlıyoruz, taşmasın diye
                physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırılmasını engelleyip dıştaki kaydırıcıya bırakıyoruz
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.7,
                ),
                itemCount: _localCategories.length, // Listede kaç tane eleman gösterileceğini belirtiyoruz
                itemBuilder: (context, idx) { // Listenin her bir satırını sırayla oluşturan builder fonksiyonumuz
                  final cat = _localCategories[idx];
                  final isSelected = _selectedCategoryId == cat.id;

                  return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                    onTap: () => setState(() => _selectedCategoryId = cat.id), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                    child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                        ),
                      ),
                      child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                        children: [
                          Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                            children: [
                              Icon(
                                _getCategoryIcon(cat.id),
                                size: 18,
                                color: isSelected ? AppColors.onPrimary : Color(cat.colorHex),
                              ),
                              const SizedBox(width: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            size: 18,
                            color: isSelected ? AppColors.onPrimary : AppColors.outline,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Expandable New Category Panel
              if (_isNewCategoryOpen) ...[
                const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                    crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                    children: [
                      Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                        children: [
                          const Text(
                            'Yeni Kategori Oluştur',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                            onTap: () => setState(() => _isNewCategoryOpen = false), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                            child: const Icon(Icons.close, size: 18, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      TextField( // Kullanıcıdan metin girdisi almak için form alanı
                        controller: _customCategoryController,
                        style: const TextStyle(fontSize: 13, color: AppColors.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Kategori Adı (Örn: Finans, Dil)',
                          fillColor: AppColors.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      const Text(
                        'Renk Teması:',
                        style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                        children: List.generate(_customColorPalette.length, (index) {
                          final colorVal = Color(_customColorPalette[index]);
                          final isChosen = _selectedColorIndex == index;
                          return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                            onTap: () => setState(() => _selectedColorIndex = index), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                            child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                              margin: const EdgeInsets.only(right: 8),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                                color: colorVal,
                                shape: BoxShape.circle,
                                border: isChosen ? Border.all(color: Colors.white, width: 2) : null,
                              ),
                              child: isChosen
                                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                                  : null,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton( // Kullanıcının tıklayabileceği aksiyon butonu bileşenimiz
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          ),
                          onPressed: _handleAddNewCategory,
                          child: const Text('Kategoriyi Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 4: Weekly Frequency Day Chips
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  const Text(
                    'Tekrar Günleri',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                    children: [
                      GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () => setState(() => _selectedDays = [1, 2, 3, 4, 5]), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          child: const Text(
                            'Hafta İçi',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                      GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                        onTap: () => setState(() => _selectedDays = [1, 2, 3, 4, 5, 6, 7]), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                        child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          child: const Text(
                            'Her Gün',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // 7 Days Responsive Grid
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                children: [
                  _buildDayChip(1, 'Pzt'),
                  _buildDayChip(2, 'Sal'),
                  _buildDayChip(3, 'Çar'),
                  _buildDayChip(4, 'Per'),
                  _buildDayChip(5, 'Cum'),
                  _buildDayChip(6, 'Cmt'),
                  _buildDayChip(7, 'Paz'),
                ],
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 5: Exact Time Interval Pickers
              const Text(
                'Zaman Aralığı',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
              Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                children: [
                  Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                    child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                      onTap: () => _pickTime(true),
                      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            const Text(
                              'Başlangıç Saati',
                              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                              children: [
                                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 18),
                                    const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Text(
                                      startStr,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.expand_more_rounded, color: AppColors.outline, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                  Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                    child: GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                      onTap: () => _pickTime(false),
                      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                          children: [
                            const Text(
                              'Bitiş Saati',
                              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                            Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
                              children: [
                                Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                                  children: [
                                    const Icon(Icons.update_rounded, color: AppColors.secondary, size: 18),
                                    const SizedBox(width: 6), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                                    Text(
                                      endStr,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.expand_more_rounded, color: AppColors.outline, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 6: Smart Notification Reminder Toggle
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row( // Çocuk widget'ları yatayda yan yana dizmek için Row açıyoruz
                  children: [
                    Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                    Expanded( // Row veya Column içinde kalan boşluğun tamamını kaplasın ve taşma patlaması olmasın diye Expanded veriyoruz
                      child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
                        crossAxisAlignment: CrossAxisAlignment.start, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
                        children: const [
                          Text(
                            'Hatırlatıcı Bildirim Gönder',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                          Text(
                            'Aralık başlangıcında ve 15 dk önce uyar',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Custom switch widget
                    GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
                      onTap: () => setState(() => _hasReminder = !_hasReminder), // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
                      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 28,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                          color: _hasReminder ? AppColors.primary : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: _hasReminder ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                              color: _hasReminder ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: _hasReminder
                                ? const Icon(Icons.check, size: 14, color: AppColors.primary)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz

              // Section 7: Form Submission & Bottom Actions
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                ),
                onPressed: _saveHabit,
                icon: const Icon(Icons.local_fire_department_rounded, size: 22),
                label: const Text(
                  'Alışkanlığı Kaydet (Zinciri Başlat)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),

              if (widget.existingHabit != null && widget.onDelete != null) ...[
                const SizedBox(height: 10), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
                  ),
                  onPressed: () async {
                    final confirmed = await ConfirmationDialog.show(
                      context: context,
                      title: 'Alışkanlığı Sil?',
                      message: '"${widget.existingHabit!.title}" alışkanlığını verilerden kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
                      confirmText: 'Evet, Sil',
                      confirmColor: AppColors.danger,
                      icon: Icons.delete_forever_rounded,
                      iconColor: AppColors.danger,
                      isDestructive: true,
                    );
                    if (confirmed && context.mounted) {
                      widget.onDelete?.call();
                      Navigator.of(context).pop(); // Açık olan sayfayı veya diyaloğu kapatıp bir önceki ekrana dönüyoruz
                    }
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text(
                    'Bu Alışkanlığı Sil',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const SizedBox(height: 16), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayChip(int dayIndex, String label) {
    final isSelected = _selectedDays.contains(dayIndex);
    return GestureDetector( // Tıklama efekti (ripple) vermek ve kullanıcının dokunuşunu yakalamak için sarmalıyoruz
      onTap: () {
        setState(() { // setState ile durumu güncelliyoruz ki Flutter build metodunu yeniden tetiklesin
          if (isSelected) {
            _selectedDays.remove(dayIndex);
          } else {
            _selectedDays.add(dayIndex);
            _selectedDays.sort();
          }
        });
      },
      child: AnimatedContainer( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 48,
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          mainAxisAlignment: MainAxisAlignment.center, // Çocukların ana eksendeki hizalamasını ayarlıyoruz
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            if (isSelected)
              const Icon(Icons.check_rounded, size: 12, color: AppColors.onPrimary)
            else
              Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
                width: 4,
                height: 4,
                decoration: const BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
                  color: AppColors.outlineVariant,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
