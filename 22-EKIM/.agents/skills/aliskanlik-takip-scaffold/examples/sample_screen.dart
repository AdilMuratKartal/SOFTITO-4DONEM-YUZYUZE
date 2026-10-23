import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==============================================================================
// 1. TEMA VE RENK PALETİ (THEME STANDARTS)
// ==============================================================================
class AppColors {
  static const Color primary = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF34D399);
  static const Color secondary = Color(0xFFF97316);
  static const Color info = Color(0xFF0EA5E9);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF0F172A);
  static const Color textDark = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  // 4 Temel Kategori
  static const Color categorySport = Color(0xFF10B981);
  static const Color categoryHealth = Color(0xFF0EA5E9);
  static const Color categoryMind = Color(0xFF8B5CF6);
  static const Color categoryMusic = Color(0xFFEC4899);

  // Aksiyon ve Silme
  static const Color danger = Color(0xFFEF4444);
}

// ==============================================================================
// 2. VERİ MODELLERİ (DATA MODELS)
// ==============================================================================
class CategoryModel {
  final String id;
  final String name;
  final String iconPath;
  final int colorHex;
  final bool isCustom;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.colorHex,
    this.isCustom = false,
  });

  static const List<CategoryModel> defaultCategories = [
    CategoryModel(id: 'sport', name: 'Spor', iconPath: 'assets/icons/sport.svg', colorHex: 0xFF10B981),
    CategoryModel(id: 'health', name: 'Sağlık', iconPath: 'assets/icons/health.svg', colorHex: 0xFF0EA5E9),
    CategoryModel(id: 'mind', name: 'Zihin', iconPath: 'assets/icons/mind.svg', colorHex: 0xFF8B5CF6),
    CategoryModel(id: 'music', name: 'Müzik', iconPath: 'assets/icons/music.svg', colorHex: 0xFFEC4899),
  ];
}

class HabitModel {
  final String id;
  final String title;
  final String categoryId;
  final String iconPath;
  final List<int> selectedDays; // [1..7]
  final String startTime;       // Örn: '09:45'
  final String endTime;         // Örn: '15:36'
  final bool hasReminder;
  final bool isCompleted;
  final int streakDays;
  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.iconPath,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    required this.startTime,
    required this.endTime,
    this.hasReminder = false,
    this.isCompleted = false,
    this.streakDays = 0,
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
    bool? isCompleted,
    int? streakDays,
  }) {
    return HabitModel(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      iconPath: iconPath ?? this.iconPath,
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hasReminder: hasReminder ?? this.hasReminder,
      isCompleted: isCompleted ?? this.isCompleted,
      streakDays: streakDays ?? this.streakDays,
      createdAt: createdAt,
    );
  }
}

// ==============================================================================
// 3. CONTROLLER (STATE ARCHITECTURE - VALUENOTIFIER)
// ==============================================================================
class HabitController {
  final ValueNotifier<List<HabitModel>> habitsNotifier = ValueNotifier<List<HabitModel>>([]);
  final ValueNotifier<List<CategoryModel>> categoriesNotifier =
      ValueNotifier<List<CategoryModel>>(List.from(CategoryModel.defaultCategories));
  final ValueNotifier<String> selectedCategoryNotifier = ValueNotifier<String>('all');

  void loadInitialData() {
    habitsNotifier.value = [
      HabitModel(
        id: '1',
        title: 'Sabah Koşusu ve Esneme',
        categoryId: 'sport',
        iconPath: 'assets/icons/sport.svg',
        selectedDays: [1, 2, 3, 4, 5],
        startTime: '09:45',
        endTime: '15:36',
        hasReminder: true,
        isCompleted: true,
        streakDays: 7,
        createdAt: DateTime.now(),
      ),
      HabitModel(
        id: '2',
        title: 'Gitar Pratiği (Akorlar)',
        categoryId: 'music',
        iconPath: 'assets/icons/music.svg',
        selectedDays: [1, 3, 5, 7],
        startTime: '18:30',
        endTime: '19:15',
        hasReminder: true,
        isCompleted: false,
        streakDays: 3,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void addHabit(HabitModel habit) {
    habitsNotifier.value = [...habitsNotifier.value, habit];
  }

  void deleteHabit(String id) {
    habitsNotifier.value = habitsNotifier.value.where((h) => h.id != id).toList();
  }

  void toggleHabit(String id) {
    HapticFeedback.lightImpact();
    habitsNotifier.value = habitsNotifier.value.map((h) {
      if (h.id == id) {
        final newCompleted = !h.isCompleted;
        final newStreak = newCompleted ? h.streakDays + 1 : (h.streakDays > 0 ? h.streakDays - 1 : 0);
        return h.copyWith(isCompleted: newCompleted, streakDays: newStreak);
      }
      return h;
    }).toList();
  }

  void addCategory(CategoryModel category) {
    categoriesNotifier.value = [...categoriesNotifier.value, category];
    selectedCategoryNotifier.value = category.id;
  }

  void filterByCategory(String categoryId) {
    selectedCategoryNotifier.value = categoryId;
  }

  void dispose() {
    habitsNotifier.dispose();
    categoriesNotifier.dispose();
    selectedCategoryNotifier.dispose();
  }
}

// ==============================================================================
// 4. ALTIN STANDART REFERANS EKRAN (SAMPLE SCREEN VIEW)
// ==============================================================================
class SampleScreenView extends StatefulWidget {
  const SampleScreenView({super.key});

  @override
  State<SampleScreenView> createState() => _SampleScreenViewState();
}

class _SampleScreenViewState extends State<SampleScreenView> {
  late final HabitController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HabitController();
    _controller.loadInitialData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Kategori Ekle'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Kategori Adı (Örn: Yazılım)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                final newCat = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: textController.text.trim(),
                  iconPath: 'assets/icons/custom.svg',
                  colorHex: 0xFFF59E0B,
                  isCustom: true,
                );
                _controller.addCategory(newCat);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Ekle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Alışkanlıklarım', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            tooltip: 'Yeni Kategori Ekle',
            onPressed: _showAddCategoryDialog,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Kategori Çip Şeridi
            _buildCategoryChips(),
            const SizedBox(height: 12),
            // Alışkanlık Listesi (Dismissible Swipe-to-Delete destekli)
            Expanded(child: _buildHabitsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return ValueListenableBuilder<List<CategoryModel>>(
      valueListenable: _controller.categoriesNotifier,
      builder: (context, categories, _) {
        return ValueListenableBuilder<String>(
          valueListenable: _controller.selectedCategoryNotifier,
          builder: (context, selectedId, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Tümü'),
                    selected: selectedId == 'all',
                    onSelected: (_) => _controller.filterByCategory('all'),
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((cat) {
                    final isSelected = selectedId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        selectedColor: Color(cat.colorHex).withValues(alpha: 0.2),
                        onSelected: (_) => _controller.filterByCategory(cat.id),
                      ),
                    );
                  }),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('Kategori'),
                    onPressed: _showAddCategoryDialog,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHabitsList() {
    return ValueListenableBuilder<List<HabitModel>>(
      valueListenable: _controller.habitsNotifier,
      builder: (context, allHabits, _) {
        return ValueListenableBuilder<String>(
          valueListenable: _controller.selectedCategoryNotifier,
          builder: (context, selectedCategory, _) {
            final habits = selectedCategory == 'all'
                ? allHabits
                : allHabits.where((h) => h.categoryId == selectedCategory).toList();

            if (habits.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist_rtl_rounded, size: 54, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    const Text('Bu kategoride henüz alışkanlık yok.', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Dismissible(
                  key: Key(habit.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Alışkanlığı Sil?'),
                        content: Text('"${habit.title}" silinecektir. Emin misiniz?'),
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
                  },
                  onDismissed: (_) => _controller.deleteHabit(habit.id),
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
                        Icon(Icons.delete_outline, color: Colors.white, size: 24),
                        SizedBox(width: 6),
                        Text('Sil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: habit.isCompleted ? AppColors.primary : AppColors.borderLight,
                        width: habit.isCompleted ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.schedule, size: 13, color: AppColors.info),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${habit.startTime} - ${habit.endTime}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.info),
                                  ),
                                  if (habit.hasReminder) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.notifications_active, size: 13, color: AppColors.secondary),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            habit.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: habit.isCompleted ? AppColors.primary : AppColors.textSecondary,
                            size: 28,
                          ),
                          onPressed: () => _controller.toggleHabit(habit.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
