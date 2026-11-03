import 'dart:convert'; // JSON çözümleme (jsonDecode) ve dönüştürme işlemleri için bu paketi ekliyoruz
import 'package:flutter/foundation.dart';

enum HabitType { checkmark, counter, timer } // HabitType enum yapısı, belirli sabit seçenekleri tip güvenli şekilde listelememizi sağlar

@immutable
class HabitModel { // HabitModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String title; // String türünden title adlı değişkenimiz
  final String categoryId; // String türünden categoryId adlı değişkenimiz
  final String iconPath; // String türünden iconPath adlı değişkenimiz
  final HabitType type; // HabitType türünden type adlı değişkenimiz
  final List<int> selectedDays; // [1..7] (1: Pzt, 7: Paz)
  final String startTime;       // Örn: '09:45'
  final String endTime;         // Örn: '15:36'
  final bool hasReminder; // bool türünden hasReminder adlı değişkenimiz
  final double currentProgress; // double türünden currentProgress adlı değişkenimiz
  final double targetProgress; // double türünden targetProgress adlı değişkenimiz
  final String unit; // String türünden unit adlı değişkenimiz
  final int streakDays; // int türünden streakDays adlı değişkenimiz
  final bool isCompleted; // bool türünden isCompleted adlı değişkenimiz
  final DateTime createdAt; // DateTime türünden createdAt adlı değişkenimiz

  const HabitModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.categoryId, // categoryId parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.iconPath, // iconPath parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.type = HabitType.checkmark, // type alanına değer aktarıyoruz
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7], // selectedDays alanına değer aktarıyoruz
    required this.startTime, // startTime parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.endTime, // endTime parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.hasReminder = false, // hasReminder alanına değer aktarıyoruz
    this.currentProgress = 0.0, // currentProgress alanına değer aktarıyoruz
    this.targetProgress = 1.0, // targetProgress alanına değer aktarıyoruz
    this.unit = 'kez', // unit alanına değer aktarıyoruz
    this.streakDays = 0, // streakDays alanına değer aktarıyoruz
    this.isCompleted = false, // isCompleted alanına değer aktarıyoruz
    required this.createdAt, // createdAt parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  HabitModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
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
      title: title ?? this.title, // title alanına değer aktarıyoruz
      categoryId: categoryId ?? this.categoryId, // categoryId alanına değer aktarıyoruz
      iconPath: iconPath ?? this.iconPath, // iconPath alanına değer aktarıyoruz
      type: type ?? this.type, // type alanına değer aktarıyoruz
      selectedDays: selectedDays ?? this.selectedDays, // selectedDays alanına değer aktarıyoruz
      startTime: startTime ?? this.startTime, // startTime alanına değer aktarıyoruz
      endTime: endTime ?? this.endTime, // endTime alanına değer aktarıyoruz
      hasReminder: hasReminder ?? this.hasReminder, // hasReminder alanına değer aktarıyoruz
      currentProgress: currentProgress ?? this.currentProgress, // currentProgress alanına değer aktarıyoruz
      targetProgress: targetProgress ?? this.targetProgress, // targetProgress alanına değer aktarıyoruz
      unit: unit ?? this.unit, // unit alanına değer aktarıyoruz
      streakDays: streakDays ?? this.streakDays, // streakDays alanına değer aktarıyoruz
      isCompleted: isCompleted ?? this.isCompleted, // isCompleted alanına değer aktarıyoruz
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

  factory HabitModel.fromJson(String source) => // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
      HabitModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
