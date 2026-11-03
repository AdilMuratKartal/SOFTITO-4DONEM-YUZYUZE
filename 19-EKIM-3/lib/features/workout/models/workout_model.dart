import 'package:flutter/foundation.dart';

/// Egzersiz ve Kalori Modeli (İmmutable)
@immutable
class WorkoutModel { // WorkoutModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String title; // String türünden title adlı değişkenimiz
  final String type; // String türünden type adlı değişkenimiz
  final int durationMinutes; // int türünden durationMinutes adlı değişkenimiz
  final int caloriesBurned; // int türünden caloriesBurned adlı değişkenimiz
  final int waterNeededMl; // int türünden waterNeededMl adlı değişkenimiz
  final DateTime timestamp; // DateTime türünden timestamp adlı değişkenimiz

  const WorkoutModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.type, // type parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.durationMinutes, // durationMinutes parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.caloriesBurned, // caloriesBurned parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.waterNeededMl, // waterNeededMl parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.timestamp, // timestamp parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  WorkoutModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? title,
    String? type,
    int? durationMinutes,
    int? caloriesBurned,
    int? waterNeededMl,
    DateTime? timestamp,
  }) {
    return WorkoutModel(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      title: title ?? this.title, // title alanına değer aktarıyoruz
      type: type ?? this.type, // type alanına değer aktarıyoruz
      durationMinutes: durationMinutes ?? this.durationMinutes, // durationMinutes alanına değer aktarıyoruz
      caloriesBurned: caloriesBurned ?? this.caloriesBurned, // caloriesBurned alanına değer aktarıyoruz
      waterNeededMl: waterNeededMl ?? this.waterNeededMl, // waterNeededMl alanına değer aktarıyoruz
      timestamp: timestamp ?? this.timestamp, // timestamp alanına değer aktarıyoruz
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
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

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
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

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
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

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
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
