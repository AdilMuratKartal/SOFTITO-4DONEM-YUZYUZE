import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import 'streak_badge.dart';
import 'confirmation_dialog.dart';

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

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
    bool isPrimary = false,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDark ? AppColors.surfaceContainerLowest : AppColors.surfaceVariantLight)
              : (isPrimary
                  ? AppColors.primary
                  : (isDark ? AppColors.surfaceContainerHighest : AppColors.surfaceLight)),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: isPrimary
                ? AppColors.primary
                : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled
              ? (isDark ? AppColors.outline : AppColors.borderDark)
              : (isPrimary ? AppColors.onPrimary : (isDark ? AppColors.onSurface : AppColors.textLight)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('habit_${habit.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await ConfirmationDialog.show(
          context: context,
          title: 'Alışkanlığı Sil?',
          message: '"${habit.title}" alışkanlığını ve geçmiş serisini kalıcı olarak silmek istediğinize emin misiniz?',
          confirmText: 'Evet, Sil',
          confirmColor: AppColors.danger,
          icon: Icons.delete_forever_rounded,
          iconColor: AppColors.danger,
          isDestructive: true,
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
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
        margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
        child: Material(
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
              border: Border.all(
                color: habit.isCompleted
                    ? AppColors.primary
                    : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                width: habit.isCompleted ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Üst Satır: İkon + Başlık/Detaylar (Geniş Alan) + Aksiyon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 38x38 Kategori İkon Kutusu
                    Container(
                      width: AppSizes.iconBoxMd,
                      height: AppSizes.iconBoxMd,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Icon(_getIconData(habit.iconPath), color: categoryColor, size: AppSizes.iconMd),
                    ),
                    const SizedBox(width: AppSizes.spaceMd),
                    // Başlık, Zaman ve Meta Bilgileri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                              Flexible(
                                child: Text(
                                  '${habit.startTime} - ${habit.endTime}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.tertiary,
                                  ),
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
                              Flexible(
                                child: Text(
                                  categoryName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              StreakBadge(streakDays: habit.streakDays),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSm),
                    // Onaylama Aksiyonu (Sadece Checkmark için üst satırda)
                    if (habit.type == HabitType.checkmark)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onToggle();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: AppSizes.iconBoxMd,
                          height: AppSizes.iconBoxMd,
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
                      )
                    else if (habit.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                            SizedBox(width: 3),
                            Text(
                              'Tamam',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Sayaçlı Alışkanlıklar için Alt Kontrol ve İlerleme Barı
                if (habit.type == HabitType.counter) ...[
                  const SizedBox(height: AppSizes.spaceMd),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${habit.currentProgress.toInt()} / ${habit.targetProgress.toInt()} ${habit.unit}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.onSurface : AppColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStepperButton(
                              icon: Icons.remove,
                              onTap: onDecrement,
                              isDark: isDark,
                              isDisabled: habit.currentProgress <= 0,
                            ),
                            const SizedBox(width: 8),
                            _buildStepperButton(
                              icon: Icons.add,
                              onTap: onIncrement,
                              isDark: isDark,
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceSm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.progressBarRadius),
                    child: LinearProgressIndicator(
                      value: (habit.currentProgress / habit.targetProgress).clamp(0.0, 1.0),
                      minHeight: AppSizes.progressBarHeight,
                      backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        habit.isCompleted ? AppColors.primaryContainer : AppColors.primary,
                      ),
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
