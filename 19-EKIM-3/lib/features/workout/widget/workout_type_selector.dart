import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';

/// Egzersiz Türü Seçici ve Hızlı Ekleme Bileşeni
class WorkoutTypeSelector extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutTypeSelector({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 12),
        _buildWorkoutButtons(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hızlı Egzersiz Ekle',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Özel Egzersiz'),
          onPressed: () => _showCustomWorkoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildWorkoutButtons(BuildContext context) {
    return Row(
      children: [
        _presetButton(context, 'Koşu', Icons.directions_run_rounded, 30, 280),
        const SizedBox(width: 8),
        _presetButton(context, 'Fitness', Icons.fitness_center_rounded, 45, 220),
        const SizedBox(width: 8),
        _presetButton(context, 'Bisiklet', Icons.directions_bike_rounded, 30, 240),
        const SizedBox(width: 8),
        _presetButton(context, 'Yürüyüş', Icons.nordic_walking_rounded, 20, 90),
      ],
    );
  }

  Widget _presetButton(
    BuildContext context,
    String name,
    IconData icon,
    int minutes,
    int calories,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.addWorkout(
            title: '$minutes dk $name',
            type: name,
            durationMinutes: minutes,
            caloriesBurned: calories,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.tertiary, size: 22),
              const SizedBox(height: 4),
              Text(
                name,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$calories kcal',
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomWorkoutDialog(BuildContext context) {
    final titleController = TextEditingController();
    final durationController = TextEditingController();
    final calorieController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Yeni Egzersiz Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Egzersiz Adı (Örn: Yüzme)'),
                ),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Süre (dakika)'),
                ),
                TextField(
                  controller: calorieController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Harcanan Kalori (kcal)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final duration = int.tryParse(durationController.text) ?? 20;
                final calories = int.tryParse(calorieController.text) ?? 150;
                final title = titleController.text.trim().isEmpty
                    ? 'Genel Egzersiz'
                    : titleController.text.trim();

                controller.addWorkout(
                  title: title,
                  type: 'Özel',
                  durationMinutes: duration,
                  caloriesBurned: calories,
                );
                Navigator.pop(ctx);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
