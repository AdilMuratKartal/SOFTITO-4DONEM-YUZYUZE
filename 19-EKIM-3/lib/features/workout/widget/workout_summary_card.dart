import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';

/// Egzersiz Özet Kartı Bileşeni
class WorkoutSummaryCard extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutSummaryCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16),
          _buildMetricsRow(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            color: theme.colorScheme.tertiary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Egzersiz & Kalori Durumu',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: controller.totalCaloriesNotifier,
            builder: (context, cal, _) => _metricItem(
              theme,
              '$cal',
              'kcal yakıldı',
              theme.colorScheme.error,
              Icons.local_fire_department_rounded,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: controller.totalMinutesNotifier,
            builder: (context, mins, _) => _metricItem(
              theme,
              '$mins',
              'dakika süre',
              theme.colorScheme.primary,
              Icons.timer_rounded,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: controller.recommendedWaterNotifier,
            builder: (context, water, _) => _metricItem(
              theme,
              '+$water',
              'ml ekstra su',
              theme.colorScheme.secondary,
              Icons.water_drop_rounded,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricItem(
    ThemeData theme,
    String value,
    String label,
    Color accentColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
