import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';

/// Günlük Su İlerleme Kartı Bileşeni
class WaterProgressCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterProgressCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = theme.cardTheme.color ?? theme.colorScheme.surface;
    final borderColor = isDark ? const Color(0xFF30363D) : const Color(0xFFD0D7DE);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.totalWaterNotifier,
        builder: (context, totalWater, _) {
          return ValueListenableBuilder<int>(
            valueListenable: controller.dailyGoalNotifier,
            builder: (context, goal, _) {
              final progress = goal > 0 ? (totalWater / goal).clamp(0.0, 1.0) : 0.0;
              final percent = (progress * 100).toInt();

              return Column(
                children: [
                  _buildProgressHeader(theme, percent),
                  const SizedBox(height: 16),
                  _buildProgressBar(theme, progress),
                  const SizedBox(height: 14),
                  _buildStatsRow(theme, totalWater, goal),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(ThemeData theme, int percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Günlük Hedef',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '%$percent',
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme, double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 14,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, int total, int goal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$total ml içildi',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          'Hedef: $goal ml',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
