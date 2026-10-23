import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/habit_controller.dart';
import '../../models/habit_model.dart';
import '../../models/category_model.dart';
import '../../models/mood_model.dart';

class DayHabitStatus {
  final String title;
  final String categoryName;
  final Color categoryColor;
  final String iconPath;
  final String timeRange;
  final bool isCompleted;

  DayHabitStatus({
    required this.title,
    required this.categoryName,
    required this.categoryColor,
    required this.iconPath,
    required this.timeRange,
    required this.isCompleted,
  });
}

class DayActivityDetail {
  final DateTime date;
  final int completedCount;
  final int totalCount;
  final String? moodKey;
  final List<DayHabitStatus> habits;

  DayActivityDetail({
    required this.date,
    required this.completedCount,
    required this.totalCount,
    this.moodKey,
    required this.habits,
  });
}

class AnalyticsView extends StatefulWidget {
  final HabitController? habitController;

  const AnalyticsView({super.key, this.habitController});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  DateTime? _hoveredDate;

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
    } else if (iconPath.contains('bike') || iconPath.contains('bisiklet')) {
      return Icons.pedal_bike_rounded;
    } else if (iconPath.contains('palette') || iconPath.contains('sanat')) {
      return Icons.palette_rounded;
    } else if (iconPath.contains('code') || iconPath.contains('kod')) {
      return Icons.code_rounded;
    } else if (iconPath.contains('sleep') || iconPath.contains('uyku')) {
      return Icons.bedtime_rounded;
    }
    return Icons.star_rounded;
  }

  DayActivityDetail _calculateDayDetail(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final isFuture = date.isAfter(DateTime(now.year, now.month, now.day));

    final allHabits = widget.habitController?.habitsNotifier.value ?? <HabitModel>[];
    final allCategories = widget.habitController?.categoriesNotifier.value ?? CategoryModel.defaultCategories;

    // O günün haftanın günü (1: Pzt ... 7: Paz)
    final dayOfWeek = date.weekday;
    final scheduledHabits = allHabits.where((h) => h.selectedDays.contains(dayOfWeek)).toList();
    final effectiveHabits = scheduledHabits.isNotEmpty ? scheduledHabits : allHabits;

    if (isFuture) {
      return DayActivityDetail(
        date: date,
        completedCount: 0,
        totalCount: effectiveHabits.length,
        moodKey: null,
        habits: effectiveHabits.map((h) {
          final cat = allCategories.firstWhere(
            (c) => c.id == h.categoryId,
            orElse: () => const CategoryModel(id: 'genel', name: 'Genel', iconPath: '', colorHex: 0xFF4EDEA3),
          );
          return DayHabitStatus(
            title: h.title,
            categoryName: cat.name,
            categoryColor: Color(cat.colorHex),
            iconPath: h.iconPath,
            timeRange: '${h.startTime} - ${h.endTime}',
            isCompleted: false,
          );
        }).toList(),
      );
    }

    if (isToday) {
      final completed = allHabits.where((h) => h.isCompleted).length;
      return DayActivityDetail(
        date: date,
        completedCount: completed,
        totalCount: allHabits.length,
        moodKey: 'great',
        habits: allHabits.map((h) {
          final cat = allCategories.firstWhere(
            (c) => c.id == h.categoryId,
            orElse: () => const CategoryModel(id: 'genel', name: 'Genel', iconPath: '', colorHex: 0xFF4EDEA3),
          );
          return DayHabitStatus(
            title: h.title,
            categoryName: cat.name,
            categoryColor: Color(cat.colorHex),
            iconPath: h.iconPath,
            timeRange: '${h.startTime} - ${h.endTime}',
            isCompleted: h.isCompleted,
          );
        }).toList(),
      );
    }

    // Geçmiş günler için gerçekçi simülasyon ve alışkanlık eşleştirmesi
    final habitStatuses = <DayHabitStatus>[];
    int completedCount = 0;

    for (int i = 0; i < effectiveHabits.length; i++) {
      final h = effectiveHabits[i];
      final cat = allCategories.firstWhere(
        (c) => c.id == h.categoryId,
        orElse: () => const CategoryModel(id: 'genel', name: 'Genel', iconPath: '', colorHex: 0xFF4EDEA3),
      );
      // Gün ve index bazlı tutarlı tamamlama simülasyonu
      final isDone = ((date.day * 3 + i * 2) % 4) != 0;
      if (isDone) completedCount++;

      habitStatuses.add(DayHabitStatus(
        title: h.title,
        categoryName: cat.name,
        categoryColor: Color(cat.colorHex),
        iconPath: h.iconPath,
        timeRange: '${h.startTime} - ${h.endTime}',
        isCompleted: isDone,
      ));
    }

    // Mood eşleştirmesi
    const moods = ['great', 'good', 'neutral', 'good', 'great'];
    final mood = moods[(date.day + date.weekday) % moods.length];

    return DayActivityDetail(
      date: date,
      completedCount: completedCount,
      totalCount: effectiveHabits.length,
      moodKey: mood,
      habits: habitStatuses,
    );
  }

  void _showDayDetailsModal(BuildContext context, DayActivityDetail detail, bool isDark) {
    HapticFeedback.lightImpact();

    const trDays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    final dayName = trDays[detail.date.weekday - 1];
    const trMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final monthName = trMonths[detail.date.month - 1];

    final ratio = detail.totalCount > 0 ? (detail.completedCount / detail.totalCount) : 0.0;
    final percent = (ratio * 100).toInt();

    final moodItem = MoodItem.allMoods.cast<MoodItem?>().firstWhere(
          (m) => m?.keyName == detail.moodKey,
          orElse: () => null,
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusModal)),
            border: Border.all(
              color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tutma Çubuğu (Drag Handle)
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.outlineVariant : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Tarih ve Tamamlama Özeti Başlığı
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              '${detail.date.day} $monthName ${detail.date.year}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.onSurface : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(left: 26.0),
                          child: Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '${detail.completedCount} / ${detail.totalCount} (%$percent)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // O günün mood durumu
              if (moodItem != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: moodItem.activeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: moodItem.activeColor.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Text(moodItem.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Günün Modu: ${moodItem.label}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: moodItem.activeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                'Alışkanlık Durumları',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.onSurface : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              // Alışkanlıklar Listesi
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: detail.habits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final habit = detail.habits[idx];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: habit.isCompleted
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : (isDark ? AppColors.outlineVariant : AppColors.borderLight),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: habit.categoryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(_getIconData(habit.iconPath), color: habit.categoryColor, size: 18),
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
                                    decoration: habit.isCompleted ? TextDecoration.none : null,
                                    color: isDark ? AppColors.onSurface : AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      habit.categoryName,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: habit.categoryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '•  ${habit.timeRange}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: habit.isCompleted
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : (isDark ? AppColors.surfaceContainerHighest : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  habit.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                  size: 14,
                                  color: habit.isCompleted ? AppColors.primary : AppColors.outline,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  habit.isCompleted ? 'Tamamlandı' : 'Yapılmadı',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: habit.isCompleted ? AppColors.primary : AppColors.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Kapat', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    const trMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final currentMonthName = trMonths[now.month - 1];

    final hoveredDetail = _hoveredDate != null ? _calculateDayDetail(_hoveredDate!) : null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('İstatistik & Analiz'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                            PieChartSectionData(color: AppColors.categorySport, value: 35, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.categoryHealth, value: 25, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.categoryMind, value: 20, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.categoryMusic, value: 12, showTitle: false, radius: 18),
                            PieChartSectionData(color: AppColors.secondary, value: 8, showTitle: false, radius: 18),
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

              // Aylık Aktivite Izgarası (Heatmap)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aylık Aktivite Izgarası ($currentMonthName ${now.year})',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.onSurface : AppColors.textLight,
                    ),
                  ),
                  const Text(
                    'Detay için dokun',
                    style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainer : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.outlineVariant : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Canlı Hover / Önizleme Bilgi Çubuğu
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: hoveredDetail != null
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : (isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceVariantLight),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: hoveredDetail != null
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            hoveredDetail != null ? Icons.touch_app_rounded : Icons.info_outline,
                            size: 16,
                            color: hoveredDetail != null ? AppColors.primary : AppColors.outline,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hoveredDetail != null
                                  ? '${hoveredDetail.date.day} $currentMonthName: ${hoveredDetail.completedCount} alışkanlık tamamlandı (Detaylar için tıkla)'
                                  : 'Günün üzerine gelerek veya tıklayarak detayları görüntüleyin',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: hoveredDetail != null ? FontWeight.bold : FontWeight.w500,
                                color: hoveredDetail != null
                                    ? AppColors.primary
                                    : (isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gün İsimleri Başlığı (Pzt, Sal, Çar, Per, Cum, Cmt, Paz)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: const [
                          'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'
                        ].map((d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.outline,
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                    // 7 Kolonlu Aylık Izgara
                    _buildMonthCalendarGrid(context, now, daysInMonth, isDark, currentMonthName),
                    const SizedBox(height: 12),
                    // Renk Yoğunluğu Skalası (Legend)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Daha Az',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                        ),
                        const SizedBox(width: 6),
                        _buildLegendBox(isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight),
                        const SizedBox(width: 4),
                        _buildLegendBox(AppColors.primary.withValues(alpha: 0.25)),
                        const SizedBox(width: 4),
                        _buildLegendBox(AppColors.primary.withValues(alpha: 0.50)),
                        const SizedBox(width: 4),
                        _buildLegendBox(AppColors.primary.withValues(alpha: 0.75)),
                        const SizedBox(width: 4),
                        _buildLegendBox(AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Daha Çok',
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.onSurfaceVariant : AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendarGrid(
    BuildContext context,
    DateTime now,
    int daysInMonth,
    bool isDark,
    String currentMonthName,
  ) {
    // Ayın 1. gününün haftanın günü (1: Pzt ... 7: Paz)
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final leadingEmptyDays = firstDayOfMonth.weekday - 1; // 0..6
    final totalCells = leadingEmptyDays + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - leadingEmptyDays + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 36));
              }

              final cellDate = DateTime(now.year, now.month, dayNumber);
              final isToday = cellDate.day == now.day && cellDate.month == now.month && cellDate.year == now.year;
              final isFuture = cellDate.isAfter(DateTime(now.year, now.month, now.day));
              final detail = _calculateDayDetail(cellDate);

              Color cellColor;
              if (isFuture) {
                cellColor = (isDark ? AppColors.surfaceContainerLowest : AppColors.surfaceVariantLight).withValues(alpha: 0.5);
              } else if (detail.completedCount == 0) {
                cellColor = isDark ? AppColors.surfaceContainerHigh : AppColors.borderLight;
              } else if (detail.completedCount == 1) {
                cellColor = AppColors.primary.withValues(alpha: 0.25);
              } else if (detail.completedCount == 2) {
                cellColor = AppColors.primary.withValues(alpha: 0.50);
              } else if (detail.completedCount == 3) {
                cellColor = AppColors.primary.withValues(alpha: 0.75);
              } else {
                cellColor = AppColors.primary;
              }

              final textColor = (detail.completedCount >= 3)
                  ? AppColors.onPrimary
                  : (isDark ? AppColors.onSurface : AppColors.textLight);

              final tooltipMessage = isFuture
                  ? '$dayNumber $currentMonthName: Gelecek Gün'
                  : '$dayNumber $currentMonthName: ${detail.completedCount} alışkanlık yapıldı\nDetaylar için dokunun';

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Tooltip(
                    message: tooltipMessage,
                    waitDuration: const Duration(milliseconds: 100),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _hoveredDate = cellDate;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          if (_hoveredDate == cellDate) _hoveredDate = null;
                        });
                      },
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _showDayDetailsModal(context, detail, isDark),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 36,
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isToday
                                  ? AppColors.secondary
                                  : (_hoveredDate == cellDate ? AppColors.primary : Colors.transparent),
                              width: isToday ? 2.0 : 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: (isToday || detail.completedCount >= 3) ? FontWeight.bold : FontWeight.w500,
                                color: isFuture ? AppColors.outline.withValues(alpha: 0.5) : textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
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
