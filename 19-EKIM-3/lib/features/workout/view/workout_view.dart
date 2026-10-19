import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';
import '../widget/workout_history_list.dart';
import '../widget/workout_summary_card.dart';
import '../widget/workout_type_selector.dart';

/// Egzersiz ve Kalori Takip Ekranı (StatelessWidget + Clean UI)
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutSummaryCard(controller: controller),
          const SizedBox(height: 16),
          WorkoutTypeSelector(controller: controller),
          const SizedBox(height: 16),
          WorkoutHistoryList(controller: controller),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
