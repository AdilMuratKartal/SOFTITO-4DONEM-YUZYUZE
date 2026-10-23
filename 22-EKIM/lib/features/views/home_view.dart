import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/habit_controller.dart';
import '../controllers/mood_controller.dart';
import '../models/habit_model.dart';
import '../models/category_model.dart';
import '../widgets/mood_selector_widget.dart';
import '../widgets/daily_calendar_strip.dart';
import '../widgets/habit_item_card.dart';
import 'add_edit_habit_view.dart';

class HomeView extends StatefulWidget {
  final HabitController habitController;
  final MoodController moodController;

  const HomeView({
    super.key,
    required this.habitController,
    required this.moodController,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HabitController get _habitController => widget.habitController;
  MoodController get _moodController => widget.moodController;

  void _openAddHabitModal([HabitModel? habitToEdit]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditHabitModal(
        existingHabit: habitToEdit,
        categories: _habitController.categoriesNotifier.value,
        onSave: (habit) {
          if (habitToEdit == null) {
            _habitController.addHabit(habit);
          } else {
            _habitController.deleteHabit(habitToEdit.id);
            _habitController.addHabit(habit);
          }
        },
        onDelete: habitToEdit != null ? () => _habitController.deleteHabit(habitToEdit.id) : null,
        onCategoryAdded: (cat) => _habitController.addCategory(cat),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final catController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: const Text('Yeni Kategori Ekle', style: TextStyle(color: AppColors.onSurface)),
        content: TextField(
          controller: catController,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: const InputDecoration(
            hintText: 'Kategori Adı (Örn: Sanat, Dil...)',
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () {
              final name = catController.text.trim();
              if (name.isNotEmpty) {
                final newCat = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  iconPath: 'assets/icons/custom.svg',
                  colorHex: 0xFF4EDEA3,
                  isCustom: true,
                );
                _habitController.addCategory(newCat);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(isDark),
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
              _buildCategoryFilterBar(isDark),
              const SizedBox(height: 16),
              _buildProgressOverview(isDark),
              const SizedBox(height: 16),
              _buildHabitsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openAddHabitModal(),
        child: const Icon(Icons.add, color: AppColors.onPrimary, size: 28),
      ),
    );
  }

  Widget _buildTopHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bugün, 24 Ekim',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Harika Bir Gün!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurface : AppColors.textLight,
                letterSpacing: -0.01,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
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
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Lv. 3',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilterBar(bool isDark) {
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
                  _buildCustomChip(
                    label: 'Tümü',
                    isSelected: selectedId == 'all',
                    activeColor: AppColors.primary,
                    onTap: () => _habitController.filterByCategory('all'),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((cat) {
                    final isSelected = selectedId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildCustomChip(
                        label: cat.name,
                        isSelected: isSelected,
                        activeColor: Color(cat.colorHex),
                        onTap: () => _habitController.filterByCategory(cat.id),
                        isDark: isDark,
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: _showAddCategoryDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 16, color: isDark ? AppColors.onSurface : AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            'Kategori',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCustomChip({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? AppColors.surfaceContainer : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.onPrimary
                : (isDark ? AppColors.onSurface : AppColors.textLight),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(bool isDark) {
    return ValueListenableBuilder<List<HabitModel>>(
      valueListenable: _habitController.habitsNotifier,
      builder: (context, habits, _) {
        if (habits.isEmpty) return const SizedBox.shrink();
        final completed = habits.where((h) => h.isCompleted).length;
        final ratio = habits.isEmpty ? 0.0 : completed / habits.length;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Günün İlerlemesi: $completed / ${habits.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
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
                  backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
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
      builder: (context, allHabits, _) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: _habitController.selectedDateNotifier,
          builder: (context, selectedDate, _) {
            return ValueListenableBuilder<String>(
              valueListenable: _habitController.selectedCategoryNotifier,
              builder: (context, selectedCategory, _) {
                final dayOfWeek = selectedDate.weekday; // 1: Pazartesi ... 7: Pazar

                // Gün ve Kategoriye göre filtrele
                final habits = allHabits.where((h) {
                  final matchesDay = h.selectedDays.contains(dayOfWeek);
                  final matchesCategory = selectedCategory == 'all' || h.categoryId == selectedCategory;
                  return matchesDay && matchesCategory;
                }).toList();

                if (habits.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.checklist_rtl_rounded, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 10),
                          const Text(
                            'Bu gün veya kategoride alışkanlık yok.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Yeni Alışkanlık Ekle'),
                            onPressed: () => _openAddHabitModal(),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    final cat = _habitController.categoriesNotifier.value.firstWhere(
                      (c) => c.id == habit.categoryId,
                      orElse: () => const CategoryModel(
                        id: 'unknown',
                        name: 'Genel',
                        iconPath: '',
                        colorHex: 0xFF4EDEA3,
                      ),
                    );

                    return GestureDetector(
                      onTap: () => _openAddHabitModal(habit),
                      child: HabitItemCard(
                        habit: habit,
                        categoryName: cat.name,
                        categoryColor: Color(cat.colorHex),
                        onToggle: () => _habitController.toggleHabit(habit.id),
                        onDelete: () => _habitController.deleteHabit(habit.id),
                        onIncrement: () => _habitController.incrementProgress(habit.id, 250),
                        onDecrement: () => _habitController.decrementProgress(habit.id, 250),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
