import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';

class ChatBubble extends StatelessWidget { // ChatBubble sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final String message; // String türünden message adlı değişkenimiz
  final String timestamp; // String türünden timestamp adlı değişkenimiz
  final bool isMe; // bool türünden isMe adlı değişkenimiz

  const ChatBubble({ // Genel, sabit sınıf constructor'ı
    super.key,
    required this.message, // message parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.timestamp, // timestamp parametresinin verilmesinin zorunlu olduğunu söylüyoruz
    required this.isMe, // isMe parametresinin verilmesinin zorunlu olduğunu söylüyoruz
  });

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 2),
            bottomRight: Radius.circular(isMe ? 2 : 12),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
        ),
        child: Column( // Çocuk widget'ları dikeyde alt alta dizmek için Column kullanıyoruz
          crossAxisAlignment: CrossAxisAlignment.end, // Çocukların çapraz eksendeki hizalamasını belirliyoruz
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4), // Widget'lar arasına yatayda veya dikeyde boşluk bırakmak için SizedBox kullanıyoruz
            Text(
              timestamp,
              style: TextStyle(
                color: isMe ? Colors.white70 : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
