import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

/// Egzersiz ve Kalori Durumunu Yöneten Reaktif Kontrolcü
class WorkoutController {
  final ValueNotifier<List<WorkoutModel>> workoutsNotifier =
      ValueNotifier<List<WorkoutModel>>(<WorkoutModel>[]);
  final ValueNotifier<int> totalCaloriesNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> totalMinutesNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> recommendedWaterNotifier = ValueNotifier<int>(0);

  List<WorkoutModel> get workouts => workoutsNotifier.value;
  int get totalCalories => totalCaloriesNotifier.value;
  int get totalMinutes => totalMinutesNotifier.value;
  int get recommendedWater => recommendedWaterNotifier.value;

  void addWorkout({
    required String title,
    required String type,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    // Egzersiz süresine göre ekstra su gereksinimi (yaklaşık 15 dk için 200 ml)
    final waterNeeded = (durationMinutes / 15 * 200).round();

    final workout = WorkoutModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      type: type,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      waterNeededMl: waterNeeded,
      timestamp: DateTime.now(),
    );

    workoutsNotifier.value = List<WorkoutModel>.from(workoutsNotifier.value)
      ..insert(0, workout);
    _recalculateTotals();
  }

  void removeWorkout(String id) {
    workoutsNotifier.value =
        workoutsNotifier.value.where((w) => w.id != id).toList();
    _recalculateTotals();
  }

  void reset() {
    workoutsNotifier.value = <WorkoutModel>[];
    totalCaloriesNotifier.value = 0;
    totalMinutesNotifier.value = 0;
    recommendedWaterNotifier.value = 0;
  }

  void _recalculateTotals() {
    int calories = 0;
    int minutes = 0;
    int extraWater = 0;

    for (final w in workoutsNotifier.value) {
      calories += w.caloriesBurned;
      minutes += w.durationMinutes;
      extraWater += w.waterNeededMl;
    }

    totalCaloriesNotifier.value = calories;
    totalMinutesNotifier.value = minutes;
    recommendedWaterNotifier.value = extraWater;
  }

  void dispose() {
    workoutsNotifier.dispose();
    totalCaloriesNotifier.dispose();
    totalMinutesNotifier.dispose();
    recommendedWaterNotifier.dispose();
  }
}
