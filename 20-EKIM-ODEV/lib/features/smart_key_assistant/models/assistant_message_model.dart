// Flutter foundation paketinden değişmezlik (@immutable) tanımını içe aktarıyoruz
import 'package:flutter/foundation.dart';

/// TakeGO Yol Asistanı Mesaj Modeli (AssistantMessageModel)
///
/// Kullanıcı ile akıllı yol asistanı arasındaki soru-cevap
/// sohbet geçmişini temsil eden `@immutable` veri modelidir.
@immutable
class AssistantMessageModel { // AssistantMessageModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  // ---------------------------------------------------------------------------
  // MODEL ALANLARI (Properties)
  // ---------------------------------------------------------------------------

  /// Mesajın benzersiz kimlik bilgisi (Örn: 'msg-1', 'msg-user-1718000')
  final String id; // String türünden id adlı değişkenimiz

  /// Mesajın kullanıcıya veya asistana ait metin içeriği
  final String text; // String türünden text adlı değişkenimiz

  /// Mesajın kullanıcı tarafından mı (true) yoksa asistandan mı (false) gönderildiği
  final bool isUser; // bool türünden isUser adlı değişkenimiz

  /// Mesajın gönderildiği anlık tarih ve saat zaman damgası
  final DateTime timestamp; // DateTime türünden timestamp adlı değişkenimiz

  // ---------------------------------------------------------------------------
  // KURUCU METOT (Constructor)
  // ---------------------------------------------------------------------------

  /// Sabit kurucu metot: Tüm alanları zorunlu olarak alır
  const AssistantMessageModel({ // Genel, sabit sınıf constructor'ı
    // Benzersiz kimlik (Zorunlu alan)
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Mesaj metni (Zorunlu alan)
    required this.text, // text parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Kullanıcı mesajı bayrağı (Zorunlu alan)
    required this.isUser, // isUser parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    // Zaman damgası (Zorunlu alan)
    required this.timestamp, // timestamp parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  // ---------------------------------------------------------------------------
  // YARDIMCI KOPYALAMA METODU (CopyWith)
  // ---------------------------------------------------------------------------

  /// Mevcut modelin belirli alanlarını güncelleyerek yeni bir değişmez nesne üretir
  AssistantMessageModel copyWith({ // Mevcut nesnenin bazı alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
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
      id: id ?? this.id, // id alanına değer aktarıyoruz
      // Varsa yeni metin, yoksa eski metin kullanılır
      text: text ?? this.text, // text alanına değer aktarıyoruz
      // Varsa yeni kullanıcı bayrağı, yoksa eski bayrak kullanılır
      isUser: isUser ?? this.isUser, // isUser alanına değer aktarıyoruz
      // Varsa yeni zaman damgası, yoksa eski zaman damgası kullanılır
      timestamp: timestamp ?? this.timestamp, // timestamp alanına değer aktarıyoruz
    );
  }

  // ---------------------------------------------------------------------------
  // EŞİTLİK VE HASHCODE OVERRIDE İŞLEMLERİ
  // ---------------------------------------------------------------------------

  /// İki mesaj nesnesinin aynı id'ye sahip olup olmadığını kontrol eden eşitlik operatörü
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  bool operator ==(Object other) =>
      // Bellek referansı aynıysa doğrudur
      identical(this, other) ||
      // veya diğer nesne AssistantMessageModel tipinde ve id'si aynıysa doğrudur
      other is AssistantMessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  /// id alanına göre hesaplanan benzersiz karma kodu (hashCode)
  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  int get hashCode => id.hashCode;
}
