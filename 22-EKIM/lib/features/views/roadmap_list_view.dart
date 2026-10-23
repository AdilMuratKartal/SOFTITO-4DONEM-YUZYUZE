import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart';
import '../controllers/roadmap_controller.dart';
import '../controllers/habit_controller.dart';
import '../widgets/roadmap_card.dart';
import '../widgets/roadmap_node_tree.dart';
import '../widgets/create_roadmap_sheet.dart';
import 'roadmap_detail_view.dart';

/// 1. Hiyerarşik Ekran Yapısı: Liste Ekranı (Aktif Yol Haritalarım ve Tamamlananlar Arşivi)
class RoadmapListView extends StatelessWidget {
  final RoadmapController roadmapController;
  final HabitController habitController;

  const RoadmapListView({
    super.key,
    required this.roadmapController,
    required this.habitController,
  });

  void _openDetail(BuildContext context, RoadmapModel roadmap) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoadmapDetailView(
          roadmap: roadmap,
          roadmapController: roadmapController,
          habitController: habitController,
        ),
      ),
    );
  }

  void _openCreateSheet(BuildContext context) {
    CreateRoadmapSheet.show(
      context: context,
      availableHabits: habitController.habitsNotifier.value,
      onSave: (newRoadmap) {
        roadmapController.addRoadmap(newRoadmap);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder<List<RoadmapModel>>(
          valueListenable: roadmapController.roadmapsNotifier,
          builder: (context, roadmaps, _) {
            final activeRoadmaps = roadmaps.where((r) => !r.isCompleted).toList();
            final completedRoadmaps = roadmaps.where((r) => r.isCompleted).toList();

            return ValueListenableBuilder<RoadmapModel?>(
              valueListenable: roadmapController.selectedRoadmapNotifier,
              builder: (context, selectedRoadmap, _) {
                // Seçili harita yoksa aktiflerin ilkini al
                final currentRoadmap = (selectedRoadmap != null &&
                        activeRoadmaps.any((r) => r.id == selectedRoadmap.id))
                    ? selectedRoadmap
                    : (activeRoadmaps.isNotEmpty ? activeRoadmaps.first : null);

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeader(context, isDark),

                      const SizedBox(height: 16),

                      // 1. AKTİF YOL HARİTASI HERO KARTI
                      if (currentRoadmap != null) ...[
                        RoadmapCard(
                          roadmap: currentRoadmap,
                          isFeatured: true,
                          onTap: () => _openDetail(context, currentRoadmap),
                        ),

                        // Birden fazla aktif yol haritası varsa aralarında geçiş çipi
                        if (activeRoadmaps.length > 1) ...[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: activeRoadmaps.map((r) {
                                final isSelected = r.id == currentRoadmap.id;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8, bottom: 12),
                                  child: ChoiceChip(
                                    label: Text(r.title, style: const TextStyle(fontSize: 12)),
                                    selected: isSelected,
                                    onSelected: (_) => roadmapController.selectRoadmap(r),
                                    selectedColor: AppColors.primary,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],

                        // Dikey Aşama Basamakları Ağacı (Milestone Stepper Tree)
                        RoadmapNodeTree(
                          roadmap: currentRoadmap,
                          roadmapController: roadmapController,
                          habitController: habitController,
                          onNodeTap: (node) => _openDetail(context, currentRoadmap),
                        ),
                      ] else ...[
                        // Aktif harita yoksa boş durum
                        _buildEmptyActiveState(context, isDark),
                      ],

                      const SizedBox(height: 20),

                      // 2. TAMAMLANAN YOL HARİTALARI (AÇILIR/KAPANIR AKORDEON)
                      if (completedRoadmaps.isNotEmpty)
                        _buildCompletedAccordion(context, completedRoadmaps, isDark),

                      // FAB için alt boşluk
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateSheet(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        tooltip: 'Yeni Yol Haritası Ekle',
        child: const Icon(Icons.add_rounded, size: 28, color: AppColors.onPrimary),
      ),
    );
  }

  /// Üst Başlık Bölümü
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yol Haritası & Hedefler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.01,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Basamak basamak inşa edilen büyük alışkanlıklar',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune_rounded, size: 18),
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                padding: EdgeInsets.zero,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Yol haritası filtreleme aktif.')),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.inventory_2_outlined, size: 18),
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                padding: EdgeInsets.zero,
                onPressed: roadmapController.toggleCompletedAccordion,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Aktif Harita Bulunmadığında Boş Durum
  Widget _buildEmptyActiveState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.alt_route_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.8)),
            const SizedBox(height: 12),
            Text(
              'Aktif Bir Yol Haritanız Yok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurface : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Büyük bir hedefi basamaklara ayırmak için yeni bir yol haritası oluşturun.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openCreateSheet(context),
              icon: const Icon(Icons.add, size: 16, color: AppColors.onPrimary),
              label: const Text('Yeni Yol Haritası Başlat', style: TextStyle(color: AppColors.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tamamlanan Yol Haritaları Akordeonu (Expansion Accordion)
  Widget _buildCompletedAccordion(
    BuildContext context,
    List<RoadmapModel> completedRoadmaps,
    bool isDark,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: roadmapController.isCompletedExpandedNotifier,
      builder: (context, isExpanded, _) {
        return Column(
          children: [
            InkWell(
              onTap: roadmapController.toggleCompletedAccordion,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.task_alt_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tamamlanan Yol Haritaları (${completedRoadmaps.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.onSurface : AppColors.textLight,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              ...completedRoadmaps.map((r) {
                return RoadmapCard(
                  roadmap: r,
                  isFeatured: false,
                  onTap: () => _openDetail(context, r),
                );
              }),
            ],
          ],
        );
      },
    );
  }
}
