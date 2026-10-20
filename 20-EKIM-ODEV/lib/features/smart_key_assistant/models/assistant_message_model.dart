// Flutter foundation paketinden değişmezlik (@immutable) tanımını içe aktarıyoruz
import 'package:flutter/foundation.dart';

/// TakeGO Yol Asistanı Mesaj Modeli (AssistantMessageModel)
///
/// Kullanıcı ile akıllı yol asistanı arasındaki soru-cevap
/// sohbet geçmişini temsil eden `@immutable` veri modelidir.
@immutable
class AssistantMessageModel {
  // ---------------------------------------------------------------------------
  // MODEL ALANLARI (Properties)
  // ---------------------------------------------------------------------------

  /// Mesajın benzersiz kimlik bilgisi (Örn: 'msg-1', 'msg-user-1718000')
  final String id;

  /// Mesajın kullanıcıya veya asistana ait metin içeriği
  final String text;

  /// Mesajın kullanıcı tarafından mı (true) yoksa asistandan mı (false) gönderildiği
  final bool isUser;

  /// Mesajın gönderildiği anlık tarih ve saat zaman damgası
  final DateTime timestamp;

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Tüm alanları zorunlu olarak alır
  const AssistantMessageModel({
    // Benzersiz kimlik (Zorunlu alan)
    required this.id,
    // Mesaj metni (Zorunlu alan)
    required this.text,
    // Kullanıcı mesajı bayrağı (Zorunlu alan)
    required this.isUser,
    // Zaman damgası (Zorunlu alan)
    required this.timestamp,
  });

  // ---------------------------------------------------------------------------
  // YARDIMCI KOPYALAMA METODU (CopyWith)
  // ---------------------------------------------------------------------------

  /// Mevcut modelin belirli alanlarını güncelleyerek yeni bir değişmez nesne üretir
  AssistantMessageModel copyWith({
    // Yeni id değeri (Opsiyonel)
    String? id,
    // Yeni metin içeriği (Opsiyonel)
    String? text,
    // Yeni kullanıcı sahiplik durumu (Opsiyonel)
    bool? isUser,
    // Yeni zaman damgası (Opsiyonel)
    DateTime? timestamp,
  }) {
    // Yeni kopya nesneyi döndürüyoruz
    return AssistantMessageModel(
      // Varsa yeni id, yoksa eski id kullanılır
      id: id ?? this.id,
      // Varsa yeni metin, yoksa eski metin kullanılır
      text: text ?? this.text,
      // Varsa yeni kullanıcı bayrağı, yoksa eski bayrak kullanılır
      isUser: isUser ?? this.isUser,
      // Varsa yeni zaman damgası, yoksa eski zaman damgası kullanılır
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // ---------------------------------------------------------------------------
  // EŞİTLİK VE HASHCODE OVERRIDE İŞLEMLERİ
  // ---------------------------------------------------------------------------

  /// İki mesaj nesnesinin aynı id'ye sahip olup olmadığını kontrol eden eşitlik operatörü
  @override
  bool operator ==(Object other) =>
      // Bellek referansı aynıysa doğrudur
      identical(this, other) ||
      // veya diğer nesne AssistantMessageModel tipinde ve id'si aynıysa doğrudur
      other is AssistantMessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  /// id alanına göre hesaplanan benzersiz karma kodu (hashCode)
  @override
  int get hashCode => id.hashCode;
}
