import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../core/services/json_data_service.dart';

class ChatProvider extends ChangeNotifier {
  final JsonDataService dataService;
  List<MessageModel> _messages = [];
  bool _isLoading = false;

  ChatProvider({required this.dataService});

  List<MessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _messages = await dataService.loadMessages();
    _isLoading = false;
    notifyListeners();
  }

  /// Randevuya ait mesajları kronolojik getir
  List<MessageModel> getMessagesByAppointment(String appointmentId) {
    return _messages.where((m) => m.appointmentId == appointmentId).toList();
  }

  /// Yeni mesaj gönderme
  void sendMessage({
    required String appointmentId,
    required String senderId,
    required String senderName,
    required String messageText,
  }) {
    if (messageText.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final newMessage = MessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      appointmentId: appointmentId,
      senderId: senderId,
      senderName: senderName,
      message: messageText.trim(),
      timestamp: timeStr,
      createdAt: now.toIso8601String(),
    );

    _messages = [..._messages, newMessage];
    notifyListeners();
  }
}
