import 'package:flutter/foundation.dart';

/// Su Tüketim Kaydı Modeli (İmmutable)
@immutable
class WaterEntryModel {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String? note;

  const WaterEntryModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.note,
  });

  WaterEntryModel copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? note,
  }) {
    return WaterEntryModel(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  factory WaterEntryModel.fromJson(Map<String, dynamic> json) {
    return WaterEntryModel(
      id: json['id'] as String? ?? '',
      amountMl: (json['amountMl'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amountMl == other.amountMl &&
          timestamp == other.timestamp &&
          note == other.note;

  @override
  int get hashCode => Object.hash(id, amountMl, timestamp, note);
}
