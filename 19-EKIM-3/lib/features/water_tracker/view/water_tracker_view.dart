import 'package:flutter/material.dart';
import '../controller/water_reminder_controller.dart';
import '../controller/water_tracker_controller.dart';
import '../widget/quick_add_buttons.dart';
import '../widget/water_history_list.dart';
import '../widget/water_progress_card.dart';
import '../widget/water_reminder_timer.dart';

/// Su Takibi Ana Ekranı (StatelessWidget + Clean UI)
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;
  final WaterReminderController reminderController;

  const WaterTrackerView({
    super.key,
    required this.controller,
    required this.reminderController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WaterProgressCard(controller: controller),
          const SizedBox(height: 16),
          QuickAddButtons(controller: controller),
          const SizedBox(height: 16),
          WaterReminderTimer(reminderController: reminderController),
          const SizedBox(height: 16),
          WaterHistoryList(controller: controller),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
