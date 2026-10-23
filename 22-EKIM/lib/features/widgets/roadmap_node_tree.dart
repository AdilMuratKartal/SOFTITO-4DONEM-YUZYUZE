import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart';
import '../models/habit_model.dart';
import '../controllers/roadmap_controller.dart';
import '../controllers/habit_controller.dart';

/// Dikey Aşama Basamakları Ağacı (Milestone Stepper Tree)
class RoadmapNodeTree extends StatelessWidget {
  final RoadmapModel roadmap;
  final RoadmapController roadmapController;
  final HabitController habitController;
  final void Function(RoadmapNodeModel node)? onNodeTap;

  const RoadmapNodeTree({
    super.key,
    required this.roadmap,
    required this.roadmapController,
    required this.habitController,
    this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ağaç Başlığı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.alt_route_rounded, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Aşama Basamakları',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
                  ),
                ],
              ),
              Text(
                'Sıralı İlerleme',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Basamak Düğümleri Listesi
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: roadmap.nodes.length,
          itemBuilder: (context, index) {
            final node = roadmap.nodes[index];
            final isLast = index == roadmap.nodes.length - 1;

            return _buildNodeItem(
              context: context,
              node: node,
              isLast: isLast,
              isDark: isDark,
            );
          },
        ),
      ],
    );
  }

  Widget _buildNodeItem({
    required BuildContext context,
    required RoadmapNodeModel node,
    required bool isLast,
    required bool isDark,
  }) {
    final isActive = !node.isCompleted && !node.isLocked;
    final isCompleted = node.isCompleted;
    final isLocked = node.isLocked;

    // Bağlı alışkanlıkları bul
    final allHabits = habitController.habitsNotifier.value;
    final linkedHabits = node.linkedHabitIds
        .map((id) => allHabits.firstWhere(
              (h) => h.id == id,
              orElse: () => HabitModel(
                id: id,
                title: 'Alışkanlık',
                categoryId: 'general',
                iconPath: 'assets/icons/run.svg',
                type: HabitType.checkmark,
                selectedDays: [1, 2, 3, 4, 5, 6, 7],
                startTime: '09:00',
                endTime: '10:00',
                currentProgress: 0,
                targetProgress: 1,
                streakDays: 0,
                isCompleted: false,
                createdAt: DateTime.now(),
              ),
            ))
        .toList();

    return Stack(
      children: [
        // Sol Dikey Bağlantı Çizgisi
        if (!isLast)
          Positioned(
            left: 15,
            top: 36,
            bottom: 0,
            child: Container(
              width: 2,
              color: isCompleted
                  ? AppColors.primary
                  : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
            ),
          ),

        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Düğüm Rozeti (Badge)
              _buildNodeBadge(isCompleted, isActive, isLocked, node.stepNumber, isDark),

              const SizedBox(width: 14),

              // Düğüm Kart İçeriği
              Expanded(
                child: _buildNodeCardContent(
                  context: context,
                  node: node,
                  linkedHabits: linkedHabits,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  isLocked: isLocked,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Sol Rozet (Badge) Çizimi
  Widget _buildNodeBadge(
    bool isCompleted,
    bool isActive,
    bool isLocked,
    int stepNumber,
    bool isDark,
  ) {
    if (isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.45),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.check, color: AppColors.onPrimary, size: 18),
      );
    }

    if (isActive) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainerHighest : AppColors.surfaceVariantLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$stepNumber',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    // Locked
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
        ),
      ),
      child: Icon(
        Icons.lock_rounded,
        size: 15,
        color: isDark ? AppColors.outline : AppColors.textSecondary,
      ),
    );
  }

  /// Düğüm Kartının İçeriği
  Widget _buildNodeCardContent({
    required BuildContext context,
    required RoadmapNodeModel node,
    required List<HabitModel> linkedHabits,
    required bool isActive,
    required bool isCompleted,
    required bool isLocked,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🔒 Bu aşama kilitli! Önce ${node.stepNumber - 1}. Basamağı tamamlamalısın.'),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          onNodeTap?.call(node);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        decoration: BoxDecoration(
          color: isLocked
              ? (isDark ? AppColors.surfaceContainerLow.withValues(alpha: 0.6) : AppColors.surfaceLight.withValues(alpha: 0.7))
              : (isActive
                  ? (isDark ? AppColors.surfaceContainer : AppColors.surfaceLight)
                  : (isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.5)
                : (isDark ? AppColors.outlineVariant.withValues(alpha: 0.4) : AppColors.borderLight),
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Başlık & Durum Rozetleri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isActive ? 'Basamak ${node.stepNumber} • Aktif Aşama' : 'Basamak ${node.stepNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? AppColors.primary
                        : (isCompleted
                            ? AppColors.primary
                            : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary)),
                  ),
                ),
                if (isCompleted) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department, size: 12, color: AppColors.secondary),
                            const SizedBox(width: 3),
                            Text(
                              '${node.targetDaysStreak} Gün Tamamlandı',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Tamamlandı',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ] else if (isActive) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, size: 12, color: AppColors.secondary),
                        const SizedBox(width: 3),
                        Text(
                          '5 / ${node.targetDaysStreak} Gün Zincir',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerHighest : AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_clock, size: 12, color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          'Kilitli',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 6),

            // Düğüm Başlığı & Açıklaması
            Text(
              node.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurface : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              node.description,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),

            // AKTİF DÜĞÜM ÖZEL İÇERİĞİ
            if (isActive) ...[
              const SizedBox(height: 12),

              // Aşama İlerleme Çubuğu
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aşama İlerlemesi',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                        ),
                      ),
                      const Text(
                        '%35',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.35,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // BAĞLI GÜNLÜK ALIŞKANLIKLAR LİSTESİ
              if (linkedHabits.isNotEmpty) ...[
                Text(
                  'BAĞLI GÜNLÜK ALIŞKANLIKLAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                ...linkedHabits.map((habit) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.directions_run_rounded, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                                  color: habit.isCompleted
                                      ? (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary)
                                      : (isDark ? AppColors.onSurface : AppColors.textLight),
                                ),
                              ),
                              Text(
                                habit.isCompleted
                                    ? 'Bugün Tamamlandı ✓'
                                    : '${habit.startTime} - ${habit.endTime} • Bugün Bekliyor',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: habit.isCompleted ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          icon: Icon(
                            habit.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: habit.isCompleted ? AppColors.primary : AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            roadmapController.toggleLinkedHabit(habit.id);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],

              const SizedBox(height: 6),

              // Basamak Aksiyon Butonu
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => onNodeTap?.call(node),
                  icon: const Icon(Icons.format_list_bulleted_rounded, size: 16, color: AppColors.primary),
                  label: const Text(
                    'Basamak Detayları & Alışkanlıklar',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.onSurface : AppColors.textLight,
                    side: BorderSide(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ] else if (isCompleted) ...[
              // TAMAMLANMIŞ DÜĞÜM ETİKETLERİ
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: linkedHabits.map((h) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('💧 ${h.title}', style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all_rounded, size: 13, color: AppColors.primary),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ] else if (isLocked) ...[
              // KİLİTLİ DÜĞÜM UYARI KUTUSU
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceContainerHighest.withValues(alpha: 0.5)
                      : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${node.stepNumber - 1}. Basamak tamamlandığında açılacak (${node.targetDaysStreak} Günlük seri gerekli).',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
