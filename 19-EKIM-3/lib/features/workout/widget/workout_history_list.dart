import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';
import '../models/workout_model.dart';

/// Egzersiz Geçmişi Listesi Bileşeni
class WorkoutHistoryList extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutHistoryList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(theme),
        const SizedBox(height: 10),
        _buildList(theme),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Yapılan Antrenmanlar',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ValueListenableBuilder<List<WorkoutModel>>(
          valueListenable: controller.workoutsNotifier,
          builder: (context, workouts, _) {
            if (workouts.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: () => controller.reset(),
              child: const Text('Temizle'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(ThemeData theme) {
    return ValueListenableBuilder<List<WorkoutModel>>(
      valueListenable: controller.workoutsNotifier,
      builder: (context, workouts, _) {
        if (workouts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.sports_gymnastics_rounded,
                    size: 36,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Henüz antrenman kaydı eklenmedi.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return _buildWorkoutCard(context, theme, workout);
          },
        );
      },
    );
  }

  Widget _buildWorkoutCard(
    BuildContext context,
    ThemeData theme,
    WorkoutModel workout,
  ) {
    final timeStr =
        '${workout.timestamp.hour.toString().padLeft(2, '0')}:${workout.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.bolt_rounded,
              size: 20,
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} dk • ${workout.caloriesBurned} kcal • +${workout.waterNeededMl} ml su ihtiyacı',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16),
            color: theme.colorScheme.error,
            onPressed: () => controller.removeWorkout(workout.id),
          ),
        ],
      ),
    );
  }
}
