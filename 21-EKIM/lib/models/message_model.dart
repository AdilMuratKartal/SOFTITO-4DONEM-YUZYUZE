import 'package:flutter/foundation.dart';

@immutable
class MessageModel { // MessageModel sınıfının açılışı, uygulamada kullanılacak verinin model şemasıdır
  final String id; // String türünden id adlı değişkenimiz
  final String appointmentId; // String türünden appointmentId adlı değişkenimiz
  final String senderId; // String türünden senderId adlı değişkenimiz
  final String senderName; // String türünden senderName adlı değişkenimiz
  final String message; // String türünden message adlı değişkenimiz
  final String timestamp; // String türünden timestamp adlı değişkenimiz
  final String createdAt; // String türünden createdAt adlı değişkenimiz

  const MessageModel({ // Genel, sabit sınıf constructor'ı
    required this.id, // id parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.appointmentId, // appointmentId parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.senderId, // senderId parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.senderName, // senderName parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.message, // message parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.timestamp, // timestamp parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.createdAt, // createdAt parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) { // Gelen JSON haritasını (Map) nesneye dönüştüren factory kurucumuz
    return MessageModel(
      id: json['id'] as String? ?? '',
      appointmentId: json['appointmentId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() { // Nesneyi sunucuya veya veritabanına göndermek için Map/JSON formatına çeviren metod
    return {
      'id': id,
      'appointmentId': appointmentId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
      'createdAt': createdAt,
    };
  }
}
