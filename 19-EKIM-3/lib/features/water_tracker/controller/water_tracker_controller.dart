import 'package:flutter/foundation.dart';
import '../models/water_entry_model.dart';

/// Su Tüketimini Yöneten Reaktif Kontrolcü (ValueNotifier Tabanlı)
class WaterTrackerController {
  final ValueNotifier<int> totalWaterNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> dailyGoalNotifier = ValueNotifier<int>(2500);
  final ValueNotifier<List<WaterEntryModel>> historyNotifier =
      ValueNotifier<List<WaterEntryModel>>(<WaterEntryModel>[]);

  int get totalWater => totalWaterNotifier.value;
  int get dailyGoal => dailyGoalNotifier.value;
  List<WaterEntryModel> get history => historyNotifier.value;

  double get progressPercentage {
    if (dailyGoalNotifier.value == 0) return 0.0;
    return (totalWaterNotifier.value / dailyGoalNotifier.value).clamp(0.0, 1.0);
  }

  void addWater(int amountMl, {String? note}) {
    if (amountMl <= 0) return;
    final entry = WaterEntryModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      note: note,
    );

    totalWaterNotifier.value += amountMl;
    historyNotifier.value = List<WaterEntryModel>.from(historyNotifier.value)
      ..insert(0, entry);
  }

  void removeEntry(String id) {
    final targetIndex =
        historyNotifier.value.indexWhere((entry) => entry.id == id);
    if (targetIndex != -1) {
      final removed = historyNotifier.value[targetIndex];
      final newTotal = (totalWaterNotifier.value - removed.amountMl).clamp(0, 999999);
      totalWaterNotifier.value = newTotal;

      final updatedList = List<WaterEntryModel>.from(historyNotifier.value)
        ..removeAt(targetIndex);
      historyNotifier.value = updatedList;
    }
  }

  void reset() {
    totalWaterNotifier.value = 0;
    historyNotifier.value = <WaterEntryModel>[];
  }

  void updateDailyGoal(int newGoal) {
    if (newGoal > 0) {
      dailyGoalNotifier.value = newGoal;
    }
  }

  void dispose() {
    totalWaterNotifier.dispose();
    dailyGoalNotifier.dispose();
    historyNotifier.dispose();
  }
}
