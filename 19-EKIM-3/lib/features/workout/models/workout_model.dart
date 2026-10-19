import 'package:flutter/foundation.dart';

/// Egzersiz ve Kalori Modeli (İmmutable)
@immutable
class WorkoutModel {
  final String id;
  final String title;
  final String type;
  final int durationMinutes;
  final int caloriesBurned;
  final int waterNeededMl;
  final DateTime timestamp;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.waterNeededMl,
    required this.timestamp,
  });

  WorkoutModel copyWith({
    String? id,
    String? title,
    String? type,
    int? durationMinutes,
    int? caloriesBurned,
    int? waterNeededMl,
    DateTime? timestamp,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      waterNeededMl: waterNeededMl ?? this.waterNeededMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt() ?? 0,
      waterNeededMl: (json['waterNeededMl'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'type': type,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'waterNeededMl': waterNeededMl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          type == other.type &&
          durationMinutes == other.durationMinutes &&
          caloriesBurned == other.caloriesBurned &&
          waterNeededMl == other.waterNeededMl &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        type,
        durationMinutes,
        caloriesBurned,
        waterNeededMl,
        timestamp,
      );
}
