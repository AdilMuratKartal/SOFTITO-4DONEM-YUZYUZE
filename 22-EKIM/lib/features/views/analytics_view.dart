import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';

class AnalyticsView extends StatelessWidget {
  final dynamic habitController;

  const AnalyticsView({super.key, this.habitController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('İstatistik & Analiz'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metrik Özet Kartları
              Row(
                children: [
                  _buildMetricCard(context, '%82', 'Haftalık Başarı', Icons.track_changes, AppColors.primary, isDark),
                  const SizedBox(width: 10),
                  _buildMetricCard(context, '18 Gün', 'En Uzun Seri', Icons.local_fire_department, AppColors.secondary, isDark),
                  const SizedBox(width: 10),
                  _buildMetricCard(context, '6.5 Sa', 'Odaklanma', Icons.timer, AppColors.tertiary, isDark),
                ],
              ),
              const SizedBox(height: 20),

              // Haftalık Tamamlama Bar Grafiği
              Text(
                'Haftalık Tamamlanma Grafiği',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                            final idx = val.toInt();
                            if (idx >= 0 && idx < days.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  days[idx],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _makeBarGroup(0, 70, isDark),
                      _makeBarGroup(1, 100, isDark),
                      _makeBarGroup(2, 60, isDark),
                      _makeBarGroup(3, 85, isDark),
                      _makeBarGroup(4, 90, isDark),
                      _makeBarGroup(5, 50, isDark),
                      _makeBarGroup(6, 80, isDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kategori Dağılımı Donut Grafiği
              Text(
                'Kategori Dağılımı',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 36,
                          sections: [
                            PieChartSectionData(
                              color: AppColors.categorySport,
                              value: 35,
                              showTitle: false,
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: AppColors.categoryHealth,
                              value: 25,
                              showTitle: false,
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: AppColors.categoryMind,
                              value: 20,
                              showTitle: false,
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: AppColors.categoryMusic,
                              value: 12,
                              showTitle: false,
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: AppColors.secondary,
                              value: 8,
                              showTitle: false,
                              radius: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendRow('Spor (%35)', AppColors.categorySport, isDark),
                          const SizedBox(height: 6),
                          _buildLegendRow('Sağlık (%25)', AppColors.categoryHealth, isDark),
                          const SizedBox(height: 6),
                          _buildLegendRow('Zihin (%20)', AppColors.categoryMind, isDark),
                          const SizedBox(height: 6),
                          _buildLegendRow('Müzik (%12)', AppColors.categoryMusic, isDark),
                          const SizedBox(height: 6),
                          _buildLegendRow('Diğer (%8)', AppColors.secondary, isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Başarı / Seri Isı Haritası
              Text(
                'Aylık Aktivite Haritası',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(28, (i) {
                    final density = (i * 7) % 5;
                    Color cellColor;
                    if (density == 0) {
                      cellColor = isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight;
                    } else if (density == 1) {
                      cellColor = AppColors.primary.withValues(alpha: 0.25);
                    } else if (density == 2) {
                      cellColor = AppColors.primary.withValues(alpha: 0.50);
                    } else if (density == 3) {
                      cellColor = AppColors.primary.withValues(alpha: 0.75);
                    } else {
                      cellColor = AppColors.primary;
                    }

                    return Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String value, String label, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurface : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, bool isDark) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y == 100 ? AppColors.secondary : AppColors.primary,
          width: 14,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendRow(String title, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
