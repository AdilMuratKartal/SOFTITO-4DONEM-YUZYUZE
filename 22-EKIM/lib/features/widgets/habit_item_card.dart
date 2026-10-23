import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import 'streak_badge.dart';

class HabitItemCard extends StatelessWidget {
  final HabitModel habit;
  final String categoryName;
  final Color categoryColor;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const HabitItemCard({
    super.key,
    required this.habit,
    required this.categoryName,
    required this.categoryColor,
    required this.onToggle,
    required this.onDelete,
    this.onIncrement,
    this.onDecrement,
  });

  IconData _getIconData(String iconPath) {
    if (iconPath.contains('sport') || iconPath.contains('run')) {
      return Icons.directions_run_rounded;
    } else if (iconPath.contains('water') || iconPath.contains('su')) {
      return Icons.water_drop_rounded;
    } else if (iconPath.contains('book') || iconPath.contains('kitap') || iconPath.contains('mind')) {
      return Icons.menu_book_rounded;
    } else if (iconPath.contains('music') || iconPath.contains('muzik')) {
      return Icons.music_note_rounded;
    } else if (iconPath.contains('meditation') || iconPath.contains('self_improvement') || iconPath.contains('zihin')) {
      return Icons.self_improvement_rounded;
    } else if (iconPath.contains('apple') || iconPath.contains('besin') || iconPath.contains('restaurant')) {
      return Icons.restaurant_rounded;
    } else if (iconPath.contains('bike') || iconPath.contains('pedal_bike') || iconPath.contains('bisiklet')) {
      return Icons.pedal_bike_rounded;
    } else if (iconPath.contains('palette') || iconPath.contains('sanat') || iconPath.contains('art')) {
      return Icons.palette_rounded;
    } else if (iconPath.contains('code') || iconPath.contains('kod')) {
      return Icons.code_rounded;
    } else if (iconPath.contains('sleep') || iconPath.contains('uyku') || iconPath.contains('bedtime')) {
      return Icons.bedtime_rounded;
    }
    return Icons.star_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('habit_${habit.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
            title: const Text('Alışkanlığı Sil?'),
            content: Text(
              '"${habit.title}" alışkanlığını ve geçmiş serisini silmek istediğinize emin misiniz?',
              style: TextStyle(color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
            ),
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
      onDismissed: (_) => onDelete(),
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
        child: Material(
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: habit.isCompleted
                    ? AppColors.primary
                    : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                width: habit.isCompleted ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 38x38 Category Icon Box
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getIconData(habit.iconPath), color: categoryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    // Title & Time & Meta
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
                              color: habit.isCompleted
                                  ? (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary)
                                  : (isDark ? AppColors.onSurface : AppColors.textLight),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 13, color: AppColors.tertiary),
                              const SizedBox(width: 4),
                              Text(
                                '${habit.startTime} - ${habit.endTime}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.tertiary,
                                ),
                              ),
                              if (habit.hasReminder) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.notifications_active, size: 13, color: AppColors.secondary),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              StreakBadge(streakDays: habit.streakDays),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Counter or Checkmark Action
                    if (habit.type == HabitType.counter) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 22),
                            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                            onPressed: onDecrement,
                          ),
                          Text(
                            '${habit.currentProgress.toInt()} / ${habit.targetProgress.toInt()} ${habit.unit}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, size: 22),
                            color: AppColors.primary,
                            onPressed: onIncrement,
                          ),
                        ],
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onToggle();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: habit.isCompleted ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color: habit.isCompleted
                                  ? AppColors.primary
                                  : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                              width: 2,
                            ),
                          ),
                          child: habit.isCompleted
                              ? const Icon(Icons.check, color: AppColors.onPrimary, size: 20)
                              : null,
                        ),
                      ),
                    ],
                  ],
                ),
                if (habit.type == HabitType.counter) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (habit.currentProgress / habit.targetProgress).clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
