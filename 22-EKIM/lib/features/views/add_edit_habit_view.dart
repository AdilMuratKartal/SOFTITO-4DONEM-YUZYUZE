import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import '../models/category_model.dart';

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
  late String _selectedIconPath;
  late List<int> _selectedDays;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _hasReminder;
  late List<CategoryModel> _localCategories;

  final List<Map<String, dynamic>> _availableIcons = [
    {'path': 'assets/icons/sport.svg', 'name': 'Koşu / Spor', 'icon': Icons.directions_run_rounded},
    {'path': 'assets/icons/health.svg', 'name': 'Su / Sağlık', 'icon': Icons.water_drop_rounded},
    {'path': 'assets/icons/mind.svg', 'name': 'Kitap / Zihin', 'icon': Icons.menu_book_rounded},
    {'path': 'assets/icons/music.svg', 'name': 'Müzik / Sanat', 'icon': Icons.music_note_rounded},
    {'path': 'assets/icons/meditation.svg', 'name': 'Meditasyon', 'icon': Icons.self_improvement_rounded},
    {'path': 'assets/icons/apple.svg', 'name': 'Beslenme', 'icon': Icons.restaurant_rounded},
    {'path': 'assets/icons/bike.svg', 'name': 'Bisiklet', 'icon': Icons.directions_bike_rounded},
    {'path': 'assets/icons/sleep.svg', 'name': 'Uyku', 'icon': Icons.bedtime_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final h = widget.existingHabit;
    _titleController = TextEditingController(text: h?.title ?? '');
    _localCategories = List.from(widget.categories);
    _selectedCategoryId = h?.categoryId ?? (_localCategories.isNotEmpty ? _localCategories.first.id : 'sport');
    _selectedIconPath = h?.iconPath ?? _availableIcons.first['path'] as String;
    _selectedDays = h != null ? List<int>.from(h.selectedDays) : [1, 2, 3, 4, 5];
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
          decoration: const InputDecoration(
            hintText: 'Kategori Adı (Örn: Yazılım, Dil...)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              final name = catController.text.trim();
              if (name.isNotEmpty) {
                final newCat = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  iconPath: 'assets/icons/custom.svg',
                  colorHex: 0xFFF59E0B, // Amber
                  isCustom: true,
                );
                setState(() {
                  _localCategories.add(newCat);
                  _selectedCategoryId = newCat.id;
                });
                widget.onCategoryAdded?.call(newCat);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Ekle', style: TextStyle(color: Colors.white)),
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

    String formatTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final habit = HabitModel(
      id: widget.existingHabit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      categoryId: _selectedCategoryId,
      iconPath: _selectedIconPath,
      type: widget.existingHabit?.type ?? HabitType.checkmark,
      selectedDays: _selectedDays,
      startTime: formatTime(_startTime),
      endTime: formatTime(_endTime),
      hasReminder: _hasReminder,
      currentProgress: widget.existingHabit?.currentProgress ?? 0.0,
      targetProgress: widget.existingHabit?.targetProgress ?? 1.0,
      unit: widget.existingHabit?.unit ?? 'kez',
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Üst Kapat ve Kaydet Çubuğu
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

              // Alışkanlık İsmi
              const Text('Alışkanlık İsmi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Sabah Koşusu, 5 Sayfa Oku...',
                ),
                validator: (val) =>
                    (val == null || val.trim().length < 3) ? 'En az 3 karakter giriniz' : null,
              ),
              const SizedBox(height: 16),

              // İkon Seçimi (icons/ havuzu)
              const Text('İkon Seçimi (icons/)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final item = _availableIcons[index];
                    final isSelected = _selectedIconPath == item['path'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIconPath = item['path'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        width: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Kategori Seçimi (4 Temel + Dinamik Özel)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  TextButton.icon(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                    label: const Text('Kategori Ekle', style: TextStyle(color: AppColors.primary)),
                    onPressed: _showAddCategoryDialog,
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _localCategories.map((cat) {
                    final isSel = _selectedCategoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: isSel,
                        selectedColor: Color(cat.colorHex).withValues(alpha: 0.2),
                        onSelected: (_) => setState(() => _selectedCategoryId = cat.id),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Haftalık Tekrar Günleri (Pzt..Paz)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Haftalık Tekrar Günleri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(
                    '${_selectedDays.length} gün seçildi',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderLight,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
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

              // Zaman Aralığı (Başlangıç ve Bitiş Saati)
              const Text('Zaman Aralığı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time, size: 18, color: AppColors.info),
                      label: Text('Başlangıç: ${_startTime.format(context)}'),
                      onPressed: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time_filled, size: 18, color: AppColors.info),
                      label: Text('Bitiş: ${_endTime.format(context)}'),
                      onPressed: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hatırlatıcı Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: const Text('Başlangıçta Hatırlatıcı Gönder', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Saat geldiğinde telefonuna bildirim al', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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
                    widget.existingHabit == null ? 'Alışkanlığı Oluştur' : 'Değişiklikleri Kaydet',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Silme Butonu (Düzenleme anında)
              if (widget.existingHabit != null && widget.onDelete != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('Bu Alışkanlığı Kalıcı Olarak Sil', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Alışkanlığı Sil?'),
                          content: const Text('Bu işlem geri alınamaz. Alışkanlığa ait tüm seriler silinecektir.'),
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
                        navigator.pop();
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
