import 'package:flutter/material.dart'; // Flutter'ın hazır Material Design widget'larını ve arayüz paketini içeri aktarıyoruz
import '../../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget { // StatusBadge sınıfı, durumu değişmeyen sabit bir arayüz sunduğumuz StatelessWidget yapımızdır
  final String status; // String türünden status adlı değişkenimiz

  const StatusBadge({super.key, required this.status}); // Sabit constructor, üst sınıfa key parametresini gönderir

  @override // Üst sınıftaki metodu ezerek kendi ihtiyacımıza göre yeniden yazıyoruz
  Widget build(BuildContext context) { // Arayüzün ekrana çizildiği ana build metodumuz, context ağaçtaki yerini belirtir
    Color textColor;
    Color bgColor;
    String label;

    switch (status) {
      case 'onaylandi':
        textColor = AppColors.approvedText;
        bgColor = AppColors.approvedBg;
        label = 'Onaylandı';
        break;
      case 'iptal':
        textColor = AppColors.cancelledText;
        bgColor = AppColors.cancelledBg;
        label = 'İptal Edildi';
        break;
      case 'bitti':
        textColor = AppColors.completedText;
        bgColor = AppColors.completedBg;
        label = 'Tamamlandı';
        break;
      case 'beklemede':
      default:
        textColor = AppColors.pendingText;
        bgColor = AppColors.pendingBg;
        label = 'Beklemede';
    }

    return Container( // Boyut, kenarlık veya arka plan dekorasyonu vermek için Container kutusu kullanıyoruz
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration( // Kutuya arka plan rengi, yuvarlak kenarlar veya gölge gibi süslemeler vermek için
        color: bgColor,
        borderRadius: BorderRadius.circular(20), // Köşeleri yuvarlatıp modern bir görünüm veriyoruz
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
