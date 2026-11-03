import 'package:flutter/foundation.dart';

/// Su Tüketim Kaydı Modeli (İmmutable)
@immutable
class WaterEntryModel { // WaterEntryModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final int amountMl; // int türünden amountMl adlı değişkenimiz
  final DateTime timestamp; // DateTime türünden timestamp adlı değişkenimiz
  final String? note; // String? türünden note adlı değişkenimiz

  const WaterEntryModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.amountMl, // amountMl parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.timestamp, // timestamp parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.note, // note alanına değer aktarıyoruz
  });

  WaterEntryModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? note,
  }) {
    return WaterEntryModel(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      amountMl: amountMl ?? this.amountMl, // amountMl alanına değer aktarıyoruz
      timestamp: timestamp ?? this.timestamp, // timestamp alanına değer aktarıyoruz
      note: note ?? this.note, // note alanına değer aktarıyoruz
    );
  }

  factory WaterEntryModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return WaterEntryModel(
      id: json['id'] as String? ?? '',
      amountMl: (json['amountMl'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return <String, dynamic>{
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amountMl == other.amountMl &&
          timestamp == other.timestamp &&
          note == other.note;

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  int get hashCode => Object.hash(id, amountMl, timestamp, note);
}
