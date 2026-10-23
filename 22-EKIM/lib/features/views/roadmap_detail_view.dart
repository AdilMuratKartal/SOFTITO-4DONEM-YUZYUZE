import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart';
import '../controllers/roadmap_controller.dart';
import '../controllers/habit_controller.dart';
import '../widgets/roadmap_node_tree.dart';
import '../widgets/confirmation_dialog.dart';

/// Yol Haritası Detay Ekranı (Düğüm Ağacı ve Görevler)
class RoadmapDetailView extends StatelessWidget {
  final RoadmapModel roadmap;
  final RoadmapController roadmapController;
  final HabitController habitController;

  const RoadmapDetailView({
    super.key,
    required this.roadmap,
    required this.roadmapController,
    required this.habitController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<RoadmapModel>>(
      valueListenable: roadmapController.roadmapsNotifier,
      builder: (context, roadmaps, _) {
        final currentRoadmap = roadmaps.firstWhere(
          (r) => r.id == roadmap.id,
          orElse: () => roadmap,
        );

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(currentRoadmap.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                tooltip: 'Yol Haritasını Sil',
                onPressed: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context: context,
                    title: 'Yol Haritasını Sil?',
                    message: '"${currentRoadmap.title}" yol haritasını silmek istediğinize emin misiniz?',
                    confirmText: 'Evet, Sil',
                    confirmColor: AppColors.danger,
                    isDestructive: true,
                  );
                  if (confirmed && context.mounted) {
                    roadmapController.deleteRoadmap(currentRoadmap.id);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detay Başlık Özeti
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceLg),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.outlineVariant.withValues(alpha: 0.5) : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(currentRoadmap.iconName, style: const TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentRoadmap.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${currentRoadmap.category} • ${currentRoadmap.durationWeeks}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // İlerleme Barı
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${currentRoadmap.completedNodesCount} / ${currentRoadmap.nodes.length} Aşama Tamamlandı',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                            Text(
                              '%${currentRoadmap.progressPercentage.toInt()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: currentRoadmap.progressRatio,
                            minHeight: 8,
                            backgroundColor: isDark ? AppColors.surfaceContainerHighest : AppColors.borderLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Düğüm Ağacı
                  RoadmapNodeTree(
                    roadmap: currentRoadmap,
                    roadmapController: roadmapController,
                    habitController: habitController,
                    onNodeTap: (node) {
                      _showNodeDetailsModal(context, currentRoadmap, node, isDark);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNodeDetailsModal(
    BuildContext context,
    RoadmapModel roadmap,
    RoadmapNodeModel node,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Basamak ${node.stepNumber}: ${node.title}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              node.description,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gereken Seri Hedefi: ${node.targetDaysStreak} Gün',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (!node.isCompleted && !node.isLocked)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    roadmapController.completeNodeManually(roadmap.id, node.id);
                    Navigator.of(ctx).pop();
                  },
                  icon: const Icon(Icons.check_circle_rounded, color: AppColors.onPrimary),
                  label: const Text('Bu Aşamayı Tamamlandı Olarak İşaretle', style: TextStyle(color: AppColors.onPrimary)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
