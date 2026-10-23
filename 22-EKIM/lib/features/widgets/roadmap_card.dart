import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/roadmap_model.dart';

/// Öne Çıkan Aktif Yol Haritası Hero Kartı
class RoadmapCard extends StatelessWidget {
  final RoadmapModel roadmap;
  final VoidCallback onTap;
  final bool isFeatured;

  const RoadmapCard({
    super.key,
    required this.roadmap,
    required this.onTap,
    this.isFeatured = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isFeatured) {
      return _buildCompactCard(context, isDark);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.outlineVariant.withValues(alpha: 0.6) : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Sağ üst arka plan zümrüt ışıltısı efekti
              Positioned(
                top: -24,
                right: -24,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst Satır: Kategori + Süre + Durum Rozeti
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceContainerHighest
                                    : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(roadmap.iconName, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    roadmap.category,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceContainerHigh
                                    : AppColors.surfaceVariantLight,
                                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('⏱️', style: TextStyle(fontSize: 11)),
                                  const SizedBox(width: 4),
                                  Text(
                                    roadmap.durationWeeks,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: roadmap.isCompleted
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                          ),
                          child: Text(
                            roadmap.isCompleted ? 'Tamamlandı' : 'Aktif',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Başlık & Açıklama
                    Text(
                      roadmap.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.01,
                        color: isDark ? AppColors.onSurface : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bütünsel disiplin ve aşamalı alışkanlık inşa protokolü',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // İlerleme İstatistikleri ve Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${roadmap.completedNodesCount} / ${roadmap.nodes.length} Basamak Tamamlandı',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.onSurface : AppColors.textLight,
                          ),
                        ),
                        Text(
                          '%${roadmap.progressPercentage.toInt()}',
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
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      child: LinearProgressIndicator(
                        value: roadmap.progressRatio,
                        minHeight: 7,
                        backgroundColor: isDark ? AppColors.surfaceContainerHighest : AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Alt Kısım: Ödül & Aksiyon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Sonraki ödül: ',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              roadmap.nextReward,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Detayları Gör',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Arşivlenmiş / Tamamlanmış Kompakt Kart
  Widget _buildCompactCard(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.spaceSm),
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainerLow : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.outlineVariant.withValues(alpha: 0.5) : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(roadmap.iconName, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roadmap.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${roadmap.nodes.length} Basamak • %100 Tamamlandı',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
