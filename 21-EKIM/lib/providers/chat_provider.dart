import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../models/message_model.dart'; // Verilerimizin şablonu olan model sınıflarını bu sayfada kullanmak için dahil ediyoruz
import '../core/services/json_data_service.dart'; // Veri çekme ve API haberleşmesini yapan servis katmanımızı dahil ediyoruz

class ChatProvider extends ChangeNotifier { // ChatProvider sınıfı, dinleyicilere değişiklik haberini yayan ChangeNotifier yapımızdır
  final JsonDataService dataService; // JsonDataService türünden dataService adlı değişkenimiz
  List<MessageModel> _messages = [];
  bool _isLoading = false; // Durum kontrolü için tuttuğumuz bool bayrağımız (_isLoading)

  ChatProvider({required this.dataService}); // dataService parametresinin verilmesinin zorunlu olduğunu söylüyoruz

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
