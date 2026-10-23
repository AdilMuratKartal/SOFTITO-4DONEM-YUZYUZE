import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/roadmap_controller.dart';
import '../models/roadmap_model.dart';

class RoadmapView extends StatefulWidget {
  const RoadmapView({super.key});

  @override
  State<RoadmapView> createState() => _RoadmapViewState();
}

class _RoadmapViewState extends State<RoadmapView> {
  late final RoadmapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoadmapController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Yol Haritası (Roadmap)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Aktif Rota Kartı
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🎯 0\'dan 5K Koşuya (30 Gün)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '🔥 12 Gün',
                            style: TextStyle(color: AppColors.secondary, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'İlerleme: 2 / 5 Aşama Tamamlandı (%40)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.4,
                        minHeight: 8,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Aşama Ağacı',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<List<RoadmapNodeModel>>(
                valueListenable: _controller.nodesNotifier,
                builder: (context, nodes, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: nodes.length,
                    itemBuilder: (context, index) {
                      final node = nodes[index];
                      final isLast = index == nodes.length - 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sol Düğüm Hattı
                          Column(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: node.isCompleted
                                      ? AppColors.primary
                                      : (node.isActive
                                          ? AppColors.primary.withValues(alpha: 0.2)
                                          : (isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight)),
                                  border: Border.all(
                                    color: node.isCompleted || node.isActive
                                        ? AppColors.primary
                                        : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: node.isCompleted
                                      ? const Icon(Icons.check, size: 18, color: AppColors.onPrimary)
                                      : (node.isActive
                                          ? const Icon(Icons.bolt, size: 20, color: AppColors.primary)
                                          : const Icon(Icons.lock_outline, size: 16, color: AppColors.outline)),
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: node.isActive ? 110 : 50,
                                  color: node.isCompleted
                                      ? AppColors.primary
                                      : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          // Sağ Detay Kartı
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: node.isActive
                                      ? AppColors.primary.withValues(alpha: 0.08)
                                      : (isDark ? AppColors.surfaceContainer : AppColors.surfaceLight),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: node.isActive
                                        ? AppColors.primary
                                        : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${node.stageNumber}. Aşama: ${node.title}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: node.isLocked
                                            ? (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary)
                                            : (isDark ? AppColors.onSurface : AppColors.textLight),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      node.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                      ),
                                    ),
                                    if (node.isActive) ...[
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.onPrimary,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        ),
                                        icon: const Icon(Icons.check_circle_outline, size: 16),
                                        label: const Text('Aşamayı Tamamla', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        onPressed: () => _controller.completeActiveStage(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
