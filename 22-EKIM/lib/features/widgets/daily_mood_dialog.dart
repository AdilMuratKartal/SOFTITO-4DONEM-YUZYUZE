import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../models/mood_model.dart';

class DailyMoodDialog extends StatelessWidget {
  final String? initialMood;
  final ValueChanged<String> onMoodSelected;
  final VoidCallback onDismiss;

  const DailyMoodDialog({
    super.key,
    this.initialMood,
    required this.onMoodSelected,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    String? currentMood,
    required ValueChanged<String> onMoodSelected,
    required VoidCallback onDismiss,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DailyMoodDialog(
        initialMood: currentMood,
        onMoodSelected: (mood) {
          onMoodSelected(mood);
          Navigator.of(ctx).pop();
        },
        onDismiss: () {
          onDismiss();
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusModal)),
          border: Border.all(
            color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Modal tutma çubuğu (Drag handle)
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Başlık ve İkon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wb_sunny_rounded, color: AppColors.secondary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Bugün Nasıl Hissediyorsun?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.01,
                    color: isDark ? AppColors.onSurface : AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Günün ilk girişi! Modunu kaydet, enerjine göre alışkanlıklarını yönet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            // 5 Mood Seçenekleri - Responsive Expanded Satırı
            Row(
              children: MoodItem.allMoods.map((mood) {
                final isSelected = initialMood == mood.keyName;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onMoodSelected(mood.keyName);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mood.activeColor.withValues(alpha: 0.18)
                              : (isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          border: Border.all(
                            color: isSelected ? mood.activeColor : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(mood.emoji, style: const TextStyle(fontSize: 26)),
                            const SizedBox(height: 6),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                mood.label,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? mood.activeColor
                                      : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Geç / Daha Sonra Butonu (Tekrar sormasın)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onDismiss();
                },
                child: Text(
                  'Daha Sonra (Bugün Tekrar Sorma)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
