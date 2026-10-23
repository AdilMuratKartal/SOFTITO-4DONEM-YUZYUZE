import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/habit_controller.dart';

class AnalyticsView extends StatelessWidget {
  final HabitController habitController;

  const AnalyticsView({super.key, required this.habitController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistik ve Analiz'),
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
                  _buildMetricCard(context, '%84', 'Başarı Oranı', Icons.trending_up, AppColors.primary),
                  const SizedBox(width: 10),
                  _buildMetricCard(context, '18 Gün', 'En Uzun Seri', Icons.local_fire_department, AppColors.secondary),
                  const SizedBox(width: 10),
                  _buildMetricCard(context, '6.5 Sa', 'Odaklanma', Icons.timer, AppColors.info),
                ],
              ),
              const SizedBox(height: 20),

              // Haftalık Tamamlama Bar Grafiği
              const Text('Haftalık Tamamlanma Grafiği', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
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
                                child: Text(days[idx], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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
                      _makeBarGroup(0, 70),
                      _makeBarGroup(1, 100),
                      _makeBarGroup(2, 60),
                      _makeBarGroup(3, 85),
                      _makeBarGroup(4, 90),
                      _makeBarGroup(5, 50),
                      _makeBarGroup(6, 80),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Katkı Isı Haritası (Heatmap Grid)
              const Text('Katkı Isı Haritası (GitHub Tarzı)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ekim 2026', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(28, (i) {
                        final intensity = (i % 4);
                        Color color = AppColors.borderLight;
                        if (intensity == 1) color = AppColors.primary.withValues(alpha: 0.35);
                        if (intensity == 2) color = AppColors.primary.withValues(alpha: 0.7);
                        if (intensity == 3) color = AppColors.primary;

                        return Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mood & Alışkanlık Korelasyonu
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.info, size: 26),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '💡 İçgörü: Spor ve Zihin alışkanlıklarını tamamladığın günlerde duygu durumun %78 daha pozitif kaydedildi.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Kategori Dağılım Grafiği (Donut Chart - 4 Temel Kategori + Özel)
              const Text('Kategori Dağılımı', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(value: 35, color: AppColors.categorySport, title: '%35', radius: 35, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            PieChartSectionData(value: 30, color: AppColors.categoryHealth, title: '%30', radius: 35, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            PieChartSectionData(value: 20, color: AppColors.categoryMind, title: '%20', radius: 35, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            PieChartSectionData(value: 15, color: AppColors.categoryMusic, title: '%15', radius: 35, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildLegendItem('Spor', AppColors.categorySport),
                        _buildLegendItem('Sağlık', AppColors.categoryHealth),
                        _buildLegendItem('Zihin', AppColors.categoryMind),
                        _buildLegendItem('Müzik', AppColors.categoryMusic),
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

  Widget _buildMetricCard(BuildContext context, String value, String label, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 14,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
