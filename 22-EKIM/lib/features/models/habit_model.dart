import 'dart:convert';
import 'package:flutter/foundation.dart';

enum HabitType { checkmark, counter, timer }

@immutable
class HabitModel {
  final String id;
  final String title;
  final String categoryId;
  final String iconPath;
  final HabitType type;
  final List<int> selectedDays; // [1..7] (1: Pzt, 7: Paz)
  final String startTime;       // Örn: '09:45'
  final String endTime;         // Örn: '15:36'
  final bool hasReminder;
  final double currentProgress;
  final double targetProgress;
  final String unit;
  final int streakDays;
  final bool isCompleted;
  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.iconPath,
    this.type = HabitType.checkmark,
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    required this.startTime,
    required this.endTime,
    this.hasReminder = false,
    this.currentProgress = 0.0,
    this.targetProgress = 1.0,
    this.unit = 'kez',
    this.streakDays = 0,
    this.isCompleted = false,
    required this.createdAt,
  });

  HabitModel copyWith({
    String? title,
    String? categoryId,
    String? iconPath,
    HabitType? type,
    List<int>? selectedDays,
    String? startTime,
    String? endTime,
    bool? hasReminder,
    double? currentProgress,
    double? targetProgress,
    String? unit,
    int? streakDays,
    bool? isCompleted,
  }) {
    return HabitModel(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      iconPath: iconPath ?? this.iconPath,
      type: type ?? this.type,
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hasReminder: hasReminder ?? this.hasReminder,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      unit: unit ?? this.unit,
      streakDays: streakDays ?? this.streakDays,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'iconPath': iconPath,
      'type': type.index,
      'selectedDays': selectedDays,
      'startTime': startTime,
      'endTime': endTime,
      'hasReminder': hasReminder,
      'currentProgress': currentProgress,
      'targetProgress': targetProgress,
      'unit': unit,
      'streakDays': streakDays,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      categoryId: map['categoryId'] as String,
      iconPath: map['iconPath'] as String,
      type: HabitType.values[map['type'] as int? ?? 0],
      selectedDays: List<int>.from(map['selectedDays'] as List? ?? [1, 2, 3, 4, 5, 6, 7]),
      startTime: map['startTime'] as String? ?? '09:00',
      endTime: map['endTime'] as String? ?? '10:00',
      hasReminder: map['hasReminder'] as bool? ?? false,
      currentProgress: (map['currentProgress'] as num?)?.toDouble() ?? 0.0,
      targetProgress: (map['targetProgress'] as num?)?.toDouble() ?? 1.0,
      unit: map['unit'] as String? ?? 'kez',
      streakDays: map['streakDays'] as int? ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitModel.fromJson(String source) =>
      HabitModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
