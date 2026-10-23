import 'dart:convert';

/// Yol Haritası Basamak / Düğüm Modeli
class RoadmapNodeModel {
  final String id;
  final int stepNumber;
  final String title;
  final String description;
  final int targetDaysStreak; // Bu aşamayı tamamlamak için gereken seri (gün)
  final List<String> linkedHabitIds; // Bağlı mikro-alışkanlık referans ID'leri
  final bool isCompleted;
  final bool isLocked;

  const RoadmapNodeModel({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.targetDaysStreak,
    required this.linkedHabitIds,
    this.isCompleted = false,
    this.isLocked = true,
  });

  RoadmapNodeModel copyWith({
    String? id,
    int? stepNumber,
    String? title,
    String? description,
    int? targetDaysStreak,
    List<String>? linkedHabitIds,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return RoadmapNodeModel(
      id: id ?? this.id,
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDaysStreak: targetDaysStreak ?? this.targetDaysStreak,
      linkedHabitIds: linkedHabitIds ?? this.linkedHabitIds,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  factory RoadmapNodeModel.fromJson(Map<String, dynamic> json) {
    return RoadmapNodeModel(
      id: json['id'] as String? ?? UniqueKey().toString(),
      stepNumber: json['stepNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetDaysStreak: json['targetDaysStreak'] as int? ?? 7,
      linkedHabitIds: (json['linkedHabitIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stepNumber': stepNumber,
      'title': title,
      'description': description,
      'targetDaysStreak': targetDaysStreak,
      'linkedHabitIds': linkedHabitIds,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
    };
  }
}

/// Yol Haritası Modeli
class RoadmapModel {
  final String id;
  final String title;
  final String category;
  final String iconName;
  final String durationWeeks;
  final String nextReward;
  final bool isCompleted;
  final List<RoadmapNodeModel> nodes;

  const RoadmapModel({
    required this.id,
    required this.title,
    required this.category,
    required this.iconName,
    this.durationWeeks = '4 Hafta',
    this.nextReward = 'Odak Nişanı',
    this.isCompleted = false,
    required this.nodes,
  });

  /// Tamamlanan düğüm / Toplam düğüm yüzdesi (0.0 - 100.0)
  double get progressPercentage {
    if (nodes.isEmpty) return 0.0;
    return (completedNodesCount / nodes.length) * 100;
  }

  /// 0.0 - 1.0 aralığında progress oranı (ProgressIndicator için)
  double get progressRatio {
    if (nodes.isEmpty) return 0.0;
    return completedNodesCount / nodes.length;
  }

  int get completedNodesCount => nodes.where((n) => n.isCompleted).length;

  /// İlk tamamlanmamış ve kilitli olmayan aktif basamağı döndürür
  RoadmapNodeModel? get activeNode {
    try {
      return nodes.firstWhere((n) => !n.isCompleted && !n.isLocked);
    } catch (_) {
      return null;
    }
  }

  RoadmapModel copyWith({
    String? id,
    String? title,
    String? category,
    String? iconName,
    String? durationWeeks,
    String? nextReward,
    bool? isCompleted,
    List<RoadmapNodeModel>? nodes,
  }) {
    return RoadmapModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      nextReward: nextReward ?? this.nextReward,
      isCompleted: isCompleted ?? this.isCompleted,
      nodes: nodes ?? this.nodes,
    );
  }

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    return RoadmapModel(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'Kişisel Gelişim',
      iconName: json['iconName'] as String? ?? '🎯',
      durationWeeks: json['durationWeeks'] as String? ?? '4 Hafta',
      nextReward: json['nextReward'] as String? ?? 'Odak Nişanı',
      isCompleted: json['isCompleted'] as bool? ?? false,
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => RoadmapNodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'iconName': iconName,
      'durationWeeks': durationWeeks,
      'nextReward': nextReward,
      'isCompleted': isCompleted,
      'nodes': nodes.map((n) => n.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory RoadmapModel.fromJsonString(String str) =>
      RoadmapModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
}

class UniqueKey {
  @override
  String toString() => DateTime.now().microsecondsSinceEpoch.toString();
}
