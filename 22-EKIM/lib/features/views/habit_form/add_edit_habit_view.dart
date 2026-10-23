import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../models/habit_model.dart';
import '../../models/category_model.dart';
import '../../widgets/confirmation_dialog.dart';

class AddEditHabitModal extends StatefulWidget {
  final HabitModel? existingHabit;
  final List<CategoryModel> categories;
  final ValueChanged<HabitModel> onSave;
  final VoidCallback? onDelete;
  final ValueChanged<CategoryModel>? onCategoryAdded;

  const AddEditHabitModal({
    super.key,
    this.existingHabit,
    required this.categories,
    required this.onSave,
    this.onDelete,
    this.onCategoryAdded,
  });

  @override
  State<AddEditHabitModal> createState() => _AddEditHabitModalState();
}

class _AddEditHabitModalState extends State<AddEditHabitModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late String _selectedCategoryId;
  late String _selectedIconName;
  late List<int> _selectedDays;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _hasReminder;
  late List<CategoryModel> _localCategories;

  bool _isNewCategoryOpen = false;
  final TextEditingController _customCategoryController = TextEditingController();
  int _selectedColorIndex = 0;

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

  @override
  void initState() {
    super.initState();
    final h = widget.existingHabit;
    _titleController = TextEditingController(text: h?.title ?? 'Sabah Koşusu ve Egzersiz');
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

  @override
  void dispose() {
    _titleController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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
      setState(() {
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
    Navigator.of(context).pop();
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

    setState(() {
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

  @override
  Widget build(BuildContext context) {
    final startStr = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Top Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.close, color: AppColors.onSurface, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              const SizedBox(height: 16),

              // Motivational Insight Hero Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.bolt_rounded, color: AppColors.primary, size: 16),
                              SizedBox(width: 4),
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
                          const SizedBox(height: 4),
                          const Text(
                            'Rutinini inşa et, zinciri asla kırma.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
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
                    const SizedBox(width: 12),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(14),
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
              const SizedBox(height: 20),

              // Section 1: Habit Name Input
              Row(
                children: const [
                  Text(
                    'Alışkanlık Adı',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text('*', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: TextFormField(
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
              const SizedBox(height: 20),

              // Section 2: Icon Selection Library (10 Icons Grid)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'İkon Seçimi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
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
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: _iconSuggestions.length,
                  itemBuilder: (context, i) {
                    final item = _iconSuggestions[i];
                    final isSelected = _selectedIconName == item['key'];
                    final iconColor = item['color'] as Color;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedIconName = item['key'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color: isSelected ? AppColors.onPrimary : iconColor,
                              size: 22,
                            ),
                            const SizedBox(height: 4),
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
              const SizedBox(height: 20),

              // Section 3: Categories & Custom Category Trigger
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isNewCategoryOpen = !_isNewCategoryOpen),
                    child: Row(
                      children: const [
                        Icon(Icons.add_circle_outline, color: AppColors.primary, size: 16),
                        SizedBox(width: 4),
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
              const SizedBox(height: 8),

              // Categories 2-Column Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.7,
                ),
                itemCount: _localCategories.length,
                itemBuilder: (context, idx) {
                  final cat = _localCategories[idx];
                  final isSelected = _selectedCategoryId == cat.id;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryId = cat.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getCategoryIcon(cat.id),
                                size: 18,
                                color: isSelected ? AppColors.onPrimary : Color(cat.colorHex),
                              ),
                              const SizedBox(width: 8),
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Yeni Kategori Oluştur',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _isNewCategoryOpen = false),
                            child: const Icon(Icons.close, size: 18, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customCategoryController,
                        style: const TextStyle(fontSize: 13, color: AppColors.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Kategori Adı (Örn: Finans, Dil)',
                          fillColor: AppColors.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Renk Teması:',
                        style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(_customColorPalette.length, (index) {
                          final colorVal = Color(_customColorPalette[index]);
                          final isChosen = _selectedColorIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColorIndex = index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _handleAddNewCategory,
                          child: const Text('Kategoriyi Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Section 4: Weekly Frequency Day Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tekrar Günleri',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedDays = [1, 2, 3, 4, 5]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          child: const Text(
                            'Hafta İçi',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => setState(() => _selectedDays = [1, 2, 3, 4, 5, 6, 7]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 8),

              // 7 Days Responsive Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const SizedBox(height: 20),

              // Section 5: Exact Time Interval Pickers
              const Text(
                'Zaman Aralığı',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Başlangıç Saati',
                              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 18),
                                    const SizedBox(width: 6),
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bitiş Saati',
                              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.update_rounded, color: AppColors.secondary, size: 18),
                                    const SizedBox(width: 6),
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
              const SizedBox(height: 20),

              // Section 6: Smart Notification Reminder Toggle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hatırlatıcı Bildirim Gönder',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2),
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
                    GestureDetector(
                      onTap: () => setState(() => _hasReminder = !_hasReminder),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 28,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _hasReminder ? AppColors.primary : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: _hasReminder ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
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
              const SizedBox(height: 24),

              // Section 7: Form Submission & Bottom Actions
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _saveHabit,
                icon: const Icon(Icons.local_fire_department_rounded, size: 22),
                label: const Text(
                  'Alışkanlığı Kaydet (Zinciri Başlat)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),

              if (widget.existingHabit != null && widget.onDelete != null) ...[
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text(
                    'Bu Alışkanlığı Sil',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayChip(int dayIndex, String label) {
    final isSelected = _selectedDays.contains(dayIndex);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(dayIndex);
          } else {
            _selectedDays.add(dayIndex);
            _selectedDays.sort();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            if (isSelected)
              const Icon(Icons.check_rounded, size: 12, color: AppColors.onPrimary)
            else
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
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
