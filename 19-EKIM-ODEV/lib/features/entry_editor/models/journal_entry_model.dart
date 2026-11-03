import 'package:flutter/foundation.dart';

/// Değişmez (Immutable) Günlük Kaydı Veri Modeli.
@immutable
class JournalEntry { // JournalEntry sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String title; // String türünden title adlı değişkenimiz
  final String content; // String türünden content adlı değişkenimiz
  final DateTime createdAt; // DateTime türünden createdAt adlı değişkenimiz
  final String? mood; // String? türünden mood adlı değişkenimiz
  final List<String> tags; // List<String> türünden tags adlı değişkenimiz

  const JournalEntry({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.title, // title parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.content, // content parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.createdAt, // createdAt parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    this.mood, // mood alanına değer aktarıyoruz
    this.tags = const [], // tags alanına değer aktarıyoruz
  });

  JournalEntry copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? mood,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id, // id alanına değer aktarıyoruz
      title: title ?? this.title, // title alanına değer aktarıyoruz
      content: content ?? this.content, // content alanına değer aktarıyoruz
      createdAt: createdAt ?? this.createdAt, // createdAt alanına değer aktarıyoruz
      mood: mood ?? this.mood, // mood alanına değer aktarıyoruz
      tags: tags ?? this.tags, // tags alanına değer aktarıyoruz
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return JournalEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      mood: json['mood'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'mood': mood,
      'tags': tags,
    };
  }

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          createdAt == other.createdAt &&
          mood == other.mood &&
          listEquals(tags, other.tags);

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      (mood?.hashCode ?? 0) ^
      tags.hashCode;
}
