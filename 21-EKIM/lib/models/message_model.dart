import 'package:flutter/foundation.dart';

@immutable
class MessageModel {
  final String id;
  final String appointmentId;
  final String senderId;
  final String senderName;
  final String message;
  final String timestamp;
  final String createdAt;

  const MessageModel({
    required this.id,
    required this.appointmentId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
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
